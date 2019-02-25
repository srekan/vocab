import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scopped_models/app_scopped_model.dart';
class SignInScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final pwdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Function signIn = ScopedModel.of<AppScoppedModel>(context).signIn;
    final String errorMessage = ScopedModel.of<AppScoppedModel>(context, rebuildOnChange: true).errorMessage;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0,),
            Column(
              children: <Widget>[
                Image.asset('assets/logo.jpeg', height: 120.0,),
                SizedBox(height: 20.0),
                Text('English House Login'),
              ],
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'User Name',
                filled: true,
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: pwdController,
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
              ),
              obscureText: true,
            ),
            SizedBox(height: 12.0),
            RaisedButton(
              child: Text('Sign In'),
              onPressed: (){
                signIn(username: nameController.text, password:pwdController.text);
              },
            ),
            Text(errorMessage),
          ],
        ),
      )
    );
  }
}