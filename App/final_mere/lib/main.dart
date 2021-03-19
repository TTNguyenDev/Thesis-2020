import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_camera_app/pages/camera_screen.dart';
import 'package:flutter_camera_app/pages/routs.dart';
import 'package:flutter_camera_app/screens/splash/splash_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

int initScreen;

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = await preferences.getInt('initScreen');
  await preferences.setInt('initScreen', 1);

  runApp(CameraApp());
}

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
      builder: EasyLoading.init(),
      //home:SplashScreen(),
      //initialRoute: SplashScreen.routeName,
      initialRoute: initScreen == 0 || initScreen == null ? 'onboard' : 'home',
      routes: {
        'home':  (context) => CameraScreen(),
        'onboard':  (context) => SplashScreen(),

      },
    );
  }
}
