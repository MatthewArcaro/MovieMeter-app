import 'package:flutter/material.dart';
import 'movie.dart';
import 'movie_details.dart';
import 'tmbd_services.dart';

class MoviesByCategoryPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final int userId;
  final Function(Movie) toggleFavorite;
  final List<Movie> favoriteMovies; // Added favoriteMovies parameter

  const MoviesByCategoryPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.userId,
    required this.toggleFavorite,
    required this.favoriteMovies, // Initialize favoriteMovies
  });

  @override
  State<MoviesByCategoryPage> createState() => _MoviesByCategoryPageState();
}

class _MoviesByCategoryPageState extends State<MoviesByCategoryPage> {
  late Future<List<Movie>> _movies;

  @override
  void initState() {
    super.initState();
    _movies = TMDbService().getMoviesByCategory(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _movies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No movies found'));
          } else {
            final movies = snapshot.data!;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                final isFavorite = widget.favoriteMovies.contains(movie);

                return ListTile(
                  leading: Image.network(
                    movie.posterUrl,
                    fit: BoxFit.cover,
                    width: 50,
                  ),
                  title: Text(movie.title),
                  trailing: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.toggleFavorite(movie);
                      });
                    },
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
                          userId: widget.userId,
                          posterUrl: movie.posterUrl,
                          releaseDate: movie.releaseDate,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
