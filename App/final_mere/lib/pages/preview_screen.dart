import 'dart:io';
import 'package:dio/dio.dart' as diofile;
import 'package:flutter_camera_app/Model/ResponseData.dart';
import 'package:flutter_camera_app/pages/MedicineList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'MedicineList.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'drawer_content.dart';
import 'package:commons/commons.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';


import 'package:path/path.dart';

class PreviewScreen extends StatefulWidget {
  final String imgPath;

  PreviewScreen({this.imgPath});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  Timer _timer;
  double _progress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => {
            EasyLoading.dismiss(),
            Navigator.of(context).pop(),
          },
        ),
        backgroundColor: Color(0xFF3EB16F),
        automaticallyImplyLeading: true,
      ),
      endDrawer: DrawerContent(),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Image.file(
                File(widget.imgPath),

                fit: BoxFit.cover,
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  child: Padding(
                      padding: EdgeInsets.only(
                          top: 10.0, bottom: 10, left: 100, right: 100),
                      child: FlatButton(
                        child: Center(
                            child: Text(
                          'Extract',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                        color: Color(0xFF3EB16F),
                        shape: StadiumBorder(),
                        onPressed: () {
                          _startUploading(context);
                        },
                      )),
                )),
          ],
        ),
      ),
    );
  }
  void _startUploading(context) async {
    EasyLoading.show(status: "Analyzing your prescription, Please wait...");

  void _startUploading(context) async {
    EasyLoadingStyle.dark;
    EasyLoading.show(status: 'Loading');
    diofile.Dio dio = new diofile.Dio();
    diofile.FormData formdata = new diofile.FormData.fromMap(<String, dynamic>{
      "file": await diofile.MultipartFile.fromFile(widget.imgPath,
          filename: 'abc.png')
      // "file": await diofile.MultipartFile.fromFile("", filename: 'abc.png')
    });
    print('Success');
    try {
      var response = await dio.post(
          "https://services.fit.hcmus.edu.vn:8889/file-upload",
          data: formdata);
      List<List<Medicine>> listMedicines = [];
      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        print('Success to read image ');
        // print(response.data);
        for (var i = 0; i < response.data.length; i++) {
          var medicines = List<Medicine>.from(
              response.data[i].map((i) => Medicine.fromJson(i)));
          listMedicines.add(medicines);
        }
        for (var i = 0; i < listMedicines.length; i++)
          print(listMedicines[i][0].display_name);
        if (listMedicines.length <= 0) {
          _alertMedicineMessage(context);
        } else {
          Navigator.push(
              this.context,
              MaterialPageRoute(
                  builder: (context) => MedicineList(medicine: listMedicines)));
        }
      } else {
        _alertBoxMessage(context, "Fail to read image");
      }
    } on diofile.DioError catch (e) {
      EasyLoading.dismiss();
      // print(e.error);
      _alertMedicineMessage(context);
      if (e.error is SocketException) {
        print(e.error);
      }
      throw e.error;
    }
  }
}

_alertBoxMessage(context, message) async {
  await errorDialog(
    context,
    message,
    neutralText: "OK",
    neutralAction: () => Navigator.of(context).pop(),
  );
}

_alertMedicineMessage(context) async {
  await infoDialog(
    context,
    "Can not find medicine's name in your image.\nPlease try another one",
    title: "Notification",
    neutralText: "OK",
    neutralAction: () => Navigator.of(context).pop(),
  );
}
