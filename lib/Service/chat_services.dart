import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService{
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Stream <List<Map<String,dynamic>>> getUsersStream(){
    return firebaseFirestore.collection("Users").snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Future<void> sendMessage(String recieverId,Message)async{
    final String curuId = firebaseAuth.currentUser!.uid;
    final String curuEmail = firebaseAuth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
  }
}