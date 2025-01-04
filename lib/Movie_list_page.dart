import 'package:flutter/material.dart';
import 'movie.dart';
import 'movie_details.dart';

class MovieListPage extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final int userId; // Add userId to pass it to MovieDetailPage

  const MovieListPage({
    super.key,
    required this.title,
    required this.movies,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return ListTile(
            leading: Image.network(movie.posterUrl, fit: BoxFit.cover, width: 50),
            title: Text(movie.title),
            subtitle: Text('Rating: ${movie.voteAverage}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailPage(
                    movieTitle: movie.title,
                    movieDescription: movie.overview,
                    movieRating: movie.voteAverage,
                    movieId: movie.id,
                    userId: userId, // Pass userId
                    posterUrl: movie.posterUrl, // Pass additional data
                    releaseDate: movie.releaseDate, // Pass additional data
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
