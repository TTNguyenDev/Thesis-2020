import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_camera_app/pages/camera_screen.dart';
import 'package:flutter_camera_app/pages/routs.dart';
import 'package:flutter_camera_app/screens/splash/splash_screen.dart';

void main() => runApp(CameraApp());

class CameraApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.black
    ));
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: "Ic",
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.green),
          bodyText2: TextStyle(color: Colors.green),
        ),
        //primaryColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,

      ),
      debugShowCheckedModeBanner: false,
      //home:SplashScreen(),
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}
