import 'package:flutter/material.dart';
import 'package:salava/authentication_service.dart';
import 'package:salava/authservice.dart';
import 'package:salava/views/login.dart';
import 'package:salava/views/badges.dart';

AuthenticationService auth = AuthenticationService();
AuthService a = AuthService();

void main() async {

  //a.authorize();
  auth.authorize();

  Widget _home = Badge();

  //bool _loginResult = await auth.authorize();
  //if (_loginResult) {
  //if (true) {
  //  _home = Badge();
  //}

  runApp(
    new MaterialApp(
      title: 'Salava',
      home: _home,
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => Badge(),
        '/login': (BuildContext context) => Badge()
      },
    ),
  );
}
