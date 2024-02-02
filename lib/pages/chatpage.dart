//import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/Service/auth_services.dart';
import 'package:flutter_firebase/Service/chat_services.dart';
import 'package:flutter_firebase/pages/chatbuble.dart';

class Chatpage extends StatelessWidget {
  final String recieverEmail;
  final String recieverId;
  Chatpage({super.key,required this.recieverEmail,required this.recieverId});

  final TextEditingController messagecon = TextEditingController();

  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  void sendMessage()async{
    if(messagecon.text.isNotEmpty){
      await chatService.sendMessage(recieverId, messagecon.text);
      messagecon.clear();
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(stream: firebaseFirestore.collection("Users").doc(recieverId).snapshots() ,builder: (context,snapshot){
          if (snapshot.data !=null){
            return Container(
              child: Column(
                children: [
                  Text(recieverEmail),
                  Text(snapshot.data?["status"])
                ],
              ),
            );
          }
          else return Container();
        }),
        ),
      body: Column(
        children: [
          Expanded(
            child: messageList()
          ),
          buildInput()
        ],
      ),
    );
  }

  Widget messageList(){
    String senderId = authService.getCurrentUser()!.uid;
    return StreamBuilder(stream: chatService.getMessages(recieverId, senderId),builder: (context,snapshot){
      if(snapshot.hasError){
        return const Text("Error");
      }
      if(snapshot.connectionState == ConnectionState.waiting){
        return const Text("Loading");
      }
      return ListView(
        children: snapshot.data!.docs.map<Widget>((doc) => buildMessge(doc)).toList(),
      );
    });
  }

  Widget buildMessge(DocumentSnapshot doc){
    Map<String,dynamic> data=doc.data() as Map<String,dynamic>;
    bool iscurrentuser = data["senderId"] == authService.getCurrentUser()!.uid;
    var align = iscurrentuser?Alignment.centerRight:Alignment.centerLeft;
    return Container(alignment: align,child: Column(
      crossAxisAlignment: iscurrentuser?CrossAxisAlignment.start:CrossAxisAlignment.end,
      children: [
        Chatbuble(message: data["message"], iscurrentuser: iscurrentuser)
      ],
    ));

  }

  Widget buildInput(){
    return Padding(
      padding: const EdgeInsets.only(bottom:50.0),
      child: Row(
        children: [
          Expanded(child: TextField(
            controller: messagecon,
            
            obscureText: false,
            decoration: InputDecoration(
              labelText: "enter message",
            ),
          )),
          Container(
            decoration: BoxDecoration(color: Colors.green,shape: BoxShape.circle),
            margin: EdgeInsets.only(right: 25),
            child: IconButton(onPressed: sendMessage, icon: Icon(Icons.arrow_upward)))
        ],
      ),
    );
  }
}