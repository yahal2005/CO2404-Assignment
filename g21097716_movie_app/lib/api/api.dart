import 'dart:convert';
import 'package:cinematic_insights/models/genreClass.dart';
import 'package:cinematic_insights/models/movieClass.dart';
import 'package:http/http.dart' as http;

class Api
{
  static const String apiKey = '?api_key=3c749db8d5e8d99a3e62389eff41fba3';
  static const cinemaUrl = 'https://api.themoviedb.org/3/movie/now_playing$apiKey';
  static const popularUrl = 'https://api.themoviedb.org/3/movie/popular$apiKey';
  static const highestGrossingUrl = 'https://api.themoviedb.org/3/discover/movie$apiKey&sort_by=revenue.desc';
  static const childrenFriendlyUrl = 'https://api.themoviedb.org/3/discover/movie$apiKey&adult=false&with_genres=16';
  static const tvUrl = 'https://api.themoviedb.org/3/tv/airing_today$apiKey';
  static const movieDetailUrl = 'https://api.themoviedb.org/3/movie/';
  static const movieGenresUrl = 'https://api.themoviedb.org/3/genre/movie/list$apiKey';
  static const searchUrl = 'https://api.themoviedb.org/3/search/multi$apiKey&query=';





  Future<List<Movie>> getCurrentlyPlaying() async
  {
    final response = await http.get(Uri.parse(cinemaUrl));
    if(response.statusCode == 200)
    {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    }
    else
    {
      throw Exception("Something happened");
    }
  }

  Future<List<Movie>> getPopular() async
  {
    final response = await http.get(Uri.parse(popularUrl));
    if(response.statusCode == 200)
    {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    }
    else
    {
      throw Exception("Something happened");
    }
  }

  Future<List<Movie>> getHighestGrossing() async
  {
    final response = await http.get(Uri.parse(highestGrossingUrl));
    if(response.statusCode == 200)
    {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    }
    else
    {
      throw Exception("Something happened");
    }
  }

  Future<List<Movie>> getChildrenFriendly() async
  {
    final response = await http.get(Uri.parse(childrenFriendlyUrl));
    if(response.statusCode == 200)
    {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    }
    else
    {
      throw Exception("Something happened");
    }
  }

  Future<List<Movie>> getOnTv() async
  {
    final response = await http.get(Uri.parse(tvUrl));
    if(response.statusCode == 200)
    {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    }
    else
    {
      throw Exception("Something happened");
    }
  }

  // Future<List<Movie>> getMovieDetails(String movieID) async
  //  {
  //   final response = await http.get(Uri.parse('$movieDetail$movieID$apiKey'));
  //   if(response.statusCode == 200)
  //   {
  //     final decodedData = json.decode(response.body) as List;
  //     return decodedData.map((movie) => Movie.fromJson(movie)).toList();
  //   }
  //   else
  //   {
  //     throw Exception("Something happened");
  //   }
  // }

  Future<Movie> getMovieDetails(String movieID) async {
  final response = await http.get(Uri.parse('$movieDetailUrl$movieID$apiKey'));
  if (response.statusCode == 200) {
    final decodedData = json.decode(response.body);

    final movie = Movie.fromJson(decodedData);
    return movie;
  } else {
    throw Exception("Something happened");
  }
}





  Future<List<Genre>> getGenres() async
  {
    final response = await http.get(Uri.parse(movieGenresUrl));
    if(response.statusCode == 200)
    {
      final decodedData = json.decode(response.body)['genres'] as List;
      return decodedData.map((genre) => Genre.fromJson(genre)).toList();
    }
    else
    {
      throw Exception("Something happened");
    }
  }

   Future<List<Movie>> fetchAllMoviesWithPage(int page, String category) async 
   {
  
    String url = '';
    
    if (category == "What's on at the cinema?") 
    {
      url = '$cinemaUrl&page=$page';

    } 
    else if (category == "What are the best movies this year?")
    {
      url = '$popularUrl&page=$page';

    }
    else if (category == "What are the highest grossing movies of all time?")
    {
      url = '$highestGrossingUrl&page=$page';

    }
    else if (category == "Children-friendly movies")
    {
      url = '$childrenFriendlyUrl&page=$page';
    }
    else if (category == "What's on TV tonight?")
    {
      url = '$tvUrl&page=$page';
    }

    final response = await http.get(Uri.parse(url),);
    

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> movies = data['results'] as List;
      return (movies.map((json) => Movie.fromJson(json)).toList());
    } else {
      throw Exception('Something Happened');
    }
  }


  Future<List<Movie>> searchList(String search) async
  {
    var searchResponse = await http.get(Uri.parse('${searchUrl}${search}'));
    if (searchResponse.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(searchResponse.body);
      List<dynamic> movies = data['results'] as List;

      if (movies.length > 20)
      {
        movies.removeRange(20, movies.length);
      }
      return (movies.map((json) => Movie.fromJson(json)).toList());

    } else {
      throw Exception('Details Not Found');
    }

  }
}