import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Chatbuble extends StatelessWidget {
  final String message,image;
  final bool iscurrentuser;
  const Chatbuble({super.key,required this.message,required this.iscurrentuser,required this.image});

  @override
  Widget build(BuildContext context) {
      Size size = MediaQuery.of(context).size;

    return image=='text'? Container(
      decoration: BoxDecoration(color: iscurrentuser?Colors.green:Colors.grey.shade500,
      borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 2.5,horizontal: 25),
      child: Text(message,style: TextStyle(color: Colors.white),),
    ):Container(
      height: size.height/2.5,
      width: size.width/2,
      child: message != "null"?Image.network(message):CircularProgressIndicator(),
    );
  }
}