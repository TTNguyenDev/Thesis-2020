import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

class MedicineList extends StatefulWidget {
  MedicineList({Key key, title}) : super(key: key);

  final String title = "Đơn Thuốc";

  @override
  _MedicineListState createState() => _MedicineListState();
}

class _MedicineListState extends State<MedicineList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new ListView.builder(
          itemCount: 50,
          itemBuilder: (BuildContext context, int index) {
            return new GestureDetector(
              child: new ListTile(
                  title: new Card(
                elevation: 5.0,
                child: new Container(
                  alignment: Alignment.center,
                  margin: new EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: new Text("ListItem $index"),
                ),
              )),
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    child: new CupertinoAlertDialog(
                      title: new Column(
                        children: <Widget>[
                          new Text("Listview"),
                          new Icon(
                            Icons.favorite,
                            color: Colors.green,
                          )
                        ],
                      ),
                      content: new Text("Selected Item $index"),
                      actions: <Widget>[
                        new FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: new Text("OK"))
                      ],
                    ));
              },
            );
          }),
    );
  }

  List<Product> parseProducts(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Product>((json) => Product.fromJson(json)).toList();
  }

  Future<List<Product>> fetchProducts() async {
    final response = await http.get('http://192.168.1.2:8000/products.json');
    if (response.statusCode == 200) {
      return parseProducts(response.body);
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }
}
