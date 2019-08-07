import 'package:flutter/material.dart';

class ImageHeader extends StatelessWidget {
  final String _imagePath;

  ImageHeader(this._imagePath);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 30),
        width: 30,
        height: 165.0,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.contain, image: AssetImage(_imagePath))));
  }
}
