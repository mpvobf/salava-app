import 'dart:convert';
import 'package:http/http.dart' as http;

class Badges {
  final String description;
  final List<dynamic> tags;
  final String issuerContentUrl;
  final String issuerContentName;
  final bool verifiedByOBF;
  final int userEndorsementsCount;
  final int endorsementCount;
  final String name;
  final String imageFile;
  final int expiresOn;
  final bool revoked;
  final int issuedOn;
  final String obfUrl;
  final String status;
  final bool issuedByObf;
  final int id;
  final String badgeId;
  final String assertionUrl;
  final String visibility;
  final int mtime;
  final int issuerVerified;

  Badges(
      {this.description,
      this.tags,
      this.issuerContentUrl,
      this.issuerContentName,
      this.verifiedByOBF,
      this.userEndorsementsCount,
      this.endorsementCount,
      this.name,
      this.imageFile,
      this.expiresOn,
      this.revoked,
      this.issuedOn,
      this.obfUrl,
      this.status,
      this.issuedByObf,
      this.id,
      this.badgeId,
      this.assertionUrl,
      this.visibility,
      this.mtime,
      this.issuerVerified});

  factory Badges.fromJson(Map<String, dynamic> json) => new Badges(
      description: json["description"],
      tags: new List<dynamic>.from(json["tags"].map((x) => x)),
      issuerContentUrl: json["issuer_content_url"],
      issuerContentName: json["issuer_content_name"],
      verifiedByOBF: json["verified_by_obf"],
      userEndorsementsCount: json["user_endorsements_count"],
      endorsementCount: json["endorsements_count"],
      name: json["name"],
      imageFile: json["image_file"],
      expiresOn: json["expires_on"],
      revoked: json["revoked"],
      issuedOn: json["issued_on"],
      obfUrl: json["obf_url"],
      status: json["status"],
      issuedByObf: json["issued_by_obf"],
      id: json["id"],
      badgeId: json["badge_id"],
      assertionUrl: json["assertion_url"],
      visibility: json["visibility"],
      mtime: json["mtime"],
      issuerVerified: json["issuer_verified"]);

  static Future<List<Badges>> fetchBadges() async {
    var uri = 'http://10.0.2.2:5000/obpv1/badge';
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Badges> listOfBadges = items.map<Badges>((json) {
        return Badges.fromJson(json);
      }).toList();

      return listOfBadges;
    } else {
      throw Exception('Something went wrong');
    }
  }
}
