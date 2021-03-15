import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'menu_item.dart';
import 'company_info.dart';

class DrawerContent extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                    onTap: ()=> Navigator.pop(context),
                    child: Icon(
                      CupertinoIcons.clear,
                      color: Colors.white,
                      size: 40.0,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 90.0, bottom: 46.0),
                    child: CompanyInfo(
                      picture: 'assets/company_logo.png',
                      name: 'TVT Group',
                      id: 'lnthanhmedic@gmail.com',
                      company: 'Prescription Recognition',
                    ),
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

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}