import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthenticationService {
  final String uriPrefix = 'http://10.0.2.2:5000/';
  final Map<String, String> token = {
    'token': 'b8839ee400f14c14817348416e0c05f2'
  };

  Future<bool> login(String email, String password) async {
    var uri = uriPrefix + 'obpv1/badge/login';
    var loginData = {
      'grant_type': 'password',
      'username': email,
      'password': password
    };

    final response = await http.post(uri, body: loginData);

    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    var uri = uriPrefix + 'obpv1/badge/logout';
    final response = await http.post(uri, body: token);
  }

  Future<bool> isAuthorized() async {
    var uri = uriPrefix + 'obpv1/badge/token';
    final response = await http.post(uri, body: token);

    if (response.statusCode == 200) {
      final token = getTokens(response.body);
      if (token.length == 1) {
        print(token[0].getSecret());
        return true;
      }
    }
    return false;
  }

  List<Token> getTokens(String str) =>
      new List<Token>.from(json.decode(str).map((x) => Token.fromJson(x)));
}

class Token {
  String secret;

  Token({this.secret});

  factory Token.fromJson(Map<String, dynamic> json) => new Token(
        secret: json['secret'],
      );

  String getSecret() {
    return this.secret;
  }
}
