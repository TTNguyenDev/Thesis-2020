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

class PreviewScreen extends StatefulWidget {
  final String imgPath;

  PreviewScreen({this.imgPath});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
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
                width: double.infinity,
                height: 60.0,
                color: Colors.white,
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // getBytesFromFile().then((bytes){
                      //   Share.file('Share via', basename(widget.imgPath), bytes.buffer.asUint8List(),'image/path');
                      _startUploading();
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<ByteData> getBytesFromFile() async {
    Uint8List bytes = File(widget.imgPath).readAsBytesSync() as Uint8List;
    return ByteData.view(bytes.buffer);
  }

  var apiUrl = Uri.parse('http://192.168.1.5:5000/file-upload');
  var response;
  void _startUploading() async {
    // Dio dio = new Dio();
    // FormData formdata = new FormData.fromMap(<String, dynamic>{
    //   "file": await MultipartFile.fromFile(widget.imgPath, filename: 'abc.png')
    // });
    // print('Success');
    // try {
    //   response =
    //       await dio.post("http://192.168.1.5:5000/file-upload", data: formdata);
    //   print(response.data.toString());
    // } on DioError catch (e) {
    //   print(e.error);
    //   if (e.error is SocketException) {
    //     print(e.error);
    //   }
    //   throw e.error;
    // }
    String ResponeOutput =
        '[{"id": 1, "px": 1, "py": 1, "width": 1, "height": 1, "accuracy": "99", "name": "a"}, {"id": 2, "px": 1, "py": 1, "width": 1, "height": 1, "accuracy": "99", "name": "b"}]';
    List<User> users;
    users = (json.decode(ResponeOutput) as List)
        .map((i) => User.fromJson(i))
        .toList(); // parse json to list
    print("aaaa");
    print(ResponeOutput[0]);
    Navigator.push(this.context,
        MaterialPageRoute(builder: (context) => MedicineList(user: users)));
    print("Hello");
  }
}
