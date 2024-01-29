import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Chatpage extends StatelessWidget {
  final String recieverEmail;
  const Chatpage({super.key,required this.recieverEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recieverEmail),),
    );
  }
}