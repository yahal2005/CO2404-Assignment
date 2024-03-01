import 'package:cinematic_insights/Widgets/MovieSlider.dart';
import 'package:cinematic_insights/models/movieClass.dart';
import 'package:flutter/material.dart';

class MoviesAndTvShows extends StatefulWidget
{
  late Future<List<Movie>> currentlyPlaying;
  late Future<List<Movie>> trendingYr;
  late Future<List<Movie>> highestGrossing;
  late Future<List<Movie>> childrenFriendly;
  late Future<List<Movie>> onTv;

  MoviesAndTvShows({
    super.key,
    required this.currentlyPlaying,
    required this.trendingYr,
    required this.highestGrossing,
    required this.childrenFriendly,
    required this.onTv,

  });

  @override
  State <MoviesAndTvShows> createState() => MoviesAndTvShowsState();
  
}

class MoviesAndTvShowsState extends State<MoviesAndTvShows>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              child: FutureBuilder(
                future: widget.currentlyPlaying,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.hasData) {
                    return MovieSlider(category: "What's on at the cinema?", snapshot: snapshot);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            SizedBox(
              child: FutureBuilder(
                future: widget.trendingYr,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.hasData) {
                    return MovieSlider(category: "What are the best movies this year?", snapshot: snapshot);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            SizedBox(
              child: FutureBuilder(
                future: widget.highestGrossing,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.hasData) {
                    return MovieSlider(category: "What are the highest grossing movies of all time?", snapshot: snapshot);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            SizedBox(
              child: FutureBuilder(
                future: widget.childrenFriendly,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.hasData) {
                    return MovieSlider(category: "Children-friendly movies", snapshot: snapshot);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            SizedBox(
              child: FutureBuilder(
                future: widget.onTv,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.hasData) {
                    return MovieSlider(category: "What's on TV tonight?", snapshot: snapshot);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      )
    );
  }

}