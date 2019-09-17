import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AuthenticationService {
  final String uriPrefix = 'http://10.0.2.2:5000/salava';
  final Map<String, String> token = {
    'token': 'b8839ee400f14c14817348416e0c05f2'
  };

  final clientId = "oauth-client-app-id";
  final redirectUri = Uri.parse("salava/oauth_complete");
  final pkceCode = "pkce-string";
  final state = "state-string";
  //final codeChallenge = "";
  final codeChallengeMethod = "S256";
  
  Future<bool> authorize() async {
    var bytes = utf8.encode(pkceCode);
    var digest = sha256.convert(bytes).toString();

    Map<String, String> authParams = {
      "response_type": 'code',
      "client_id": clientId,
      'redirect_uri': redirectUri.toString(),
      'state': state,
      'code_challenge': digest,
      'code_challenge_method': codeChallengeMethod
    };

    var authQuery = Uri.http("10.0.2.2:5000", "/user/oauth2/authorize", authParams);
    var response = await http.get(authQuery);

    if (response.statusCode == 200) {
      print(response.headers);
      if (await canLaunch(authQuery.toString())) {
        await launch(authQuery.toString());
      } else {
        throw 'Could not open $authQuery';
      }

      if (state == "state-string") {
        //var code = Uri.base.queryParameters['code'];
        Map<String, String> tokenParams = {
          "grant_type": 'code',
          'code': '4c7bb1a984bcea83643af06dc8316307bc1b762f50b16a64179781a97de05867',
          "client_id": clientId,
          'redirect_uri': redirectUri.toString(),
          'code_verifier': pkceCode
        };

        var tokenQuery = Uri.http("10.0.2.2:5000", "/user/oauth2/token", tokenParams);
        var codeResponse = await http.post(tokenQuery, body: tokenParams);

        if (codeResponse.statusCode == 200) {
          print(codeResponse.body);

          var accessToken = tokenFromJson(codeResponse.body).accessToken;
          var refreshToken = tokenFromJson(codeResponse.body).refreshToken;
          Map<String, String> headers = {"Authorization": 'Bearer $accessToken'};
          var badgeQuery = Uri.http("10.0.2.2:5000", "/obpv1/badge");
          var badgeResponse = await http.get(badgeQuery, headers: headers);

          Map<String, String> refreshTokenParams = {
            "grant_type": 'refresh_token',
            "client_id": clientId,
            'redirect_uri': redirectUri.toString(),
            'refresh_token': refreshToken
          };

          var refreshTokenQuery = Uri.http("10.0.2.2:5000", "/user/oauth2/token");
          var refreshTokenResponse = await http.post(refreshTokenQuery, body: refreshTokenParams);

          var finalAccessToken = tokenFromJson(refreshTokenResponse.body).accessToken;
          print (finalAccessToken);

          Map<String, String> headerss = {"Authorization": 'Bearer $finalAccessToken'};

          var badgeQsssuery = Uri.http("10.0.2.2:5000", "/obpv1/badge");
          var badgeResponses = await http.get(badgeQsssuery, headers: headerss);

          print(badgeResponses.statusCode);
          print(badgeResponses.body);

          return true;
        }
      }
    }
    else {
      print('Access denied');
    }
    return false;
  }

  Future<bool> logout() async {
    Map<String, String> params = {
      "client_id": clientId,
    };
    Map<String, String> headers = {"Authorization": 'Bearer '};
    var uri = uriPrefix + 'user/oauth2/unauthorize';
    final response = await http.post(uri, headers: headers, body: params);

    print(response.statusCode);

    if (response.statusCode == 200){
      return true;
    }

    return false;
  }

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

class AccessToken {
  String accessToken;
  String refreshToken;
  String tokenType;
  int expires;

  AccessToken(
      {this.accessToken, this.refreshToken, this.tokenType, this.expires});

  factory AccessToken.fromJson(Map<String, dynamic> json) => AccessToken(
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
        tokenType: json["token_type"],
        expires: json["expires"],
      );
}

AccessToken tokenFromJson(String str) => AccessToken.fromJson(json.decode(str));

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
