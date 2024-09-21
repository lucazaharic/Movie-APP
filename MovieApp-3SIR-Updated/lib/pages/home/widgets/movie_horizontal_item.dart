import 'package:flutter/material.dart';
import 'package:movie_app/common/utils.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/pages/details/movie_details_page.dart'; // Importing the new details page

class MovieHorizontalItem extends StatelessWidget {
  const MovieHorizontalItem({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigating to the MovieDetailsPage when the movie is clicked
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsPage(
                movie: movie), // Passando o objeto movie completo
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            height: 200,
            width: 140,
            foregroundDecoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.transparent,
                ],
              ),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage('$imageUrl${movie.posterPath}'),
              ),
            ),
          ),
          Positioned(
            left: 15,
            right: 15,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
