import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';

import 'package:flutter_camera_app/Model/ResponseData.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json, jsonDecode;

class MedicineList extends StatefulWidget {
  final List<User> user;
  MedicineList({Key key, @required this.user}) : super(key: key);

  final String title = "Đơn Thuốc";

  @override
  _MedicineListState createState() => _MedicineListState(user);
}

class _MedicineListState extends State<MedicineList> {
  final List<User> user;
  _MedicineListState(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: Text(widget.title, style: TextStyle(color: Colors.black)),
      ),
      body: new ListView.builder(
          itemCount: user.length,
          itemBuilder: (BuildContext context, int index) {
            return new GestureDetector(
              child: new ListTile(
                  title: new Card(
                elevation: 5.0,
                child: new Container(
                  alignment: Alignment.center,
                  margin: new EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: new Text(user[index].name),
                ),
              )),
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    child: new CupertinoAlertDialog(
                      title: new Column(
                        children: <Widget>[
                          new Text("Listview"),
                          new Icon(
                            Icons.favorite,
                            color: Colors.green,
                          )
                        ],
                      ),
                      content: new Text("Selected Item $index"),
                      actions: <Widget>[
                        new FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: new Text("OK"))
                      ],
                    ));
              },
            );
          }),
    );
  }
}
