//import 'dart:js';

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/Service/Notification_service.dart';
import 'package:flutter_firebase/Service/auth_services.dart';
import 'package:flutter_firebase/Service/chat_services.dart';
import 'package:flutter_firebase/pages/chatbuble.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class Chatpage extends StatefulWidget {
 final String recieverEmail;
  final String recieverId;

  
  const Chatpage({super.key,required this.recieverEmail,required this.recieverId});


  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  
  File? _image;
  final imagePicker = ImagePicker();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  

  final TextEditingController messagecon = TextEditingController();

  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String? imageUrl ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  

Future<String?> retrieveToken(String tokenId) async {
  final String serverUrl = 'http://localhost:3000/store/$tokenId';

  try {
    final http.Response response = await http.get(Uri.parse(serverUrl));

    if (response.statusCode == 200) {
      // Parse the JSON response and extract the token
      final Map<String, dynamic> data = json.decode(response.body);
      return data['token'];
    } else {
      print('Failed to retrieve FCM token: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error retrieving FCM token: $e');
    return null;
  }
}

Future<void> sendNotification(String recipientToken, String title, String body) async {
  // Call sendTokenToServer to store the recipient's FCM token on the server
  
  // Send notification to recipient
  // Define your notification payload
  final Map<String, dynamic> notification = {
    'title': title,
    'body': body,
    'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  };

  // Construct data payload
  final Map<String, dynamic> data = {
    'notification': notification,
    'to': recipientToken,
  };

  // Define FCM endpoint
  final String fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';

  try {
    // Send HTTP POST request to FCM endpoint
    final http.Response response = await http.post(
      Uri.parse(fcmEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=YOUR_SERVER_KEY', // Replace with your server key
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification: ${response.body}');
    }
  } catch (e) {
    print('Error sending notification: $e');
  }
}

// Function to send FCM token to server



  void sendMessage()async{
    if(messagecon.text.isNotEmpty){
      await chatService.sendMessage( recieverId:widget.recieverId,message: messagecon.text,image: "text");
      messagecon.clear();
    
     final String? token = await retrieveToken(widget.recieverId);

     if (token != null) {
   await sendNotification(token,widget.recieverEmail,messagecon.text);
  } else {
    print('Failed to retrieve FCM token');
  }
    }
  }


 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(stream: firebaseFirestore.collection("Users").doc(widget.recieverId).snapshots() ,builder: (context,snapshot){
          if (snapshot.data !=null){
            return Container(
              child: Column(
                children: [
                  Text(widget.recieverEmail),
                  Text(snapshot.data?["status"])
                ],
              ),
            );
          }
          else return Container();
        }),
        ),
      body: Column(
        children: [
          Expanded(
            child: messageList()
          ),
          buildInput()
        ],
      ),
    );
  }

  Widget messageList(){
    String senderId = authService.getCurrentUser()!.uid;
    return StreamBuilder(stream: chatService.getMessages(widget.recieverId, senderId),builder: (context,snapshot){
      if(snapshot.hasError){
        return const Text("Error");
      }
      if(snapshot.connectionState == ConnectionState.waiting){
        return const Text("Loading");
      }
      var latestMessage = snapshot.data!.docs.last;
        // Trigger a notification when a new message is received
        // _firebaseMessaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
        // _firebaseMessaging.getNotificationSettings(
        //   notification: Notification(
        //     title: 'New Message',
        //     body: latestMessage['message'],
        //   ),
        // );
        bool iscurrentuser = latestMessage["senderId"] == authService.getCurrentUser()!.uid;
       
      return ListView(
        children: snapshot.data!.docs.map<Widget>((doc) => buildMessge(doc)).toList(),
      );
    });
  }
  
  Widget buildMessge(DocumentSnapshot doc){
    Map<String,dynamic> data=doc.data() as Map<String,dynamic>;
    bool iscurrentuser = data["senderId"] == authService.getCurrentUser()!.uid;
    var align = iscurrentuser?Alignment.centerRight:Alignment.centerLeft;
    return Container(alignment: align,child: Column(
      crossAxisAlignment: iscurrentuser?CrossAxisAlignment.start:CrossAxisAlignment.end,
      children: [
        Chatbuble(message: data["message"], iscurrentuser: iscurrentuser,image:data["type"] ,)
      ],
    ));

  }

  Widget buildInput(){
    return Padding(
      
      padding: const EdgeInsets.only(bottom:0.0),
      child: Container(
        decoration: BoxDecoration(
              //borderRadius: BorderRadius.only(topLeft: ), // Border radius
              border: Border.all(
                color: Colors.black87, // Border color
                ////width: 2.0, // Border width
              ),
            ),
        child: Row(
          children: [
            Expanded(child: Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: messagecon,
                
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "enter message",
                  suffixIcon: IconButton(onPressed: _pickimage, icon: Icon(Icons.photo)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            )),
            Container(
              decoration: BoxDecoration(color: Colors.green,shape: BoxShape.circle),
              margin: EdgeInsets.only(right: 25),
              child: IconButton(onPressed: sendMessage, icon: Icon(Icons.send)))
          ],
        ),
      ),
    );
  }

  Future _pickimage() async{
    try{
              final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
               //String? img=pickedFile?.path;
              if (pickedFile== null) return;
              _image=File(pickedFile!.path);
                 uploadimage();
                
              }
              catch(e){
                print("");
                //return "error";
              }
  }

  Future uploadimage()async{
    
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    int status = 1;
    
    final String curuId = firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();
    List<String> ids=[curuId,widget.recieverId];
    ids.sort();
    String chatroomId = ids.join("_");
    await firebaseFirestore.collection("chat_rooms").doc(chatroomId).collection("messages").doc(fileName).set({
      "senderId":curuId,
      "senderEmail":widget.recieverEmail,
      "recieverId":widget.recieverId,
      "message":"",
      "type":"img",
      "timestamp":timestamp
    });
  Reference storageReference = FirebaseStorage.instance.ref().child('images').child(fileName);
  
    await storageReference.putFile(_image!).catchError((error)async{
      await firebaseFirestore.collection("chat_rooms").doc(chatroomId).collection("messages").doc(fileName).delete();
      status=0;
    });
    
     if(status == 1){
       imageUrl = await storageReference.getDownloadURL();
       await firebaseFirestore.collection("chat_rooms").doc(chatroomId).collection("messages").doc(fileName).update({
        "message":imageUrl
       });
     }
  

  // var taskSnapshot = await uploadTask;
  // String imageUrl = await taskSnapshot.ref.getDownloadURL();
  }
}