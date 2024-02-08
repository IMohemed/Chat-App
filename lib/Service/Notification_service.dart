import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/main.dart';
import 'package:flutter_firebase/pages/home.dart';

class NotificationService{
  static Future<void> initializeNotification()async{
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: "high_notifcation_channel",
         channelName: "high_notifcation_channel", 
         channelDescription: "notifcation_channel",
         defaultColor: const Color(),
         ledColor: Colors.white,
         importance: NotificationImportance.Max,
         channelShowBadge: true,
         onlyAlertOnce: true,
         playSound: true
         )
    ],
    channelGroups: [
      NotificationChannelGroup(channelGroupKey: 'high-importance-channel-group', channelGroupName: 'goup1')
    ],debug: true
    );
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed)  async{
      if(!isAllowed){
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
      });
      await AwesomeNotifications().setListeners(onActionReceivedMethod: onActionReceivedMethod);


  }
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction)async{
    debugPrint("onActionRecievedMethod");
    final payload = receivedAction.payload??();
    if(payload["navigate"] == "true"){
      MyApp.navigateKey.currentState!.push(MaterialPageRoute(builder: (_) => const Home()));
    }
  }

  static Future<void> showNot({
    required final String title,
    required final String body,
    final String? summary,
    
  }) async{
    
  }
}