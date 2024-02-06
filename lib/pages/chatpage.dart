//import 'dart:js';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/Service/auth_services.dart';
import 'package:flutter_firebase/Service/chat_services.dart';
import 'package:flutter_firebase/pages/chatbuble.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class Chatpage extends StatefulWidget {
 final String recieverEmail;
  final String recieverId;

  
  const Chatpage({super.key,required this.recieverEmail,required this.recieverId});


  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  
  File? _image;
  final imagePicker = ImagePicker();
  

  final TextEditingController messagecon = TextEditingController();

  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String? imageUrl ;

  void sendMessage()async{
    if(messagecon.text.isNotEmpty){
      await chatService.sendMessage( recieverId:widget.recieverId,message: messagecon.text,image: "text");
      messagecon.clear();
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(stream: firebaseFirestore.collection("Users").doc(widget.recieverId).snapshots() ,builder: (context,snapshot){
          if (snapshot.data !=null){
            return Container(
              child: Column(
                children: [
                  Text(widget.recieverEmail),
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
    return StreamBuilder(stream: chatService.getMessages(widget.recieverId, senderId),builder: (context,snapshot){
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
        Chatbuble(message: data["message"], iscurrentuser: iscurrentuser,image:data["type"] ,)
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
              suffixIcon: IconButton(onPressed: _pickimage, icon: Icon(Icons.photo))
            ),
          )),
          Container(
            decoration: BoxDecoration(color: Colors.green,shape: BoxShape.circle),
            margin: EdgeInsets.only(right: 25),
            child: IconButton(onPressed: sendMessage, icon: Icon(Icons.send)))
        ],
      ),
    );
  }

  Future _pickimage() async{
    try{
              final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
               //String? img=pickedFile?.path;
              if (pickedFile== null) return;
              _image=File(pickedFile!.path);
                 uploadimage();
                
              }
              catch(e){
                print("");
                //return "error";
              }
  }

  Future uploadimage()async{
    
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    int status = 1;
    
    final String curuId = firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();
    List<String> ids=[curuId,widget.recieverId];
    ids.sort();
    String chatroomId = ids.join("_");
    await firebaseFirestore.collection("chat_rooms").doc(chatroomId).collection("messages").doc(fileName).set({
      "senderId":curuId,
      "senderEmail":widget.recieverEmail,
      "recieverId":widget.recieverId,
      "message":"",
      "type":"img",
      "timestamp":timestamp
    });
  Reference storageReference = FirebaseStorage.instance.ref().child('images').child(fileName);
  
    await storageReference.putFile(_image!).catchError((error)async{
      await firebaseFirestore.collection("chat_rooms").doc(chatroomId).collection("messages").doc(fileName).delete();
      status=0;
    });
    
     if(status == 1){
       imageUrl = await storageReference.getDownloadURL();
       await firebaseFirestore.collection("chat_rooms").doc(chatroomId).collection("messages").doc(fileName).update({
        "message":imageUrl
       });
     }
  

  // var taskSnapshot = await uploadTask;
  // String imageUrl = await taskSnapshot.ref.getDownloadURL();
  }
}