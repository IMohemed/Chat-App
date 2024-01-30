import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Chatbuble extends StatelessWidget {
  final String message;
  final bool iscurrentuser;
  const Chatbuble({super.key,required this.message,required this.iscurrentuser});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: iscurrentuser?Colors.green:Colors.grey.shade500,
      borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 2.5,horizontal: 25),
      child: Text(message,style: TextStyle(color: Colors.white),),
    );
  }
}