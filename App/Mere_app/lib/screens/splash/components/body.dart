import 'package:flutter/material.dart';
import 'package:flutter_camera_app/pages/camera_screen.dart';
import 'package:flutter_camera_app/pages/size_config.dart';
import 'package:flutter_camera_app/screens/splash/components/splash_content.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Wellcome to Prescription Recognition,\nLet's started. ",
      "image": "assets/splash_1.png"
    },
    {
      "text": "We will find all the medicine name in the prescription",
      "image": "assets/splash_2.png"
    },
    {
      "text": "We will remind the time to take the medicine ",
      "image": "assets/splash_3.png",
    },
    {
      "text": "Take the image of the prescription clearly",
      "image": "assets/splash_1.png"
    },
    {
      "text": "Check all the medicine name ",
      "image": "assets/splash_2.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  text: splashData[index]['text'],
                  image: splashData[index]["image"],
                ),
              )),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
              ),
              child: Column(
                children: <Widget>[
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        splashData.length, (index) => buildDot(index: index)),
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  DefaultButton(
                    text: "SKIP",
                    press: (){
                      //Navigator.pushNamed(context, CameraScreen.routeName);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CameraScreen()),
                      );
                    },
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.green : Colors.green[200],
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: getProportionateScreenHeight(56),
        child: FlatButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Color(0xFF3EB16F),
            onPressed: press,
            child: Text(text,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(18),
                    fontWeight: FontWeight.w700))));
  }
}
