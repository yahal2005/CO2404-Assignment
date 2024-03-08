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
  String mediaType;

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
    required this.mediaType,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json["title"] ?? json["name"] ?? "Title not available",
      backDropPath: json["backdrop_path"] ?? "",
      originalTitle:json["original_title"] ?? json["original_name"] ?? "Original title not available",
      overview: json["overview"] ?? "OverView not available",
      posterPath: json["poster_path"] ?? json["backdrop_path"] ?? "",
      movieID:  json["id"] ?? -1,
      genreIds:  json["genre_ids"] ?? ((json['genres'] as List<dynamic>).map((genre) => genre['id']).toList()) ?? [],
      releaseDate: json["release_date"] ?? json["first_air_date"] ?? "Release date not available",
      voteAverage: json["vote_average"] ?? 0.0,
      mediaType: json["media_type"] ?? "movie",
    );
  }

}

