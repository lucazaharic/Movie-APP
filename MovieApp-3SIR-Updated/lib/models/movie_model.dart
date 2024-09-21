import 'dart:convert';

class Result {
  int page;
  List<Movie> movies;
  int totalPages;
  int totalResults;

  Result({
    required this.page,
    required this.movies,
    required this.totalPages,
    required this.totalResults,
  });

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        page: json["page"],
        movies: List<Movie>.from(json["results"].map((x) => Movie.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}

// Classe Movie restaurada para a forma inicial padrão
class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final String releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
  });

  // Método fromJson para converter a resposta da API no objeto Movie
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? 'No Title',
      overview: json['overview'] ?? 'No Overview',
      posterPath: json['poster_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? 'Unknown',
    );
  }
}
