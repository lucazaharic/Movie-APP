import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Importa a biblioteca http com alias
import 'dart:convert'; // Importa a biblioteca para manipulação de JSON

class MovieRecommendationsPage extends StatelessWidget {
  final int movieId;

  const MovieRecommendationsPage({Key? key, required this.movieId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recomendações de Filmes'),
      ),
      body: FutureBuilder<List<Movie>>(
        future: fetchMovieRecommendations(movieId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar recomendações.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Nenhuma recomendação disponível.'));
          }
          final movies = snapshot.data!;
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return ListTile(
                title: Text(movie.title),
                subtitle: Text(movie.overview),
              );
            },
          );
        },
      ),
    );
  }
}

Future<List<Movie>> fetchMovieRecommendations(int movieId) async {
  // Substitua pelo endpoint de recomendações da sua API.
  final response = await http.get(
      Uri.parse('https://api.example.com/movies/$movieId/recommendations'));

  if (response.statusCode == 200) {
    final List<dynamic> json = jsonDecode(response.body);
    return json.map((data) => Movie.fromJson(data)).toList();
  } else {
    throw Exception('Falha ao carregar recomendações.');
  }
}

class Movie {
  final String title;
  final String overview;

  Movie({required this.title, required this.overview});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      overview: json['overview'],
    );
  }
}
