import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Notification Settings'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.notifications,
                size: 160.0,
              ),
              SizedBox(height: 12.0),
              Text(
                'Notification Settings',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ],
          ),
        ));
  }
}
