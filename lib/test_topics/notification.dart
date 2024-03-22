import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_course/test_topics/chat.dart';
import 'package:http/http.dart' as http;

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print(token);
  }

  requestPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  getInitMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      if (initialMessage.data["type"] == "chat") {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ChatPage()));
      } else {
        print(initialMessage.data["type"]);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermissions();
    getInitMessage();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data["type"] == "chat") {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ChatPage()));
      } else {
        print(message.data["type"]);
      }
    });

    // You should add this in main method to become on the app level
    // but we use it here for learning and test only
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          title: message.notification!.title,
          desc: message.notification!.body,
          btnOkOnPress: () {},
        ).show();
      }
    });
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          MaterialButton(
            color: Colors.blue,
            onPressed: () async {
              await FirebaseMessaging.instance.subscribeToTopic("adel");
            },
            child: Text("Subscribe"),
          ),
          MaterialButton(
            color: Colors.blue,
            onPressed: () async {
              await FirebaseMessaging.instance.unsubscribeFromTopic("adel");
            },
            child: Text("Unsubscribe"),
          ),
          MaterialButton(
            color: Colors.blue,
            onPressed: () async {
              await sendMessageByTopic("hi", "Using Topics", "adel");
            },
            child: Text("send a message"),
          ),
        ]),
      ),
    );
  }
}

sendMessageByToken(String title, String message) async {
  var headersList = {
    'Accept': '*/*',
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAAVzLMD8I:APA91bHhQDRvEVWjt1sHsSqQ9eKqVeY29XhWwFXgQpO-pqfErt7GWxBf4u9MrufieRPxHkf-maG-r5l_hV-OPC50UMqk97cMDPDQRkxqueRgeS57epWedpffTEYzaL3PZ2VE06dxJTmr'
  };
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

  var body = {
    "to":
        "euv05q0GQMCGPYWJLsBXGg:APA91bFPZU5zd_PaQPleIE1Kw3YjJqHKYE5skKvQ_XiTZ1NdnwJnI4KU9FOtUIJtLINS600J1bZR98QAZN09heiu6z2n2LB9g4YOlBRfHNzifmXMoMLad7pFWjRuBfyFyRVERRXErFCU",
    "notification": {"title": title, "body": message},
    "data": {"id": 12, "name": "Adel"}
  };

  var req = http.Request('POST', url);
  req.headers.addAll(headersList);
  req.body = json.encode(body);

  var res = await req.send();
  final resBody = await res.stream.bytesToString();

  if (res.statusCode >= 200 && res.statusCode < 300) {
    print(resBody);
  } else {
    print(res.reasonPhrase);
  }
}

sendMessageByTopic(String title, String message, String topic) async {
  var headersList = {
    'Accept': '*/*',
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAAVzLMD8I:APA91bHhQDRvEVWjt1sHsSqQ9eKqVeY29XhWwFXgQpO-pqfErt7GWxBf4u9MrufieRPxHkf-maG-r5l_hV-OPC50UMqk97cMDPDQRkxqueRgeS57epWedpffTEYzaL3PZ2VE06dxJTmr'
  };
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

  var body = {
    "to": "/topics/$topic",
    "notification": {"title": title, "body": message},
    "data": {"id": 12, "name": "Adel"}
  };

  var req = http.Request('POST', url);
  req.headers.addAll(headersList);
  req.body = json.encode(body);

  var res = await req.send();
  final resBody = await res.stream.bytesToString();

  if (res.statusCode >= 200 && res.statusCode < 300) {
    print(resBody);
  } else {
    print(res.reasonPhrase);
  }
}
