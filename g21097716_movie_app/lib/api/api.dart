import 'dart:convert';
import 'package:cinematic_insights/models/movieClass.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class Api
{
  static const String apiKey = '?api_key=3c749db8d5e8d99a3e62389eff41fba3';
  static const cinemaUrl = 'https://api.themoviedb.org/3/movie/now_playing$apiKey';
  static const popularUrl = 'https://api.themoviedb.org/3/movie/popular$apiKey';
  static const highestGrossingUrl = 'https://api.themoviedb.org/3/discover/movie$apiKey&sort_by=revenue.desc';
  static const childrenFriendlyUrl = 'https://api.themoviedb.org/3/discover/movie$apiKey&adult=false&with_genres=16';
  static const tvUrl = 'https://api.themoviedb.org/3/tv/airing_today$apiKey';
  static const movieDetail = 'https://api.themoviedb.org/3/movie/';
  static const movieGenres = 'https://api.themoviedb.org/3/genre/movie/list$apiKey';





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
  final response = await http.get(Uri.parse('$movieDetail$movieID$apiKey'));
  if (response.statusCode == 200) {
    final decodedData = json.decode(response.body);

    final movie = Movie.fromJson(decodedData);
    return movie;
  } else {
    throw Exception("Something happened");
  }
}





  Future<Box<dynamic>> getGenres() async
  {
    final response = await http.get(Uri.parse((movieGenres)));
    final genreBox = Hive.box('GenreBox');
    if(response.statusCode == 200)
    {
      final decodedData = json.decode(response.body);

      final List<dynamic> genres = decodedData['genres'];
      genreBox.clear();
      
      for (var genre in genres) 
      {
        genreBox.put(genre['id'].toString(), genre['name'].toString());
      }
      return genreBox;
    }
    else
    {
      throw Exception(response);
    }
  }
 

}