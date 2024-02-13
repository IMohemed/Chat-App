import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/Service/Notification_service.dart';
import 'package:flutter_firebase/Service/auth_services.dart';
import 'package:http/http.dart' as http;



class firbaseApi{
  final _firebaseMessage = FirebaseMessaging.instance;
  final AuthService authService = AuthService();
  Future<void> init()async{
    await _firebaseMessage.requestPermission();
    final fcm = await _firebaseMessage.getToken();
    String id = authService.getCurrentUser()!.uid;
    await sendTokenToServer(fcm!,id);

    print("token:$fcm");
    
    FirebaseMessaging.onBackgroundMessage(handlebackround);
  }

  Future<void> handlebackround(RemoteMessage message)async{
  print("title:${message.notification!.title}");
  print("body:${message.notification!.body}");
  String id = authService.getCurrentUser()!.uid;
  if(id==message.notification!.title)
  not(message.notification!.title,message.notification!.body);
}

  Future<void> sendTokenToServer(String token,id) async {
  // Define your server endpoint URL
  final String serverUrl = 'http://localhost:3000/store';

  try {
    // Make HTTP POST request to server endpoint
    final http.Response response = await http.post(
      Uri.parse(serverUrl),
      body: {
        'tokenId':id,
        'token': token,
      },
    );

    if (response.statusCode == 200) {
      print('FCM token sent to server successfully');
    } else {
      print('Failed to send FCM token to server: ${response.body}');
    }
  } catch (e) {
    print('Error sending FCM token to server: $e');
  }
}

Future<void> not(title,body)async{
  await NotificationService.showNot(title: title,body: body,payload: {"navigate":"true"},
  actionButton: [
    NotificationActionButton(
         key: "check", 
        label: "Read",
        actionType: ActionType.SilentAction,
        color: Colors.green
  )]);
  }
}

