import 'package:flutter/material.dart';
import './screens/splash.dart';
import './screens/dashboard.dart';
import './screens/group_detail.dart';
import './screens/about_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vocabulary App',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: SplashScreen(),
      routes: {
        'dash_board': (context) => DashBoardScreen(),
        'group_detail': (context) => GroupDetailScreen(),
        'about': (context) => AboutScreen(),
      },
    );
  }
}
