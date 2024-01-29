import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/Service/auth_services.dart';
import 'package:flutter_firebase/Service/chat_services.dart';
import 'package:flutter_firebase/pages/chatpage.dart';
import 'package:flutter_firebase/pages/userTile.dart';

class Home extends StatelessWidget {
   Home({super.key});

  void logout(){
    final auth=AuthService();
    auth.signout();
  }
  final ChatService chatServive=ChatService();
  final AuthService authService = AuthService();

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home"),
      
      ),
      body: _builduser(),
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
    if(userData["email"] != authService.getCurrentUser()){
    return UserTile(text: userData["email"],ontap: () {
      
      Navigator.push(context, MaterialPageRoute(builder: (context) => Chatpage(recieverEmail: userData["email"])));
    },
    );}
    else return Container();
  }
}