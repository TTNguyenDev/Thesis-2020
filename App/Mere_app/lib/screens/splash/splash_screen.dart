import 'package:flutter/material.dart';
import 'package:flutter_camera_app/screens/splash/components/body.dart';
import 'package:flutter_camera_app/pages/size_config.dart';
import 'package:path/path.dart';

class SplashScreen extends StatelessWidget{
  static String routeName = "/splash";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
  
}