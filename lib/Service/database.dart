import 'package:cloud_firestore/cloud_firestore.dart';

class dbconnection{
  Future addUserDetails(Map<String,dynamic> userInfo,String id){
    return FirebaseFirestore.instance.collection("users").doc(id).set(userInfo);
  }
}