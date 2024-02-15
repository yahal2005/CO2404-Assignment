class Movie
{
  String title;
  String backDropPath;
  String originalTitle;
  String overview;
  String posterPath;
  List<dynamic> genreID = [];
  String releaseDate;
  double voteAverage;

  Movie({
    required this.title,
    required this.backDropPath,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.genreID,
    required this.releaseDate,
    required this.voteAverage,
  });

  factory Movie.fromJson(Map<String,dynamic>json)
  {
    return Movie(
      title: json["title"] ?? "Title not available",
      backDropPath: json["backdrop_path"],
      originalTitle: json["original_title"],
      overview: json["overview"],
      posterPath: json["poster_path"],
      genreID: json["genre_ids"],
      releaseDate: json["release_date"],
      voteAverage: json["vote_average"],
    );
  }

 /* Map<String,dynamic> toJson()
  {
    return ();
  }*/
}

