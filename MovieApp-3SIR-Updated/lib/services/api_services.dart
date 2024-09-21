import 'dart:convert';

import 'package:movie_app/common/utils.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'https://api.themoviedb.org/3/';
const key = '?api_key=$apiKey';

class ApiServices {
  Future<Result> getTopRatedMovies() async {
    var endPoint = 'movie/top_rated';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load now playing movies');
  }

  Future<Result> getNowPlayingMovies() async {
    var endPoint = 'movie/now_playing';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load now playing movies');
  }

  Future<Result> getUpcomingMovies() async {
    var endPoint = 'movie/upcoming';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load upcoming movies');
  }

  Future<Result> getPopularMovies() async {
    const endPoint = 'movie/popular';
    const url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url), headers: {});
    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load now playing movies');
  }

  Future<Movie> getMovieDetails(int movieId) async {
    final url =
        'https://api.themoviedb.org/3/movie/$movieId?api_key=915fd0e43eabbc74e9500bb5ccec06e8&language=en-US';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Parsing da resposta JSON para o objeto Movie
        return Movie.fromJson(jsonDecode(response.body));
      } else {
        // Mensagem de erro detalhada caso a resposta não seja 200
        throw Exception(
            'Failed to load movie details: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Exibição de qualquer erro capturado durante a requisição
      throw Exception('Error fetching movie details: $e');
    }
  }

  Future<Result> getRecommendedMovies(int movieId) async {
    // Definindo o endpoint para buscar recomendações com base no ID do filme
    final endPoint = 'movie/$movieId/recommendations';
    final url = '$baseUrl$endPoint$key';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Parsing da resposta JSON para o objeto Result
        return Result.fromJson(jsonDecode(response.body));
      } else {
        // Mensagem de erro detalhada caso a resposta não seja 200
        throw Exception(
            'Failed to load recommended movies: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Exibição de qualquer erro capturado durante a requisição
      throw Exception('Error fetching recommended movies: $e');
    }
  }

  Future<List<dynamic>> getMovieGenres() async {
    final url =
        '${baseUrl}genre/movie/list?api_key=$apiKey&language=en-US'; // Corrigindo a construção da URL

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['genres'];
      } else {
        // Log detalhado do erro
        throw Exception(
            'Failed to load movie genres: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Captura e lança exceções detalhadas
      throw Exception('Error fetching movie genres: $e');
    }
  }

  Future<Result> getMoviesByGenre(int genreId) async {
    final url =
        '${baseUrl}discover/movie?api_key=$apiKey&with_genres=$genreId&language=en-US';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return Result.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to load movies by genre: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching movies by genre: $e');
    }
  }
}
