
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


class PreviewScreen extends StatefulWidget {
  final String imgPath;

  PreviewScreen({this.imgPath});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
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
      endDrawer: DrawerContent(),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
               flex: 2,
              child: Image.file(
              //child: Image.file(
                File(widget.imgPath),
                // File("assets/image1.png"),
                fit: BoxFit.cover,
              ),
              // child: Image.asset(
              //     "assets/image1.png",
              //   fit: BoxFit.cover,
              // ),
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


  // Future<ByteData> getBytesFromFile() async {
  //   Uint8List bytes = File(widget.imgPath).readAsBytesSync() as Uint8List;
  //   return ByteData.view(bytes.buffer);
  // }

  void _startUploading(context) async {
    //setState(() => loading = true);
    EasyLoadingStyle.dark;
    EasyLoading.show(status: 'Loading');
    diofile.Dio dio = new diofile.Dio();
    diofile.FormData formdata = new diofile.FormData.fromMap(<String, dynamic>{
      "file": await diofile.MultipartFile.fromFile(widget.imgPath, filename: 'abc.png')
      //"file": await MultipartFile.fromFile("assets/image1.png", filename: 'abc.png')
    });
    print('Success');
    try {
      var response =
      await dio.post("https://services.fit.hcmus.edu.vn:8889/file-upload", data: formdata);
      var medicines;
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
    } on diofile.DioError catch (e) {
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
  await errorDialog(
      context,
      message,
    positiveText: "Okay",
    positiveAction:() => Navigator.of(context).pop(),
  );

  // await Dialog<String>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text("NOFITICATION"),
  //       content: Text(message, textAlign: TextAlign.center),
  //       actions: <Widget>[
  //         FlatButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //           child: Text("OKAY"),
  //         ),
  //       ],
  //     ));
}


