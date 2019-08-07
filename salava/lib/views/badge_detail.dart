import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:salava/authentication_service.dart';
import 'package:salava/models/single_badge.dart';

class BadgeDetail extends StatelessWidget {
  final int _badgeId;
  final String uriPrefix = 'http://10.0.2.2:5000/';
  final AuthenticationService auth = AuthenticationService();

  BadgeDetail(this._badgeId);

  _deleteBadge() async {
    final String uri = uriPrefix + 'obpv1/badge/' + _badgeId.toString();
    var response = await http.delete(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Badge"),
      ),
      body: FutureBuilder<SingleBadge>(
          future: SingleBadge.fetchByBadgeId(this._badgeId),
          builder: (context, badge) {
            if (!badge.hasData)
              return Center(child: CircularProgressIndicator());

            List<Content> data = badge.data.content;

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      width: 30,
                      height: 20,
                      child:
                          Text(data.map((content) => content.name).toString())),
                  Text(data.map((content) => content.description).toString()),
                  Image.network(uriPrefix +
                      data
                          .map((content) => content.imageFile)
                          .toString()
                          .replaceAll('(', '')
                          .replaceAll(')', '')),
                  Container(
                    child: RaisedButton(
                        child: Text("Delete Badge"),
                        onPressed: () {
                          _deleteBadge().then((_) => Navigator.of(context)
                              .pushReplacementNamed('/home'));
                        }),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
