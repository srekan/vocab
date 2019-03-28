import 'package:flutter/material.dart';
import '../theme/constants.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Container(
              child: Column(
                children: <Widget>[
                  Material(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    elevation: 5.0,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/logo.jpeg',
                        width: 150,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Vocabulary Builder',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            decoration:
                BoxDecoration(gradient: ThemeConstants.backgroundGradient),
          ),
          /*
          DrawerTile(
            icon: Icons.person,
            text: 'Profile',
          ),
          DrawerTile(
            icon: Icons.person,
            text: 'About App',
          ),
          
          DrawerTile(
            icon: Icons.power_settings_new,
            text: 'Logout',
            onTap: () {},
          ),
          */
        ],
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;
  DrawerTile({
    this.icon,
    this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Colors.grey[400],
      ))),
      child: Padding(
        padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.blue[300],
          child: Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(icon),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    )
                  ],
                ),
                Icon(Icons.arrow_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
