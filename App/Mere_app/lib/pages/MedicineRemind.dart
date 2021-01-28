import 'dart:convert';
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
// import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicineRemind extends StatefulWidget {
  final Medicine medicine;

  MedicineRemind({Key key, @required this.medicine}) : super(key: key);

  final String title = "Đặt lời nhắc";

  @override
  _MedicineRemindState createState() => _MedicineRemindState(medicine);
}

class _MedicineRemindState extends State<MedicineRemind> {
  final Medicine medicine;
  _MedicineRemindState(this.medicine);
  CalendarController _controller;
  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     leading: IconButton(
    //       icon: Icon(Icons.arrow_back_ios, color: Colors.white),
    //       onPressed: () => Navigator.of(context).pop(),
    //     ),
    //     backgroundColor: Color(0xFF3EB16F),
    //     centerTitle: true,
    //     title: Text(widget.title, style: TextStyle(color: Colors.white)),
    //   ),
    //   body: SfCalendar(
    //       view: CalendarView.week,
    //       showNavigationArrow: true,
    //       monthViewSettings: MonthViewSettings(
    //           appointmentDisplayMode: MonthAppointmentDisplayMode.appointment)),
    // );

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
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30,),
              TableCalendar(
                startingDayOfWeek: StartingDayOfWeek.monday,

                calendarController: _controller,

              )
            ],
          ),
        ),
      )
    );
  }
}


