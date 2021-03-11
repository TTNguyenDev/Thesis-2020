import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class PolicyView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (_) => new WebviewScaffold(
          url: "https://services.fit.hcmus.edu.vn:8889",
          appBar: new AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Color(0xFF3EB16F),
            centerTitle: true,
            title: Text('Policy', style: TextStyle(color: Colors.white)),
          ),
        ),
      },
    );
  }

}