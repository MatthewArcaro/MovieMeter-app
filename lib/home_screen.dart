import 'package:flutter/material.dart';
import 'search_page.dart';
import 'favorites_page.dart';
import 'profile_page.dart';
import 'CategoriesPage.dart'; // Ensure this is correctly imported
import 'movie.dart';

class HomeScreen extends StatefulWidget {
  final int userId;

  const HomeScreen({super.key, required this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPage = 0;
  bool _isDarkTheme = false;
  final List<Movie> _favoriteMovies = [];

  // Titles for each page
  final List<String> _pageTitles = [
    'Search Movies',
    'Categories',
    'Favorite Movies',
    'Settings',
  ];

  // Toggle theme
  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  // Add or remove a movie from favorites
  void _toggleFavorite(Movie movie) {
    setState(() {
      if (_favoriteMovies.contains(movie)) {
        _favoriteMovies.remove(movie);
      } else {
        _favoriteMovies.add(movie);
      }
    });
  }

  // Widget options for navigation
  List<Widget> _widgetOptions() {
    return [
      SearchPage(
        isDarkTheme: _isDarkTheme,
        toggleFavorite: _toggleFavorite,
        favoriteMovies: _favoriteMovies,
        userId: widget.userId,
      ),
      CategoriesPage(
        userId: widget.userId,
        toggleFavorite: _toggleFavorite, // Provide toggleFavorite callback
        favoriteMovies: _favoriteMovies, // Provide current favorites
      ),
      FavoritePage(
        favoriteMovies: _favoriteMovies,
        toggleFavorite: _toggleFavorite,
        userId: widget.userId,
      ),
      ProfilePage(
        isDarkTheme: _isDarkTheme,
        toggleTheme: _toggleTheme,
        onLogout: () => Navigator.pop(context), // Handle logout
      ),
    ];
  }

  // Handle BottomNavigationBar taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: Text(_pageTitles[_selectedPage]),
        ),
        body: Center(
          child: _widgetOptions()[_selectedPage],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedPage,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
