
import 'package:cinematic_insights/api/api.dart';
import 'package:cinematic_insights/models/movieClass.dart';
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
  late Future<List<Movie>> currentlyPlaying;
  late Future<List<Movie>> trendingYr;
  late Future<List<Movie>> highestGrossing;
  late Future<List<Movie>> childrenFriendly;
  late Future<List<Movie>> onTv;

  @override
  void initState() {
    super.initState();
    initializeData();
    _controller = VideoPlayerController.asset('assets/splash_screen.mp4')
      ..initialize().then((_) 
      {
        setState(() {});
        _playVideo();
      }).catchError((error)
       {
        print('Error initializing video player: $error');
      });
    //Displays Video for Splash Screen
  }

  Future<void> initializeData() async 
  {
    currentlyPlaying = Api().getCurrentlyPlaying();
    trendingYr = Api().getPopular();
    highestGrossing = Api().getHighestGrossing();
    childrenFriendly = Api().getChildrenFriendly();
    onTv = Api().getOnTv();
    
  }
  //Load all the data related to movies

  void _playVideo() async
  {
    _controller.play();

    bool isLoggedIn = await getBoolcheckLoggedIn();

    Timer(Duration(seconds: 5),() //Plays the video for 5 seconds
    {
      if (isLoggedIn == true)
      {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen(
            currentlyPlaying: currentlyPlaying,
            trendingYr: trendingYr,
            highestGrossing: highestGrossing,
            childrenFriendly: childrenFriendly,
            onTv: onTv,

          )),
        );
      }
      else
      {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen(
            currentlyPlaying: currentlyPlaying,
            trendingYr: trendingYr,
            highestGrossing: highestGrossing,
            childrenFriendly: childrenFriendly,
            onTv: onTv,
          )),
        );
      }
      //Checks if the user is logged in or not and navigates for the relevant screens
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
  //Calls the locally stored boolean variable to check if user is logged in


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
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