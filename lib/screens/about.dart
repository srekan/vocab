import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('About'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.info_outline,
                size: 160.0,
              ),
              SizedBox(height: 12.0),
              Text(
                'About',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ],
          ),
        ));
  }
}
