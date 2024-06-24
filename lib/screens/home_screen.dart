import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  Future pushNotification(
      {required String targetToken,
      required String title,
      required String body}) async {
    final String jsonCredentials =
        await rootBundle.loadString('assets/notifications_key.json');

    final ServiceAccountCredentials creds =
        ServiceAccountCredentials.fromJson(jsonCredentials);

    final client = await clientViaServiceAccount(
        creds, ['https://www.googleapis.com/auth/cloud-platform']);

    const String senderId = ;

    final response = await client.post(
      Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$senderId/messages:send'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode(
        {
          'message': {
            'token': targetToken,
            'notification': {'title': title, 'body': body}
          }
        },
      ),
    );
    client.close();

    if (response.statusCode == 200) {
      debugPrint('Success statusCode: ${response.statusCode}');
    } else {
      debugPrint("Error ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () async {
              String? token = await FirebaseMessaging.instance.getToken();
              await pushNotification(
                targetToken: token ?? '',
                title: 'this is notification for title',
                body: 'this is notification for body',
              );
            },
          ),
        ],
        title: const Text('Firebase Messaging'),
      ),
    );
  }
}
