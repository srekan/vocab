import 'package:flutter/material.dart';
import '../components/loaders/flip_loader.dart';
import '../theme/vocab.dart';
import '../theme/constants.dart';
import '../root_data.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (rootdata.isAppInitialized == false) {
      rootdata.initApp(context);
    }
    return Scaffold(
        body: Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: ThemeConstants.backgroundGradientRadial,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Material(
              elevation: 8.0,
              child: Image.asset('assets/logo.jpeg'),
            ),
            SizedBox(height: 12.0),
            Text('presents'),
            SizedBox(height: 12.0),
            Text(
              'Vocabulary App',
              style: ThemeVocab.textTheme.title,
            ),
            SizedBox(height: 12.0),
            SpinKitCubeGrid(
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    ));
  }
}
