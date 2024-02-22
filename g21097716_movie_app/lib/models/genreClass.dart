class Genre
{
  int id = 0;
  String name = "";

  Genre ({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json["id"] ?? "ID not available",
      name: json["name"] ??  "Name not available",
    );
  }
}