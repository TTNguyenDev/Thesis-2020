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
import 'package:flutter_camera_app/pages/menu_item.dart';
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
  bool _isDrawerOpen = false;
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
      endDrawer: Drawer(
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height / 1.8 - 90.0) - 120.0,
              color: Color(0xFF3EB16F),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 50.0,
                    left: 20.0,
                    child: GestureDetector(
                      onTap: () => setState(() => _isDrawerOpen = false),
                      child: Icon(
                        CupertinoIcons.clear,
                        color: Colors.white,
                        size: 40.0,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 46.0, bottom: 46.0),
                      // child: UserInfo(
                      //   picture: 'https://shopolo.hu/wp-content/uploads/2019/04/profile1-%E2%80%93-kopija.jpeg',
                      //   name: 'Ryan',
                      //   id: '0023-Ryan',
                      //   company: 'Universal Data Center',
                      // ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 1.8 + 30.0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 46.0, top: 46.0),
                  child: Column(
                    children: <Widget>[
                      MenuItem(
                        icon: Icon(Icons.library_books_outlined),
                        label: 'Policy',
                      ),
                      MenuItem(
                        icon: Icon(Icons.account_circle),
                        label: 'About Us',
                      ),
                      MenuItem(
                        icon: Icon(Icons.phone),
                        label: 'Contact Us',
                      ),
                      // MenuItem(
                      //   icon: Icon(Icons.message),
                      //   label: 'Contact us',
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),


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
                        )
                    ),
                    )),
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
      await dio.post("http://172.29.64.185:8889/file-upload", data: formdata);
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
        _alertBoxMessage(context, "Fail to read image");
      }
    } on DioError catch (e) {
      EasyLoading.dismiss();
      // print(e.error);
      _alertBoxMessage(context, "Fail to read image");
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
        title: Text("NOFITICATION"),
        content: Text(message, textAlign: TextAlign.center),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OKAY"),
          ),
        ],
      ));
}
