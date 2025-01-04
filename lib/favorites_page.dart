import 'package:flutter/material.dart';
import 'movie.dart';
import 'movie_details.dart';

class FavoritePage extends StatelessWidget {
  final List<Movie> favoriteMovies;
  final Function(Movie) toggleFavorite;
  final int userId;

  const FavoritePage({
    super.key,
    required this.favoriteMovies,
    required this.toggleFavorite,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Movies'),
      ),
      body: favoriteMovies.isEmpty
          ? const Center(
              child: Text('No favorite movies added yet.'),
            )
          : ListView.builder(
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = favoriteMovies[index];
                return ListTile(
                  leading: Image.network(movie.posterUrl, fit: BoxFit.cover),
                  title: Text(movie.title),
                  subtitle: Text('Rating: ${movie.voteAverage}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () => toggleFavorite(movie),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailPage(
                          movieTitle: movie.title,
                          movieDescription: movie.overview,
                          movieRating: movie.voteAverage,
                          movieId: movie.id,
                          posterUrl: movie.posterUrl, // Pass posterUrl here
                          releaseDate: movie.releaseDate, // Pass releaseDate here
                          userId: userId, // Pass userId here
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
