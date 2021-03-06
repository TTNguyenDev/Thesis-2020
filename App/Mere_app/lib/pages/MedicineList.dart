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
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color(0xFF3EB16F),
        centerTitle: true,
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
      ),
      body: new ListView.builder(
          itemCount: medicine.length,
          itemBuilder: (BuildContext context, int index) {
            return new GestureDetector(
              child: Hero(
                tag: 'imgaeHero',
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
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Color(0xFF3EB16F),
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 10),
                                (int.parse(medicine[index].accuracy) >= 90)
                                    ? Icon(Icons.verified,
                                    color: Color(0xFF3EB16F))
                                    : Container(),
                                Spacer(),
                                Icon(
                                  IconData(0xe901, fontFamily: "Ic"),
                                  color: Color(0xFF3EB16F),
                                  size: 100,
                                ),
                              ]),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(top: 4.0, bottom: 4.0),
                              child: Row(children: <Widget>[
                                Text(
                                    'Sáng ${medicine[index].morning} Chiều ${medicine[index].afternoon} Tối ${medicine[index].evening}',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Color(0xFFC9C9C9),
                                        fontWeight: FontWeight.bold)),
                              ]),
                            ),

                          ],
                        ))),
              ),
              onTap: () {
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
