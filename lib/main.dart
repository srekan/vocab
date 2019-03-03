import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './scopped_models/app_scopped_model.dart';
import './screens/signin.dart';
import './screens/home.dart';
import './screens/groups.dart';
import './screens/profile.dart';
import './screens/notifications.dart';
import './screens/settings.dart';
import './screens/about.dart';
import './screens/group_detail.dart';
import './root_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var app = MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
        routes: {
          'home': (context) => HomeScreen(),
          'profile': (context) => ProfileScreen(),
          'notifications': (context) => NotificationsScreen(),
          'settings': (context) => SettingsScreen(),
          'about': (context) => AboutScreen(),
          'groups': (context) => GroupsScreen(),
          'group_detail': (context) => GroupDetailScreen(),
          'signin': (context) => SignInScreen(),
        });

    return ScopedModel<AppScoppedModel>(
      model: RootData.app,
      child: app,
    );
  }
}
