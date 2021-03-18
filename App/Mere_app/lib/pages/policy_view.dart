import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class PolicyView extends StatelessWidget{
  final String url;
  final String label;
  const PolicyView({Key key, this.url, this.label}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (_) => new WebviewScaffold(
          url: url,
          appBar: new AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Color(0xFF3EB16F),
            centerTitle: true,
            title: Text(label, style: TextStyle(color: Colors.white)),
          ),
        ),
      },
    );
  }

}