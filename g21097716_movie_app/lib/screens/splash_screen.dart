
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

    Timer(Duration(seconds: 3),()
    {
      if (checkLoggedIn() == true)
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

  Future<bool> checkLoggedIn() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? Logged = prefs.getBool('Logged');
    if (Logged == null || Logged == false )
    {
      return (false);
    }
    else
    {
      return (true);
    }

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