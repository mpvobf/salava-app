import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {

  Future<bool> authorize() async {
    final clientId = "oauth-client-app-id";
    final redirectUri = Uri.parse("q");
    final pkceCode = "pkce-string";
    final state = "state-string";
    final codeChallengeMethod = "S256";
    final bytes = utf8.encode(pkceCode);
    final digest = sha256.convert(bytes).toString();

    final Map<String, String> authParams = {
      "response_type": 'code',
      "client_id": clientId,
      'redirect_uri': redirectUri.toString(),
      'state': state,
      'code_challenge': digest,
      'code_challenge_method': codeChallengeMethod
    };

    final salavaUrl = 'http://10.0.2.2:5000';
    final authQuery = Uri.http("10.0.2.2:5000", "/user/oauth2/authorize", authParams);

    print(authQuery);

    final result = await FlutterWebAuth.authenticate(
        url: authQuery.toString(),
        callbackUrlScheme: redirectUri.toString());

    print(result);

    final code = Uri.parse(result).queryParameters['code'];
    print(code);

    final Map<String, String> tokenParams = {
      "grant_type": 'code',
      'code': code,
      "client_id": clientId,
      'redirect_uri': redirectUri.toString(),
      'code_verifier': pkceCode
    };

    final response = await http.post('10.0.2.2:5000/user/oauth2/token', body: tokenParams);

    print(response.statusCode);

    return true;
  }
}