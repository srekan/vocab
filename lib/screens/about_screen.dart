import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import '../theme/vocab.dart';
import '../constants.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Wrap(
            children: <Widget>[
              Text('Vocab by English House',
                  style: ThemeVocab.textTheme.display1),
              Divider(
                color: Colors.blueGrey,
              ),
              Text('What is vocab', style: ThemeVocab.textTheme.headline),
              Divider(color: Colors.transparent),
              _buildVocabLogo(),
              Divider(color: Colors.transparent),
              Text(
                  'Vocab is a mobile application which helps students to master english vocabulary faster.',
                  style: ThemeVocab.textTheme.body1),
              Divider(color: Colors.transparent),
              Divider(color: Colors.transparent),
              Text('What is English House',
                  style: ThemeVocab.textTheme.headline),
              Text(
                  'English House is a finishing school specialised for Spoken English and Soft skills training',
                  style: ThemeVocab.textTheme.body1),
              Divider(color: Colors.transparent),
              Text(
                  'English House creates digital training material to help students to learn English faster',
                  style: ThemeVocab.textTheme.body1),
              Divider(color: Colors.transparent),
              Divider(color: Colors.transparent),
              Text('Contact US', style: ThemeVocab.textTheme.headline),
              Wrap(
                children: <Widget>[
                  _buildEngLogo(),
                  _buildPhone(),
                  _buildMap(),
                  _buildMail(),
                ],
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }

  _buildEngLogo() {
    return InkWell(
      splashColor: Colors.blue,
      onTap: () async {
        if (await canLaunch(AppConstants.englishhouseUrl)) {
          await launch(AppConstants.englishhouseUrl);
        }
      },
      child: Card(
        elevation: 4,
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/logo.jpeg',
              height: 100,
              width: 200,
            ),
            Text(
              'englishhouse.in',
              style: TextStyle(color: Colors.blue),
            ),
            SizedBox(height: 8)
          ],
        ),
      ),
    );
  }

  _buildVocabLogo() {
    return InkWell(
      splashColor: Colors.blue,
      onTap: () {
        Share.share(AppConstants.playStroeUrl);
      },
      child: Card(
        elevation: 4,
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/vocab-logo.png',
              height: 100,
              width: 200,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.share, color: Colors.green),
                Text(
                  ' Share Vocab app',
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  _buildMail() {
    return InkWell(
      splashColor: Colors.blue,
      onTap: () async {
        var url = 'mailto:' + AppConstants.email + '?subject=From Vocab';
        if (await canLaunch(url)) {
          await launch(url);
        }
      },
      child: Card(
          elevation: 4,
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.email,
                  size: 92,
                  color: Colors.orange[300],
                ),
                Text(
                  'apps.englishhouse@gmail.com',
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          )),
    );
  }

  _buildPhone() {
    return InkWell(
      splashColor: Colors.blue,
      onTap: () async {
        var url = 'tel:' + AppConstants.phone;
        if (await canLaunch(url)) {
          await launch(url);
        }
      },
      child: Card(
          elevation: 4,
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.phone,
                  size: 92,
                  color: Colors.green[300],
                ),
                Text(
                  '+91 80080 30033',
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          )),
    );
  }

  _buildMap() {
    return InkWell(
      splashColor: Colors.blue,
      onTap: () async {
        var url = AppConstants.mapUrl;
        if (await canLaunch(url)) {
          await launch(url);
        }
      },
      child: Card(
          elevation: 4,
          child: Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Icon(
                        Icons.pin_drop,
                        size: 92,
                        color: Colors.pink[800],
                      ),
                      Text(
                        'Open in maps',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Beside SBI, Fort Jn.,',
                        style: ThemeVocab.textTheme.title,
                      ),
                      Text(
                        'Vizianagaram,',
                        style: ThemeVocab.textTheme.title,
                      ),
                      Text(
                        'Andhra Pradesh,',
                        style: ThemeVocab.textTheme.title,
                      ),
                      Text(
                        'India 535001',
                        style: ThemeVocab.textTheme.title,
                      ),
                    ],
                  ),
                ],
              ))),
    );
  }
}
