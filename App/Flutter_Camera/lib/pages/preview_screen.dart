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
                            top: 10.0, bottom: 10, left: 150, right: 150),
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
                            _startUploading();
                          },
                          // child: Container(
                          //   width: 200,
                          //   height: 120,
                          //   color: Colors.white,
                          //   child: Center(
                          //     child: FlatButton(
                          //       color: Color(0xFF3EB16F),
                          //       shape: StadiumBorder(),
                          //       padding: EdgeInsets.only(top: 20, bottom: 20),
                          //       onPressed: () {
                          //         _startUploading();
                          //       },
                          //       child: Center(
                          //         child: Text(
                          //           "Trích xuất tên thuốc",
                          //           style: TextStyle(
                          //             color: Colors.white,
                          //             fontSize: 17,
                          //             fontWeight: FontWeight.w700,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ))))
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
    // ignore: non_constant_identifier_names
    String ResponeOutput =
        '[{"name":"Paracetamol","accuracy":"98","morning":"1","afternoon": "1","evening":"1","info":"Paracetamol là một loại thuốc giảm đau, hạ sốt được sử dụng để điều trị nhiều tình trạng như đau đầu, đau cơ, viêm khớp, đau lưng, đau răng, cảm lạnh và sốt. Thuốc có tác dụng giảm đau trong trường hợp viêm khớp nhẹ nhưng không có hiệu quả nếu tình trạng viêm và sưng khớp nặng hơn. Đôi khi bác sĩ sẽ chỉ định thuốc paracetamol cho những mục đích khác không được liệt kê trong tờ hướng dẫn sử dụng. Lúc ấy, bạn phải tuân thủ theo hướng dẫn của bác sĩ."},{"name":"Panadol","accuracy":"60","morning":"1","afternoon": "0","evening":"1","info":"Paracetamol là một loại thuốc giảm đau, hạ sốt được sử dụng để điều trị nhiều tình trạng như đau đầu, đau cơ, viêm khớp, đau lưng, đau răng, cảm lạnh và sốt. Thuốc có tác dụng giảm đau trong trường hợp viêm khớp nhẹ nhưng không có hiệu quả nếu tình trạng viêm và sưng khớp nặng hơn. Đôi khi bác sĩ sẽ chỉ định thuốc paracetamol cho những mục đích khác không được liệt kê trong tờ hướng dẫn sử dụng. Lúc ấy, bạn phải tuân thủ theo hướng dẫn của bác sĩ."}]';

    List<Medicine> medicines;
    medicines = (json.decode(ResponeOutput) as List)
        .map((i) => Medicine.fromJson(i))
        .toList(); // parse json to list
    print(ResponeOutput[0]);
    Navigator.push(
        this.context,
        MaterialPageRoute(
            builder: (context) => MedicineList(medicine: medicines)));
  }
}
