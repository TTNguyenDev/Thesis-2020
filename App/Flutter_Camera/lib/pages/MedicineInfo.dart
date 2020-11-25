import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';

import 'package:flutter_camera_app/Model/ResponseData.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher_icons/ios.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json, jsonDecode;

class MedicineInfo extends StatefulWidget {
  final Medicine medicine;
  MedicineInfo({Key key, @required this.medicine}) : super(key: key);
  final title = 'Thông tin thuốc';
  @override
  _MedicineInfoState createState() => _MedicineInfoState(medicine);
}

class _MedicineInfoState extends State<MedicineInfo> {
  final Medicine medicine;
  _MedicineInfoState(this.medicine);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.blue[300],
          title: Text(medicine.name, style: TextStyle(color: Colors.black)),
        ),
        body: new ListView.builder(
            itemCount: 1,
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
                              Text(medicine.name,
                                  style: new TextStyle(fontSize: 35.0))
                              // new Image.asset("assets/medicine.png"),
                            ])),
                        Padding(
                            padding:
                                const EdgeInsets.only(top: 4.0, bottom: 80.0),
                            child: Row(children: <Widget>[Text(medicine.info)]))
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
