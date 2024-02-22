/*import 'dart:convert';
import 'package:cinematic_insights/models/movieClass.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  final String category; // Add this parameter

  CategoryScreen({required this.category});
  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> 
{
  late ScrollController scrollController;
  late List<Movie> displayedMovies;
  late List<Movie> storedMovies;
  late int currentPage;
  late TextEditingController searchController;
  static const String apiKey = '?api_key=3c749db8d5e8d99a3e62389eff41fba3';

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    displayedMovies = [];
    storedMovies = [];
    currentPage = 1;
    searchController = TextEditingController();

    // Fetch initial movies
    fetchMovies();
    
    // Add a listener to the scrollController to detect when the user reaches the end
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        // User has reached the end of the list
        // Fetch more movies and append them to displayedMovies
        fetchMovies();
      }
    });
  }

  Future<void> fetchMovies() async {
    try {
      List<Movie> moreMovies = await fetchAllMoviesWithPage(currentPage);
      displayedMovies.addAll(moreMovies);
      storedMovies = displayedMovies;
      currentPage++;

      setState(() {});
    } catch (e) {
      // Handle error fetching more movies
    }
  }

  Future<List<Movie>> fetchAllMoviesWithPage(int page) async {
    List<Movie> allMovies = [];
    String url = '';

    // Customize the API endpoint based on the movie type
    
    if (widget.category == 'Top Rated') {
      
      url = 'https://api.themoviedb.org/3/movie/top_rated?$apiKey}&page=$page';
    } else if (widget.category == 'Grossing') {
      
      url = 'https://api.themoviedb.org/3/discover/movie?$apiKey&sort_by=revenue.desc&page=$page';
    }else if (widget.category == 'Action Animation'){
      url = 'https://api.themoviedb.org/3/discover/movie?$apiKey&adult=false&with_genres=16,28&page=$page';
    }else if (widget.category == 'Romantic Animation'){
      url = 'https://api.themoviedb.org/3/discover/movie$apiKey&adult=false&with_genres=16,10749&page=$page';
    }

    final response = await http.get(
      Uri.parse(url),
    );
    

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> movies = data['results'] ?? [];
      allMovies.addAll(movies.map((json) => Movie.fromJson(json)).toList());
    } else {
      throw Exception('Failed to load movies');
    }

    return allMovies;
  }
}*/