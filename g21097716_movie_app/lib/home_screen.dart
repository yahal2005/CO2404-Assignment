import 'package:flutter/material.dart';
import 'package:cinematic_insights/custom_widgets.dart';

class HomeScreen extends StatefulWidget 
{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            "assets/logo.png",
            width: screenSize.width *0.8,
            height: screenSize.height*0.2,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ), // Logo 
          const Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ScrollableMovieListView(category: "What's on at the cinema?"),
                  ScrollableMovieListView(category: "What are the best movies this year?"),
                  ScrollableMovieListView(category: "What are the highest grossing movies of all time?"),
                  ScrollableMovieListView(category: "Children-friendly movies"),
                  ScrollableMovieListView(category: "What's on TV tonight?"),
                  ScrollableMovieListView(category: "Watch-List"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}