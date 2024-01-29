import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  User? getCurrentUser(){
    return firebaseAuth.currentUser;
  }

  Future<UserCredential> signinWithEmailAndPAssword( String  email,password)async{
    try{
       UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email:email!, password: password!);
       firebaseFirestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid':userCredential.user!.uid,
          "email":email
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
       return userCredential;
    }on FirebaseAuthException catch(e){
      throw Expando(e.code);
    }
  }

  Future<void> signout()async{
    return await firebaseAuth.signOut();
  }
}