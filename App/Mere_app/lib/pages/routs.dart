import 'package:flutter/widgets.dart';
import 'package:flutter_camera_app/screens/splash/splash_screen.dart';
import 'package:flutter_camera_app/pages/camera_screen.dart';
import 'package:flutter_camera_app/pages/preview_screen.dart';
import 'package:flutter_camera_app/pages/MedicineList.dart';
import 'package:flutter_camera_app/pages/MedicineInfo.dart';

import 'package:path/path.dart';
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName : (context) => SplashScreen(),
  CameraScreen.routeName : (context) => CameraScreen(),

};