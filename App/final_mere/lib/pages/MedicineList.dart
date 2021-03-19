import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';

import 'package:flutter_camera_app/Model/ResponseData.dart';
import 'package:flutter_camera_app/pages/MedicineInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:convert' show json, jsonDecode;
import 'drawer_content.dart';
import 'camera_screen.dart';

class MedicineList extends StatefulWidget {
  final List<List<Medicine>> medicine;
  MedicineList({Key key, @required this.medicine}) : super(key: key);

  final String title = "Prescription";

  @override
  _MedicineListState createState() => _MedicineListState(medicine);
}
class _MedicineListState extends State<MedicineList> {
  final List<List<Medicine>> medicine;
  _MedicineListState(this.medicine);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
          // onPressed: () => printMedicine(),
        ),
        backgroundColor: Color(0xFF3EB16F),
        centerTitle: true,
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
      ),
      endDrawer: DrawerContent(),
      body: Container(
        child: Column(
          children:<Widget> [
            Expanded(
              child: ListView.builder(
                  itemCount: 5,
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
                                          medicine[index][0].display_name,
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: Color(0xFF3EB16F),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 10),
                                        // (int.parse(medicine[index].accuracy) >= 90)
                                        //     ? Icon(Icons.verified,
                                        //     color: Color(0xFF3EB16F))
                                        //     : Container(),
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
                                            'Morning ${medicine[index][0].morning} Afternoon ${medicine[index][0].afternoon} Evening ${medicine[index][0].evening}',
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
                                    MedicineInfo(medicine: medicine[index][0])));
                      },);}),),
            // Expanded(
            //   child: Align(
            //     alignment: Alignment.bottomRight,
            //     child:
            //     MaterialButton(
            //       onPressed: () =>
            //       Navigator.push(
            //             this.context,
            //             MaterialPageRoute(
            //                 builder: (context) => CameraScreen())),
            //       color: Color(0xFF3EB16F),
            //       textColor: Colors.white,
            //       child: Icon(
            //         Icons.camera_alt,
            //         size: 26,
            //       ),
            //       padding: EdgeInsets.all(16),
            //       shape: CircleBorder(),
            //     ),
            //   ),
            // ),
          ],
        ),

      ),
    );
  }
  void printMedicine(){
    print(medicine.length);
    print(medicine[4]);
  }
}
