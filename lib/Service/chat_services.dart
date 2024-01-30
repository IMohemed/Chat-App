import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/models/message.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatService{
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final DataRef= FirebaseDatabase.instance.ref("");

  Stream <List<Map<String,dynamic>>> getUsersStream(){
    return firebaseFirestore.collection("Users").snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Future<void> sendMessage(String recieverId,message)async{
    final String curuId = firebaseAuth.currentUser!.uid;
    final String curuEmail = firebaseAuth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newmessage = Message(senderId: curuId, senderEmail: curuEmail, recieverId: recieverId, message: message, timestamp: timestamp);

    List<String> ids=[curuId,recieverId];
    ids.sort();
    String chatroomId = ids.join("_");

    await firebaseFirestore.collection("chat_rooms").doc(chatroomId).collection("messages").add(newmessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userId,otherUserId){
    List<String> ids = [userId,otherUserId];
    ids.sort();
    String chatroomId = ids.join("_");

    return firebaseFirestore.collection("chat_rooms").doc(chatroomId).collection("messages").orderBy("timestamp",descending: false).snapshots();
  }
}