import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'drawer_content.dart';
import 'video_player_widget.dart';

class VideoTutorial extends StatefulWidget {
  final String title = 'How to use Medic';

  @override
  _VideoTutorialState createState() => _VideoTutorialState();
}

class _VideoTutorialState extends State<VideoTutorial> {
  final asset = 'assets/example.mp4';
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(asset)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => _controller.play());
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
          // onPressed: () => printMedicine(),
        ),
        backgroundColor: Color(0xFF3EB16F),
        centerTitle: true,
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
      ),
      endDrawer: DrawerContent(),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: VideoPlayerWidget(controller: _controller),
            ),
            Spacer(),
            // Align(
            //     alignment: Alignment.bottomCenter,
            //     child: Container(
            //       height: 120,
            //       width: double.infinity,
            //       padding: EdgeInsets.all(15),
            //       color: Colors.black,
            //     ))
          ],
        ),
      ),
    );
  }
}
