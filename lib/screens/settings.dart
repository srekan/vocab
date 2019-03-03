import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.settings,
                size: 160.0,
              ),
              SizedBox(height: 12.0),
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ],
          ),
        ));
  }
}
