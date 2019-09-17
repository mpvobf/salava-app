import 'package:flutter/material.dart';
import 'package:salava/authentication_service.dart';
import 'package:salava/models/badge.dart';
import 'package:salava/views/badge_detail.dart';

class Badge extends StatefulWidget {
  @override
  _BadgeState createState() => _BadgeState();
}

class _BadgeState extends State<Badge> {
  AuthenticationService auth = AuthenticationService();
  final String uriPrefix = 'http://10.0.2.2:5000/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Badges'),
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Text('Logout'),
          onPressed: () {
            auth.logout().then((result) {
              if (result) {
                Navigator.of(context).pushReplacementNamed('/login');
              } else {
                print("Can't log out");
              }
            });
          }),
      body: FutureBuilder<List<Badges>>(
        future: Badges.fetchBadges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data
                .map((badge) => Card(
                        child: ListTile(
                      leading: Image.network(uriPrefix + badge.imageFile),
                      title: Text(badge.name),
                      subtitle: Text(badge.issuerContentName),
                      trailing: IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BadgeDetail(badge.id)),
                          );
                        },
                      ),
                      isThreeLine: true,
                    )))
                .toList(),
          );
        },
      ),
    );
  }
}
