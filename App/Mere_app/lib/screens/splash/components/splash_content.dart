import 'package:flutter/material.dart';
import 'package:flutter_camera_app/pages/size_config.dart';


class SplashContent extends StatelessWidget {
  const SplashContent({Key key, this.text, this.image}) : super(key: key);
  final String text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        Text("MEDICINE RECOGNITION",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: getProportionateScreenWidth(36),
                color: Color(0xFF3EB16F),
                fontWeight: FontWeight.bold)),
        Text(text, textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFC9C9C9), fontWeight: FontWeight.bold)),
        Spacer(flex: 2),
        Image.asset(
          image,
          height: getProportionateScreenHeight(256),
          width: getProportionateScreenWidth(235),
        ),
      ],
    );
  }
}