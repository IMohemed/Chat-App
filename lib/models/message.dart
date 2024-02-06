import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  String senderId;
  String senderEmail;
  String recieverId;
  String message;
  String type;
  Timestamp timestamp;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.recieverId,
    required this.message,
    required this.timestamp,
    required this.type
  });

  Map<String,dynamic> toMap(){
    return{
      "senderId":senderId,
      "senderEmail":senderEmail,
      "recieverId":recieverId,
      "message":message,
      "type":type,
      "timestamp":timestamp
    };
  }
}