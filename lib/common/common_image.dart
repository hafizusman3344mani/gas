import 'package:flutter/material.dart';

class CommonImage extends StatelessWidget {
  final String imageUrl;
  final double imageWidth;
  final double imageHeight;
  final BoxFit imageBoxFit;

  CommonImage({this.imageUrl, this.imageWidth,this.imageHeight,this.imageBoxFit});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        imageUrl,
        fit: imageBoxFit,
        width: imageWidth,
        height: imageHeight,
      ),
    );
  }
}
