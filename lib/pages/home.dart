//import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/Service/auth_services.dart';
import 'package:flutter_firebase/Service/chat_services.dart';
import 'package:flutter_firebase/pages/chatpage.dart';
import 'package:flutter_firebase/pages/userTile.dart';



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver{
  void logout(){
    final auth=AuthService();
    auth.signout();
  }
  final ChatService chatServive=ChatService();
  final AuthService authService = AuthService();
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final DataRef= FirebaseDatabase.instance.ref("chat/Users");
  //final FirebaseAuth firebaseAuth=FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("online");
    
  }

  void setStatus(String status)async{
   await firebaseFirestore.collection("Users").doc(authService.getCurrentUser()!.uid).update({
    "status":status
   });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    
      if(state == AppLifecycleState.resumed){
        setStatus("online");
      }
      else{
        setStatus("offline");
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home"),
      actions: [
            // Logout Icon Button
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                logout();
              },
            ),
          ],
      ),
      body: _builduser()
    //   Column(
    //     children: [
    //       Expanded(child: FirebaseAnimatedList(query: DataRef, itemBuilder: (context,snapshot,index,animation){
    //        // Map<String,dynamic> userData; 
    //         final emails =snapshot.child("email").value.toString();
    //         final uid = snapshot.child("uid").value.toString();
    //         if(emails != authService.getCurrentUser()!.email){
    //         return ListTile(
    //           title:Text(snapshot.child("email").value.toString()),
    //           onTap: () {
      
    //   Navigator.push(context, MaterialPageRoute(builder: (context) => Chatpage(recieverEmail: emails,recieverId: uid,)));
    // },
    //         );}
    //         else return Container();
    //       }))
    //     ],
    //   ),
    );
  }

  Widget _builduser(){
    return StreamBuilder(stream: chatServive.getUsersStream(), builder: (context,snapshot){
      if(snapshot.hasError){
        return const Text("Error");
      }
      if(snapshot.connectionState == ConnectionState.waiting){
        return const Text("Loading");
      }
      return ListView(
        children: snapshot.data!.map<Widget>((userdata) => _buildUserListItem(userdata,context)).toList(),
      );
    });
  }
  Widget _buildUserListItem(Map<String,dynamic> userData ,BuildContext context){
    if(userData["email"] != authService.getCurrentUser()!.email){
    return UserTile(text: userData["email"],ontap: () {
      
      Navigator.push(context, MaterialPageRoute(builder: (context) => Chatpage(recieverEmail: userData["email"],recieverId: userData["uid"],)));
    },
    );}
    else return Container();
  }
}