
class Movie
{
  String title;
  String backDropPath;
  String originalTitle;
  String overview;
  String posterPath;
  int movieID;
  List<dynamic> genreIds;
  String releaseDate;
  double voteAverage;

  Movie({
    required this.title,
    required this.backDropPath,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.movieID,
    required this.genreIds,
    required this.releaseDate,
    required this.voteAverage,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json["title"] ?? json["name"] ?? "Title not available",
      backDropPath: json["backdrop_path"] ?? "Image not available",
      originalTitle:json["original_title"] ?? json["original_name"] ?? "Original title not available",
      overview: json["overview"] ?? "OverView not available",
      posterPath: json["poster_path"] ?? json["backdrop_path"],
      movieID: json["id"],
      genreIds: json["genre_ids"] ?? "",
      releaseDate: json["release_date"] ?? json["first_air_date"] ?? "Release date not available",
      voteAverage: json["vote_average"] ?? 0.0,
    );
  }

  

 /* Map<String,dynamic> toJson()
  {
    return ();
  }*/
}

