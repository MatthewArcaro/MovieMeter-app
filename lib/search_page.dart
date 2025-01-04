import 'package:flutter/material.dart';
import 'tmbd_services.dart';
import 'movie.dart';
import 'movie_details.dart';

class SearchPage extends StatefulWidget {
  final bool isDarkTheme;
  final List<Movie> favoriteMovies;
  final Function(Movie) toggleFavorite;
  final int userId;

  const SearchPage({
    super.key,
    required this.isDarkTheme,
    required this.favoriteMovies,
    required this.toggleFavorite,
    required this.userId,
  });

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final TMDbService _tmdbService = TMDbService();
  List<Movie> _filteredMovies = [];
  List<Movie> _recommendedMovies = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
    _fetchRecommendedMovies();
  }

  Future<void> _fetchRecommendedMovies() async {
    _setLoading(true);
    try {
      final movies = await _tmdbService.getPopularMovies();
      if (mounted) {
        setState(() {
          _recommendedMovies = movies;
          _filteredMovies = movies;
        });
      }
    } catch (e) {
      debugPrint('Error fetching recommended movies: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _onSearchTextChanged() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _filteredMovies = _recommendedMovies;
      });
    } else {
      _searchMovies(query);
    }
  }

  Future<void> _searchMovies(String query) async {
    _setLoading(true);
    try {
      final movies = await _tmdbService.searchMovies(query);
      if (mounted) {
        setState(() {
          _filteredMovies = movies;
        });
      }
    } catch (e) {
      debugPrint('Error searching movies: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    if (mounted) {
      setState(() {
        _isLoading = value;
      });
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MovieMeter',
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildSearchBar(theme),
          const SizedBox(height: 10),
          _buildSuggestionsLabel(theme),
          const SizedBox(height: 10),
          _buildMoviesList(theme),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search for a movie...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: theme.cardColor,
        hintStyle: TextStyle(color: theme.hintColor),
      ),
      style: TextStyle(color: theme.textTheme.bodyMedium?.color),
    );
  }

  Widget _buildSuggestionsLabel(ThemeData theme) {
    if (_searchController.text.isEmpty) {
      return Text(
        "Suggestions",
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildMoviesList(ThemeData theme) {
    if (_isLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    if (_filteredMovies.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            "No movies found",
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: _filteredMovies.length,
        itemBuilder: (context, index) {
          final movie = _filteredMovies[index];
          final isFavorite = widget.favoriteMovies.contains(movie);

          return _buildMovieTile(movie, isFavorite, theme);
        },
      ),
    );
  }

  Widget _buildMovieTile(Movie movie, bool isFavorite, ThemeData theme) {
    return ListTile(
      title: Text(
        movie.title,
        style: theme.textTheme.bodyMedium,
      ),
      leading: Image.network(movie.posterUrl, fit: BoxFit.cover, width: 50),
      trailing: IconButton(
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : theme.iconTheme.color,
        ),
        onPressed: () {
          setState(() {
            widget.toggleFavorite(movie);
          });
        },
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MovieDetailPage(
            movieTitle: movie.title,
            movieDescription: movie.overview,
            movieRating: movie.voteAverage,
            movieId: movie.id,
            posterUrl: movie.posterUrl,
            releaseDate: movie.releaseDate,
            userId: widget.userId,
          ),
        ),
      ),
    );
  }
}
