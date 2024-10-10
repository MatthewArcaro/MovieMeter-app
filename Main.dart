import 'package:flutter/material.dart';
import 'package:moviemeter/movie_details.dart'; // Ensure this file contains the MovieDetailPage widget
import 'tmbd_services.dart'; // Updated to use TMDb service
import 'movie.dart'; // Ensure this file contains your Movie class

void main() => runApp(const MyApp());

///// MAIN MY APP 
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

/// _MYAPPSTATE
class _MyAppState extends State<MyApp> {
  int _selectedPage = 0;
  bool _isDarkTheme = false; // If light, then false; if true, then dark is on.
  final List<Movie> _favoriteMovies = []; // List to hold favorite movies

  // To turn dark theme on or off
  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

 // Function to toggle favorite status
  void _toggleFavorite(Movie movie) {
    setState(() {
      if (_favoriteMovies.contains(movie)) {
        _favoriteMovies.remove(movie); // Remove from favorites
      } else {
        _favoriteMovies.add(movie); // Add to favorites
      }
    });
  }

  // Method to return the widget options for the bottom navigation
  List<Widget> _widgetOptions() {
    return [
      // Search page must include all these
      SearchPage(
        isDarkTheme: _isDarkTheme,
        toggleFavorite: _toggleFavorite,
        favoriteMovies: _favoriteMovies,
      ),
      // Favorites page does not need anything besides these
      FavoritePage(
        favoriteMovies: _favoriteMovies,
        toggleFavorite: _toggleFavorite,
      ),
      /// Profile page
      ProfilePage(
        isDarkTheme: _isDarkTheme,
        toggleTheme: _toggleTheme,
      ),
    ];
  }

  // Changes on tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  // Home page build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkTheme ? _darkTheme() : _lightTheme(),
      home: Scaffold(
        body: Center(
          child: _widgetOptions()[_selectedPage],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search', // Items on the bottom of the search bar
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
            ),
          ],
          currentIndex: _selectedPage,
          onTap: _onItemTapped, // To navigate in between
        ),
      ),
    );
  }

  // Dark theme settings
  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.deepPurple,
      hintColor: Colors.tealAccent,
      scaffoldBackgroundColor: Colors.black,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white),
      ),
    );
  }

  // Light theme settings 
  ThemeData _lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      hintColor: Colors.amberAccent,
      scaffoldBackgroundColor: Colors.white,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.grey[200],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.black),
      ),
    );
  }
}

/// Search Page
class SearchPage extends StatefulWidget {
  final bool isDarkTheme;
  final List<Movie> favoriteMovies;
  final Function(Movie) toggleFavorite;

  const SearchPage({
    super.key,
    required this.isDarkTheme,
    required this.favoriteMovies,
    required this.toggleFavorite,
  });

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final TMDbService _tmdbService = TMDbService(); // Initialize the TMDbService
  List<Movie> _filteredMovies = [];
  List<Movie> _recommendedMovies =[]; // Store recommended movie which is the popular ones 
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _filterMovies(_searchController.text);
    });
    _fetchRecommendedMovies(); /// fetching movies
  }

  Future<void> _fetchRecommendedMovies() async{
    setState(() {
      _isLoading = true;
    });
    try{
      List<Movie> movies = await _tmdbService.getPopularMovies(); // in movie_services
      setState(() {
        _recommendedMovies = movies;
        _filteredMovies = movies;
      });
    } catch (e){
      print('Error fetching recommded movies: $e');
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to search movies based on query
  void _filterMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredMovies = [];
      });
    } else {
      setState(() {
        _isLoading = true;
      });
      try {
        List<Movie> movies = await _tmdbService.searchMovies(query);
        setState(() {
          _filteredMovies = movies;
        });
      } catch (e) {
        print('Error: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = widget.isDarkTheme ? Colors.tealAccent : Colors.black;
    Color fillColor = widget.isDarkTheme ? Colors.grey[800]! : Colors.grey[300]!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MovieMeter',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textColor,
              letterSpacing: 1.5,
              shadows: [
                Shadow(
                  blurRadius: 6.0,
                  color: widget.isDarkTheme ? Colors.black87 : Colors.grey[500]!,
                  offset: const Offset(2.0, 2.9),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search for a movie...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              filled: true,
              fillColor: fillColor,
              hintStyle: TextStyle(color: Colors.grey[400]),
            ),
            style: TextStyle(color: textColor),
          ),
          const SizedBox(height: 10),

          // Suggestions label
          Text(
            'Suggestions',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),

          // Movie suggestions
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredMovies.isEmpty
                    ? Center(
                        child: Text(
                          "No movies found",
                          style: TextStyle(color: textColor),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredMovies.length,
                        itemBuilder: (context, index) {
                          final movie = _filteredMovies[index];
                          final isFavorite = widget.favoriteMovies.contains(movie);

                          return ListTile(
                            title: Text(
                              movie.title,
                              style: TextStyle(color: textColor),
                            ),
                            leading: Image.network(movie.posterUrl), // Display the movie poster
                            trailing: IconButton(
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.red : textColor,
                              ),
                              onPressed: () {
                                widget.toggleFavorite(movie); // Toggle favorite status
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailPage(
                                    movieTitle: movie.title,
                                    movieDescription: movie.overview,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

/// Favorite Page
class FavoritePage extends StatelessWidget {
  final List<Movie> favoriteMovies;
  final Function(Movie) toggleFavorite; // Function to toggle favorite status

  const FavoritePage({
    super.key,
    required this.favoriteMovies,
    required this.toggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Favorite Movies',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20), // Spacing between title and list

          // Favorite movies list
          Expanded(
            child: favoriteMovies.isEmpty
                ? const Center(
                    child: Text("No favorites yet!"),
                  )
                : ListView.builder(
                    itemCount: favoriteMovies.length,
                    itemBuilder: (context, index) {
                      final movie = favoriteMovies[index];
                      return ListTile(
                        title: Text(movie.title), // Display the movie title
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite),
                          color: Colors.red,
                          onPressed: () {
                            toggleFavorite(movie); // Toggle favorite status
                          },
                        ),
                        onTap: () {
                          // Navigate to the MovieDetailPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailPage(
                                movieTitle: movie.title,
                                movieDescription: movie.overview,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Profile Page
class ProfilePage extends StatelessWidget {
  final bool isDarkTheme;
  final Function toggleTheme;

  const ProfilePage({
    super.key,
    required this.isDarkTheme,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Settings',
            style: TextStyle(fontSize: 28),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              toggleTheme(); // Toggle the theme
            },
            child: Text(isDarkTheme ? 'Switch to Light Theme' : 'Switch to Dark Theme'),
          ),
        ],
      ),
    );
  }
}
