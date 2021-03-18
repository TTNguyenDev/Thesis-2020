import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConnectionBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ConnectionStatusBar(
      title: Text("Please check your internet connection",
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

}