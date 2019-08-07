import 'package:flutter/material.dart';
import 'package:salava/authentication_service.dart';
import 'package:salava/views/login.dart';
import 'package:salava/views/badges.dart';

AuthenticationService auth = AuthenticationService();

void main() async {
  Widget _home = Login();

  bool _loginResult = await auth.isAuthorized();
  if (_loginResult) {
    _home = Badge();
  }

  runApp(
    new MaterialApp(
      title: 'Salava',
      home: _home,
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => Badge(),
        '/login': (BuildContext context) => Login()
      },
    ),
  );
}
