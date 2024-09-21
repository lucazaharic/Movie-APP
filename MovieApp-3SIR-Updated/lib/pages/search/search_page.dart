import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/services/api_services.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/pages/details/movie_details_page.dart'; // Certifique-se de que o caminho esteja correto

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ApiServices apiServices = ApiServices();
  late Future<List<dynamic>> genres;
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    genres = apiServices.getMovieGenres();
  }

  void searchMoviesByGenre(int genreId) async {
    try {
      Result result = await apiServices.getMoviesByGenre(genreId);
      setState(() {
        movies = result.movies;
      });
    } catch (e) {
      // Exibe mensagem de erro se a busca falhar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching movies: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: CupertinoSearchTextField(
                  padding: const EdgeInsets.all(10.0),
                  prefixIcon: const Icon(
                    CupertinoIcons.search,
                    color: Colors.grey,
                  ),
                  suffixIcon: const Icon(
                    Icons.cancel,
                    color: Colors.grey,
                  ),
                  style: const TextStyle(color: Colors.white),
                  backgroundColor: Colors.grey.withOpacity(0.3),
                  onChanged: (value) {
                    // Lógica de busca pode ser adicionada aqui
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Que gênero quer ver?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              FutureBuilder<List<dynamic>>(
                future: genres,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No genres found.'));
                  } else {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: snapshot.data!.map((genre) {
                        return ElevatedButton(
                          onPressed: () {
                            searchMoviesByGenre(genre['id']);
                          },
                          child: Text(genre['name']),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              movies.isNotEmpty
                  ? Column(
                      children: movies.map((movie) {
                        return ListTile(
                          leading: Image.network(
                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(movie.title),
                          onTap: () {
                            // Navega para a página de detalhes do filme
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MovieDetailsPage(movie: movie),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
