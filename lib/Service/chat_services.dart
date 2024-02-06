//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/models/message.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatService{
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final   DataRef= FirebaseDatabase.instance.ref("chat");

  Stream <List<Map<String,dynamic>>> getUsersStream(){
    return firebaseFirestore.collection("Users").snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        final user = doc.data();
        return user;
      }).toList();
    });
  }
  // Stream<List<Map<String, dynamic>>> getUsersStream() {
  //   return DataRef.child("Users").onValue.map((event) { 
  //     DataSnapshot dataSnapshot = event.snapshot; 
  //     List<Map<String, dynamic>> users = [];

  //     if (dataSnapshot.value != null) {
  //       Map<String, dynamic> dataMap = dataSnapshot.value as Map<String, dynamic>;
  //       dataMap.forEach((key, value) {
  //       users.add(Map<String, dynamic>.from(value));});
  //     }

  //     return users;
  //   });
  // }

  Future<void> sendMessage({required String recieverId, message,image})async{
    final String curuId = firebaseAuth.currentUser!.uid;
    final String curuEmail = firebaseAuth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newmessage = Message(senderId: curuId, senderEmail: curuEmail, recieverId: recieverId, message: message,type: image, timestamp: timestamp);

    List<String> ids=[curuId,recieverId];
    ids.sort();
    String chatroomId = ids.join("_");

     await firebaseFirestore.collection("chat_rooms").doc(chatroomId).collection("messages").add(newmessage.toMap());
    //await DataRef.child("chat_rooms").child(chatroomId).child("messages").push().set(newmessage.toMap());
  }

  Stream<QuerySnapshot<Map<String,dynamic>>> getMessages(String userId,otherUserId){
    List<String> ids = [userId,otherUserId];
    ids.sort();
    String chatroomId = ids.join("_");
    //Future.delayed(Duration(seconds: 5));
    return firebaseFirestore.collection("chat_rooms").doc(chatroomId).collection("messages").orderBy("timestamp",descending: false).snapshots();
    
    //return DataRef.child("chat_rooms").child(chatroomId).child("messages").orderByChild("timestamp").onValue; 
  }
}