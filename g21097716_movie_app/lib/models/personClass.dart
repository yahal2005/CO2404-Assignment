
import 'package:cinematic_insights/models/movieClass.dart';

class Person
{
  String name;
  String profilePath;
  String knownDepartment;
  int gender;
  int iD;
  List<Movie> knownFor;
  double popularity;
  String mediaType;

  Person({
    required this.name,
    required this.profilePath,
    required this.knownDepartment,
    required this.gender,
    required this.iD,
    required this.knownFor,
    required this.popularity,
    required this.mediaType,

  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json["original_name"] ?? json["name"] ?? "Name not available",
      profilePath: json["profile_path"] ?? "",
      knownDepartment:json["known_for_department"] ?? "Not Available",
      gender: json["gender"] ?? 1,
      iD: json["id"] ?? -1,
      knownFor:  json["known_for"] ?? [],
      popularity:  json["popularity"] ?? 0.0,
      mediaType: json["media_type"] ?? "person",
    );
  }

}