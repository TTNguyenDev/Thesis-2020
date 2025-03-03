import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_camera_app/Model/ResponseData.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter_camera_app/pages/MedicineList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'MedicineList.dart';
import 'dart:convert' show json, jsonDecode;
import 'package:flutter_camera_app/pages/loading.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class PreviewScreen extends StatefulWidget {
  final String imgPath;

  PreviewScreen({this.imgPath});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  //bool loading = false;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color(0xFF3EB16F),
        automaticallyImplyLeading: true,
      ),
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
                                'Trích xuất',
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
                        )
                    ),
                    ))
          ],
        ),
      ),
    );
  }


  Future<ByteData> getBytesFromFile() async {
    Uint8List bytes = File(widget.imgPath).readAsBytesSync() as Uint8List;
    return ByteData.view(bytes.buffer);
  }

  void _startUploading(context) async {
    //setState(() => loading = true);
    EasyLoadingStyle.dark;
    EasyLoading.show(status: 'Loading');
    Dio dio = new Dio();
    FormData formdata = new FormData.fromMap(<String, dynamic>{
      "file": await MultipartFile.fromFile(widget.imgPath, filename: 'abc.png')
    });
    print('Success');
    try {
      var response =
      await dio.post("http://ec2-18-222-38-237.us-east-2.compute.amazonaws.com:8080/file-upload", data: formdata);
      var medicines;
      //setState(() => loading = false);
      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        print('Success to read image ');
        medicines =
        List<Medicine>.from(response.data.map((i) => Medicine.fromJson(i)));
        Navigator.push(
            this.context,
            MaterialPageRoute(
                builder: (context) => MedicineList(medicine: medicines)));
      } else {
        _alertBoxMessage(context, "Fail to read imgae");
      }
    } on DioError catch (e) {
      EasyLoading.dismiss();
      // print(e.error);
      _alertBoxMessage(context, e.message);
      if (e.error is SocketException) {
        print(e.error);
      }
      throw e.error;
    }
  }
}

 _alertBoxMessage(context, message) async {
  await showDialog<String>(
      context: context,
      child: AlertDialog(
        title: Text("Alert Dialog Box"),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("okay"),
          ),
        ],
      ));
}
