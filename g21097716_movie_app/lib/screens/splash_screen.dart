
import 'package:cinematic_insights/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget
{
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
{
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/splash_screen.mp4')
      ..initialize().then((_) 
      {
        setState(() {});
        _playVideo();
      }).catchError((error)
       {
        print('Error initializing video player: $error');
      });
  }

  void _playVideo() async
  {
    _controller.play();

    Timer(Duration(seconds: 1),()
    {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );

    });
  
  }


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      //backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(
                  _controller,
                ),
              )
            :Container(),

      ),
    );
  }

    @override
  void dispose()
  {
    _controller.dispose();
    super.dispose();
  }

}