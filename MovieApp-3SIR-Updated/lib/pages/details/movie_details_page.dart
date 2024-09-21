import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/services/api_services.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailsPage({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  final ApiServices apiServices = ApiServices();
  late Future<Result> recommendations;

  @override
  void initState() {
    super.initState();
    recommendations = apiServices.getRecommendedMovies(widget.movie.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exibe a sinopse do filme
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.movie.overview,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Recommended Movies',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // Exibe as recomendações
            FutureBuilder<Result>(
              future: recommendations,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.movies.isEmpty) {
                  return const Center(child: Text('No recommendations found.'));
                } else {
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.movies.length,
                      itemBuilder: (context, index) {
                        final recommendedMovie = snapshot.data!.movies[index];
                        return GestureDetector(
                          onTap: () {
                            // Abrir detalhes do filme recomendado
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MovieDetailsPage(movie: recommendedMovie),
                              ),
                            );
                          },
                          child: Container(
                            width: 120,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              children: [
                                Image.network(
                                  'https://image.tmdb.org/t/p/w500${recommendedMovie.posterPath}',
                                  fit: BoxFit.cover,
                                  height: 150,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  recommendedMovie.title,
                                  style: const TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
