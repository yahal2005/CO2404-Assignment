
import 'package:cinematic_insights/screens/home_screen.dart';
import 'package:cinematic_insights/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

    bool isLoggedIn = await getBoolcheckLoggedIn();

    Timer(Duration(seconds: 3),()
    {
      if (isLoggedIn == true)
      {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
      else
      {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    }  
   );
  
  }

  getBoolcheckLoggedIn() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool Logged = prefs.getBool('Logged') ?? false;
    print(Logged);
    return (Logged);

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