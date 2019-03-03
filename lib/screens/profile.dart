import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.person,
                size: 160.0,
              ),
              SizedBox(height: 12.0),
              Text(
                'Profile',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ],
          ),
        ));
  }
}
