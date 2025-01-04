import 'dart:convert';
import 'package:http/http.dart' as http;
import 'movie.dart'; // Ensure correct import

class TMDbService {
  static const String apiKey = 'b0a913cc6703ecb37020bac38d9b6784';
  static const String baseUrl = 'https://api.themoviedb.org/3';

  // Local cache
  static final Map<String, List<Movie>> _cache = {};

  // Timeout duration
  static const Duration timeoutDuration = Duration(seconds: 10);

  /// Fetch movies based on search query
  Future<List<Movie>> searchMovies(String query) async {
    if (_cache.containsKey('search_$query')) {
      print('Using cached data for query: $query');
      return _cache['search_$query']!;
    }

    try {
      final response = await http
          .get(Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query'))
          .timeout(timeoutDuration); // Timeout handling

      if (response.statusCode == 200) {
        final List<Movie> movies = (json.decode(response.body)['results'] as List)
            .map((movieData) => Movie.fromJson(movieData))
            .toList();
        _cache['search_$query'] = movies; // Cache the result
        return movies;
      } else {
        print('Error: ${response.body}'); // Log error response
        throw Exception('Failed to load movies');
      }
    } catch (error) {
      print('Error fetching movies for query "$query": $error');
      throw Exception('Failed to fetch movies: $error');
    }
  }

  /// Fetch popular movies
  Future<List<Movie>> getPopularMovies() async {
    const cacheKey = 'popular_movies';
    if (_cache.containsKey(cacheKey)) {
      print('Using cached popular movies');
      return _cache[cacheKey]!;
    }

    try {
      final response = await http
          .get(Uri.parse('$baseUrl/movie/popular?api_key=$apiKey'))
          .timeout(timeoutDuration); // Timeout handling

      if (response.statusCode == 200) {
        final List<Movie> movies = (json.decode(response.body)['results'] as List)
            .map((movieData) => Movie.fromJson(movieData))
            .toList();
        _cache[cacheKey] = movies; // Cache the result
        return movies;
      } else {
        print('Error: ${response.body}');
        throw Exception('Failed to load popular movies');
      }
    } catch (error) {
      print('Error fetching popular movies: $error');
      throw Exception('Failed to fetch popular movies: $error');
    }
  }

  /// Fetch movies by category
  Future<List<Movie>> getMoviesByCategory(String categoryId) async {
    final cacheKey = 'category_$categoryId';
    if (_cache.containsKey(cacheKey)) {
      print('Using cached movies for category: $categoryId');
      return _cache[cacheKey]!;
    }

    try {
      final response = await http
          .get(Uri.parse('$baseUrl/discover/movie?api_key=$apiKey&with_genres=$categoryId'))
          .timeout(timeoutDuration); // Timeout handling

      if (response.statusCode == 200) {
        final List<Movie> movies = (json.decode(response.body)['results'] as List)
            .map((movieData) => Movie.fromJson(movieData))
            .toList();
        _cache[cacheKey] = movies; // Cache the result
        return movies;
      } else {
        print('Error: ${response.body}');
        throw Exception('Failed to load movies by category');
      }
    } catch (error) {
      print('Error fetching movies for category "$categoryId": $error');
      throw Exception('Failed to fetch movies by category: $error');
    }
  }

  /// Fetch movie details by movie ID
  Future<Movie> getMovieDetails(int movieId) async {
    final cacheKey = 'movie_$movieId';
    if (_cache.containsKey(cacheKey)) {
      print('Using cached details for movie ID: $movieId');
      return _cache[cacheKey]!.first;
    }

    try {
      final response = await http
          .get(Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey'))
          .timeout(timeoutDuration); // Timeout handling

      if (response.statusCode == 200) {
        final movie = Movie.fromJson(json.decode(response.body));
        _cache[cacheKey] = [movie]; // Cache the result
        return movie;
      } else {
        print('Error: ${response.body}');
        throw Exception('Failed to load movie details');
      }
    } catch (error) {
      print('Error fetching movie details for ID "$movieId": $error');
      throw Exception('Failed to fetch movie details: $error');
    }
  }

  /// Clear cache (if needed)
  void clearCache() {
    _cache.clear();
    print('Cache cleared');
  }
}
