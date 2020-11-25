import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';

import 'package:flutter_camera_app/Model/ResponseData.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter_camera_app/pages/MedicineInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher_icons/ios.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json, jsonDecode;

class MedicineList extends StatefulWidget {
  final List<Medicine> medicine;
  MedicineList({Key key, @required this.medicine}) : super(key: key);

  final String title = "Đơn Thuốc";

  @override
  _MedicineListState createState() => _MedicineListState(medicine);
}

class _MedicineListState extends State<MedicineList> {
  final List<Medicine> medicine;
  _MedicineListState(this.medicine);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.blue[300],
        title: Text(widget.title, style: TextStyle(color: Colors.black)),
      ),
      body: new ListView.builder(
          itemCount: medicine.length,
          itemBuilder: (BuildContext context, int index) {
            return new GestureDetector(
              child: Card(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 4.0),
                            child: Row(children: <Widget>[
                              Text(
                                medicine[index].name,
                                style: new TextStyle(fontSize: 35.0),
                              ),
                              Icon(Icons.verified, color: Colors.blue),
                              Spacer(),
                              new Image.asset("assets/medicine.png"),
                            ]),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 4.0, bottom: 80.0),
                            child: Row(children: <Widget>[
                              Text(medicine[index].time),
                            ]),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Uống trước khi ăn",
                                  style: new TextStyle(fontSize: 20.0),
                                ),
                                Spacer(),
                                Icon(Icons.lock_clock, color: Colors.blue),
                              ],
                            ),
                          )
                        ],
                      ))),
              onTap: () {
                // showDialog(
                //     context: context,
                //     barrierDismissible: false,
                //     child: new CupertinoAlertDialog(
                //       title: new Column(
                //         children: <Widget>[
                //           new Text("Time"),
                //           new Icon(
                //             Icons.lock_clock,
                //             color: Colors.blue,
                //           )
                //         ],
                //       ),
                //       content: new Text(medicine[index].id),
                //       actions: <Widget>[
                //         new FlatButton(
                //             onPressed: () {
                //               Navigator.of(context).pop();
                //             },
                //             child: new Text("OK"))
                //       ],
                //     ));
                Navigator.push(
                    this.context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MedicineInfo(medicine: medicine[index])));
              },
            );
          }),
    );
  }
}
