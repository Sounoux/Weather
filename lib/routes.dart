import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'current.dart';
import 'models/location.dart';

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/images/accueil.mp4')
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bienvenue !"),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: SizedBox(
              height: 300,
              width: 300,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: VideoPlayer(_controller)),
            ),
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              child: ElevatedButton(
                child: const Text('Go!'),
                onPressed: () {
                  Navigator.of(context).push(_createRoute());
                },
              ),
              height: 30,
              width: 100,
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      List<Location> locations = [
        Location(city: "Paris", country: "france", lat: "48.853", lon: "2.349")
      ];
      User user = '' as User;
      return CurrentWeatherPage(user, locations, context, '');
    },
    transitionsBuilder: (BuildContext context,
        Animation<double> animation, //
        Animation<double> secondaryAnimation,
        Widget child) {
      return child;
    },
  );
}
