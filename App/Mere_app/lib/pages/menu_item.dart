import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'policy_view.dart';
class MenuItem extends StatelessWidget {
  final Icon icon;
  final String label;
  final _url = 'https://flutter.dev';
  MenuItem({
    @required this.icon,
    @required this.label,
  })  : assert(icon != null),
        assert(label != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 42.0),
      child: GestureDetector(
        onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => PolicyView())),
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
                color: Colors.blue,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
