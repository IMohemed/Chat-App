import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService{
  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final DataRef= FirebaseDatabase.instance.ref("chat");

  User? getCurrentUser(){
    return firebaseAuth.currentUser;
  }

  Future<UserCredential> signinWithEmailAndPAssword( String  email,password)async{
    try{
      
       
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email:email!, password: password!);
         //firebaseFirestore.collection("Users").doc(userCredential.user!.uid).set(
         DataRef.child("Users").child(userCredential.user!.uid).set(
        {
          'uid':userCredential.user!.uid,
          "email":email,
          "status":"unavailable"
        },  
       );
       return userCredential;
       
       
    }on FirebaseAuthException catch(e){
      throw Expando(e.code);
    }
  }

  Future<UserCredential> signUpWithEmailAndPAssword( String  email,password)async{
    try{
       UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email:email!, password: password!);
       DataRef.child("Users").child(userCredential.user!.uid).set(
        {
          'uid':userCredential.user!.uid,
          "email":email,
          "status":"unavailable"
        },  
       );
       return userCredential;
    }on FirebaseAuthException catch(e){
      throw Expando(e.code);
    }
  }

  Future<void> signout()async{
    return await firebaseAuth.signOut();
  }
}