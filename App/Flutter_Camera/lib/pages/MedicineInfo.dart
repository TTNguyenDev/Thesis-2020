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
import 'package:auto_size_text/auto_size_text.dart';

class MedicineInfo extends StatefulWidget {
  final Medicine medicine;
  MedicineInfo({Key key, @required this.medicine}) : super(key: key);
  final title = 'Thông tin thuốc';
  @override
  _MedicineInfoState createState() => _MedicineInfoState(medicine);
}

class _MedicineInfoState extends State<MedicineInfo> {
  final Medicine medicine;
  bool customIcon;
  _MedicineInfoState(this.medicine);
  Hero makeIcon(double size) {
    return Hero(
      tag: medicine.name + "1",
      child: Icon(
        IconData(0xe901, fontFamily: "Ic"),
        color: Color(0xFF3EB16F),
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Color(0xFF3EB16F),
          centerTitle: true,
          title: Text(widget.title, style: TextStyle(color: Colors.white)),
        ),
        body: SingleChildScrollView(
            child: Stack(children: <Widget>[
          Container(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            makeIcon(175),
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              children: <Widget>[
                                Hero(
                                  tag: medicine.name,
                                  child: Material(
                                      color: Colors.transparent,
                                      child: MainInfoTab(
                                        fieldTitle: "Tên Thuốc",
                                        customIcon: true,
                                        fieldInfo: medicine.name,
                                      )),
                                ),
                                MainInfoTab(
                                  fieldTitle: "Độ chính xác",
                                  customIcon: false,
                                  fieldInfo: medicine.accuracy,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                          child: ListView(shrinkWrap: true, children: <Widget>[
                        ExtendedInfoTab(
                            fieldTitle: "Liều lượng ",
                            customIcon: true,
                            fieldInfo:
                                'Sáng ${medicine.morning} Chiều ${medicine.afternoon} Tối ${medicine.evening}'),
                        // Icon(
                        //   Icons.insert_comment_outlined,
                        //   color: Color(0xFF3EB16F),
                        //   size: 17,
                        // ),
                        ExtendedInfoTab(
                            fieldTitle: "Thông tin ",
                            customIcon: false,
                            fieldInfo: medicine.info),
                        Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height * 0.06,
                            right: MediaQuery.of(context).size.height * 0.06,
                            top: 25,
                          ),
                          child: Container(
                            width: 280,
                            height: 70,
                            child: FlatButton(
                              color: Color(0xFF3EB16F),
                              shape: StadiumBorder(),
                              onPressed: () {
                                showTimePicker(context: null, initialTime: null)
                              },
                              child: Center(
                                child: Text(
                                  "Đặt lời nhắc",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ])),
                    ],
                  )))
        ])));
  }
}

class MainInfoTab extends StatelessWidget {
  final String fieldTitle;
  bool customIcon;
  final String fieldInfo;
  MainInfoTab(
      {Key key,
      @required this.fieldTitle,
      @required this.customIcon,
      @required this.fieldInfo})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      height: 120,
      child: ListView(
        padding: EdgeInsets.only(top: 15),
        shrinkWrap: true,
        children: <Widget>[
          Row(
            children: [
              Text(fieldTitle,
                  style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFFC9C9C9),
                      fontWeight: FontWeight.bold)),
              Spacer(flex: 2),
              customIcon
                  ? IconButton(
                      icon: Icon(Icons.insert_comment_outlined),
                      color: Color(0xFF3EB16F),
                      onPressed: () {
                        _showMedicineDialog(context);
                      },
                    )
                  : Container(),
            ],
          ),
          AutoSizeText(
            fieldInfo,
            style: TextStyle(
                fontSize: 24,
                color: Color(0xFF3EB16F),
                fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

class ExtendedInfoTab extends StatelessWidget {
  final String fieldTitle;
  bool customIcon;
  final String fieldInfo;

  ExtendedInfoTab(
      {Key key,
      @required this.fieldTitle,
      @required this.customIcon,
      @required this.fieldInfo})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Padding(
            //   padding: EdgeInsets.only(bottom: 8.0),
            //   child: Text(
            //     fieldTitle,
            //     style: TextStyle(
            //       fontSize: 20,
            //       color: Colors.black,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Container(
                  child: Row(
                children: [
                  Text(fieldTitle,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  (customIcon == true)
                      ? IconButton(
                          icon: Icon(Icons.insert_comment_outlined),
                          color: Color(0xFF3EB16F),
                          onPressed: () {
                            _showTimeDialog(context);
                          },
                        )
                      : Container(),
                ],
              )),
            ),
            Text(
              fieldInfo,
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFC9C9C9),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_showMedicineDialog(context) async {
  await showDialog<String>(
    context: context,
    child: new AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(20, 50, 20, 20),
      title: Text('Tên thuốc đúng'),
      content: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              autofocus: true,
              decoration: new InputDecoration(
                hintText: 'ex: Paracetamol',
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                  borderSide: new BorderSide(),
                ),
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            color: Colors.red,
            textColor: Colors.white,
            child: const Text('HỦY BỎ'),
            onPressed: () {
              Navigator.pop(context);
            }),
        new FlatButton(
            color: Color(0xFF3EB16F),
            textColor: Colors.white,
            child: const Text('ĐỒNG Ý'),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    ),
  );
}

_showTimeDialog(context) async {
  await showDialog<String>(
    context: context,
    child: new AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(20, 50, 20, 20),
      content: new Column(
        children: <Widget>[
          // new Expanded(
          //   child: new TextField(
          //     autofocus: true,
          //     decoration: new InputDecoration(
          //       hintText: 'ex: Paracetamol',
          //       border: new OutlineInputBorder(
          //         borderRadius: new BorderRadius.circular(20.0),
          //         borderSide: new BorderSide(),
          //       ),
          //     ),
          //   ),
          // )
          SizedBox(
            height: 16,
          ),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Sáng',
              isDense: true, // Added this
              contentPadding: EdgeInsets.all(8), // Added this
            ),
          ),
          SizedBox(
            height: 16,
          ),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Chiều',
              isDense: true, // Added this
              contentPadding: EdgeInsets.all(8), // Added this
            ),
          ),
          SizedBox(
            height: 16,
          ),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Tối',
              isDense: true, // Added this
              contentPadding: EdgeInsets.all(8), // Added this
            ),
          ),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            color: Colors.red,
            textColor: Colors.white,
            child: const Text('HỦY BỎ'),
            onPressed: () {
              Navigator.pop(context);
            }),
        new FlatButton(
            color: Color(0xFF3EB16F),
            textColor: Colors.white,
            child: const Text('ĐỒNG Ý'),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    ),
  );
}

// class SelectTime extends StatefulWidget {
//   @override
//   _SelectTimeState createState() => _SelectTimeState();
// }

// class _SelectTimeState extends State<SelectTime> {
//   TimeOfDay _time = TimeOfDay(hour: 0, minute: 00);
//   bool _clicked = false;

//   Future<TimeOfDay> _selectTime(BuildContext context) async {
//     // final NewEntryBloc _newEntryBloc = Provider.of<NewEntryBloc>(context);
//     final TimeOfDay picked = await showTimePicker(
//       context: context,
//       initialTime: _time,
//     );
//     if (picked != null && picked != _time) {
//       setState(() {
//         _time = picked;
//         _clicked = true;
//         // _newEntryBloc.updateTime("${convertTime(_time.hour.toString())}" +
//         //     "${convertTime(_time.minute.toString())}");
//       });
//     }
//     return picked;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     height: 60,
  //     child: Padding(
  //       padding: EdgeInsets.only(top: 10.0, bottom: 4),
  //       child: FlatButton(
  //         color: Color(0xFF3EB16F),
  //         shape: StadiumBorder(),
  //         onPressed: () {
  //           _selectTime(context);
  //         },
  //         child: Center(
  //           child: Text(
  //             _clicked == false
  //                 ? "Pick Time"
  //                 : "${convertTime(_time.hour.toString())}:${convertTime(_time.minute.toString())}",
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 20,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
// }
Future<TimeOfDay> showTimePicker({
  @required BuildContext context,
  @required TimeOfDay initialTime,
  TransitionBuilder builder,
  bool useRootNavigator = true,
  TimePickerEntryMode initialEntryMode = TimePickerEntryMode.dial,
  String cancelText,
  String confirmText,
  String helpText,
  RouteSettings routeSettings,
}) async {
  assert(context != null);
  assert(initialTime != null);
  assert(useRootNavigator != null);
  assert(initialEntryMode != null);
  assert(debugCheckHasMaterialLocalizations(context));

  final Widget dialog = _TimePickerDialog(
    initialTime: initialTime,
    initialEntryMode: initialEntryMode,
    cancelText: cancelText,
    confirmText: confirmText,
    helpText: helpText,
  );
  return await showDialog<TimeOfDay>(
    context: context,
    useRootNavigator: useRootNavigator,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
    routeSettings: routeSettings,
  );
}

