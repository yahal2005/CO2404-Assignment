import 'package:flutter/material.dart';
import 'package:cinematic_insights/Widgets/MovieSlider.dart';
import 'package:cinematic_insights/models/movieClass.dart';
import 'package:cinematic_insights/api/api.dart';

class HomeScreen extends StatefulWidget 
{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {

  late Future<List<Movie>> currentlyPlaying; 
  
  @override
  void initState()
  {
    super.initState();
    currentlyPlaying = Api().getCurrentlyPlaying();//calling the movies that are currently playing in the cinema
  }

  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            "assets/logo.png",
            width: screenSize.width *0.8,
            height: screenSize.height*0.3,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ), // Logo 
          const Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MovieSlider(category: "What's on at the cinema?"),
                  MovieSlider(category: "What are the best movies this year?"),
                  MovieSlider(category: "What are the highest grossing movies of all time?"),
                  MovieSlider(category: "Children-friendly movies"),
                  MovieSlider(category: "What's on TV tonight?"),
                  MovieSlider(category: "Watch-List"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}