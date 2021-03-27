import 'dart:io';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';

import 'package:flutter_camera_app/Model/ResponseData.dart';
import 'package:flutter_camera_app/pages/MedicineInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:commons/commons.dart';
import 'dart:convert' show json, jsonDecode;
import 'drawer_content.dart';
import 'package:recase/recase.dart';

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

  int _value = 1;


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
          children: <Widget>[
            Expanded(
              child: ListView.builder(
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
                                      const EdgeInsets.only(
                                          top: 8.0, bottom: 4.0),
                                      child: Row(children: <Widget>[
                                        SizedBox(
                                          width: 150,
                                          // child: medicine[index].length > 1 ? _dropDownMenu(
                                          //     medicine[index]) :
                                          child:  AutoSizeText(
                                            medicine[index][0].display_name.sentenceCase,
                                            style: TextStyle(
                                                fontSize: 24,
                                                color: Color(0xFF3EB16F),
                                                fontWeight: FontWeight.bold),
                                            maxLines: 2,
                                            minFontSize: 14,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        (medicine[index].length > 1)
                                            ? GestureDetector(
                                            child: Icon(Icons.warning,
                                                color: Colors.red,
                                              size: 24,
                                            ),
                                          onTap: ()=> warningDialog(context,'This medicine maybe incorrect\nBe careful with this.', title: 'Warning',neutralText: "OK"),
                                        )
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
                                      const EdgeInsets.only(
                                          top: 4.0, bottom: 4.0),
                                      child: Row(children: <Widget>[
                                        Text(
                                            'Morning ${medicine[index][0]
                                                .morning} Afternoon ${medicine[index][0]
                                                .afternoon} Evening ${medicine[index][0]
                                                .evening}',
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
                                    MedicineInfo(
                                        medicine: medicine[index][0])));
                      },);
                  }),),
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

  _dropDownMenu(List<Medicine> medicine) async {
    return DropdownButton(
      value: _value,
      items: [
        DropdownMenuItem(
          child: Text(medicine[0].display_name),
          value: 1,
        ),
        DropdownMenuItem(
          child: Text(medicine[1].display_name),
          value: 2,
        ),
        DropdownMenuItem(
            child: Text(medicine[2].display_name),
            value: 3
        ),
        DropdownMenuItem(
            child: Text(medicine[3].display_name),
            value: 4
        ),
        DropdownMenuItem(
            child: Text(medicine[4].display_name),
            value: 5
        ),
      ],
      onChanged: (value){
        setState(() {
          _value = value;
        });
      },
    );
  }

}
