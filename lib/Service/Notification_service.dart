import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/main.dart';
import 'package:flutter_firebase/pages/home.dart';

class NotificationService{
  static Future<void> initializeNotification()async{
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelGroupKey: "high_notifcation_channel",
        channelKey: "high_notifcation_channel",
         channelName: "Basic notifications", 
         channelDescription: "notifcation channel for basic tests",
         defaultColor: const Color(0xFF9D58DD),
         ledColor: Colors.white,
         importance: NotificationImportance.Max,
         channelShowBadge: true,
         onlyAlertOnce: true,
         playSound: true
         )
    ],
    channelGroups: [
      NotificationChannelGroup(channelGroupKey: 'high_importance_channel_group', channelGroupName: 'Group 1')
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
    final payload = receivedAction.payload??{};
    if(payload["navigate"] == "true"){
      MyApp.navigateKey.currentState!.push(MaterialPageRoute(builder: (_) => const Home()));
    }
  }

  static Future<void> showNot({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String,String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? notificationCategory,
    final bool scheduled =false,
    final List<NotificationActionButton>? actionButton,
    final int? interval,
  }) async{
    assert(!scheduled || (scheduled && interval != null));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1, 
        channelKey: "high_importance_channel",
        title: title,
        body: body,
        actionType: actionType,
        summary: summary,
        payload: payload,
        category: notificationCategory
      ),
      actionButtons: actionButton,
      schedule: scheduled? NotificationInterval(
        interval: interval,
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        preciseAlarm: true
      ):null
      );
  }
}