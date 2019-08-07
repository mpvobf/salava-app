import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:salava/authentication_service.dart';
import 'package:salava/widgets/image_header.dart';

class Login extends StatefulWidget {
  @override
  _LoginPage createState() => new _LoginPage();
}

class _LoginPage extends State<Login> {
  String _status = "";
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final auth = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Salava App Login'),
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: null,
          child: Text(this._status),
        ),
        body: Container(
          child: ListView(children: [
            ImageHeader("assets/images/salava.png"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 10),
              child: FormBuilder(
                key: _fbKey,
                autovalidate: true,
                child: Column(children: <Widget>[
                  FormBuilderTextField(
                    controller: emailController,
                    attribute: "loginname",
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        labelText: "Login"),
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ],
                  ),
                  FormBuilderTextField(
                    controller: passwordController,
                    attribute: "password",
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        labelText: "Password"),
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                  RaisedButton(
                    padding:
                        EdgeInsets.symmetric(horizontal: 33.0, vertical: 10.0),
                    child: Text("Login"),
                    onPressed: () {
                      setState(() => this._status = 'Logging');
                      if (_fbKey.currentState.validate()) {
                        auth
                            .login(
                                emailController.text, passwordController.text)
                            .then((result) {
                          if (result) {
                            Navigator.of(context).pushReplacementNamed('/home');
                          } else {
                            setState(() => this._status = 'Failed');
                          }
                        });
                      }
                    },
                  )
                ]),
              ),
            ),
          ]),
        ));
  }
}
