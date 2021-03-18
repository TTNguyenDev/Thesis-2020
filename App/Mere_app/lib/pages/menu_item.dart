import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'policy_view.dart';
import 'dart:io';
class MenuItem extends StatelessWidget {
  final Icon icon;
  final String label;
  final String url;
  MenuItem({
    @required this.icon,
    @required this.label,
    @required this.url
  })  : assert(icon != null),
        assert(label != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 42.0),
      child: GestureDetector(
        onTap: (

         )=>  _checkInternet(context),
            //Navigator.push(context, MaterialPageRoute(builder: (context) => PolicyView(url: url, label: label,))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon.icon,
              color: Color(0xFF3EB16F),
            ),
            SizedBox(
              width: 30.0,
            ),
            Text(
              label,

              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF3EB16F),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _checkInternet(context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PolicyView(url: url, label: label,)));
        print('Connected');
      }
    } on SocketException catch (_) {
      Navigator.pop(context);
      print('You have to turn on Wifi or 3G to use application’s feature.');

    }

  }
}

