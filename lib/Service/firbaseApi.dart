import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handlebackround(RemoteMessage message)async{
  print("title:${message.notification!.title}");
  print("body:${message.notification!.body}");
  
}

class firbaseApi{
  final _firebaseMessage = FirebaseMessaging.instance;

  Future<void> init()async{
    await _firebaseMessage.requestPermission();
    final fcm = await _firebaseMessage.getToken();
    print("token:$fcm");
    FirebaseMessaging.onBackgroundMessage(handlebackround);
  }
}