import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scopped_models/app_scopped_model.dart';
import './groups.dart';
import './signin.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppScoppedModel>(
      builder: (context, child, model) {
        return GroupsScreen();
        /*
        if(model.user != null){
          return GroupsScreen();
        }

        return SignInScreen();
        */
      },
    );
  }
}
