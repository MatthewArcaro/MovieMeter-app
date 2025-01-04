import 'package:flutter/material.dart';
import 'search_page.dart';
import 'favorites_page.dart';
import 'profile_page.dart';
import 'CategoriesPage.dart'; // Ensure this is correctly imported
import 'movie.dart';
import 'loginpage.dart';
import 'registerpage.dart';

class MainScreen extends StatefulWidget {
  final int? userId; // Accept userId from login

  const MainScreen({super.key, this.userId});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedPage = 0;
  bool _isDarkTheme = false; // Light mode by default
  final List<Movie> _favoriteMovies = []; // List of favorite movies
  late int? _userId; // Store userId

  @override
  void initState() {
    super.initState();
    _userId = widget.userId; // Initialize userId from the widget
  }

  // Toggle dark/light theme
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

  // Handle user logout
  void _handleLogout() {
    setState(() {
      _userId = null; // Reset userId
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(
          onLogin: _handleLogin, // Pass login handler back to LoginPage
        ),
      ),
      (route) => false, // Clear all navigation history
    );
  }

  // Pages for navigation
  List<Widget> _pages() {
    return [
      SearchPage(
        isDarkTheme: _isDarkTheme,
        toggleFavorite: _toggleFavorite,
        favoriteMovies: _favoriteMovies,
        userId: _userId!, // Pass userId to SearchPage
      ),
      CategoriesPage(
        userId: _userId!, // Pass userId to CategoriesPage
        toggleFavorite: _toggleFavorite, // Provide toggleFavorite callback
        favoriteMovies: _favoriteMovies, // Pass current favorites for sync
      ),
      FavoritePage(
        favoriteMovies: _favoriteMovies,
        toggleFavorite: _toggleFavorite,
        userId: _userId!, // Pass userId to FavoritePage
      ),
      ProfilePage(
        isDarkTheme: _isDarkTheme,
        toggleTheme: _toggleTheme,
        onLogout: _handleLogout, // Handle logout
      ),
    ];
  }

  // Titles for each page
  final List<String> _pageTitles = [
    'Search Movies',
    'Categories',
    'Favorite Movies',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: _userId != null ? _buildMainScreen() : _buildAuthFlow(),
    );
  }

  // Authentication flow for login/register
  Widget _buildAuthFlow() {
    return Scaffold(
      body: Navigator(
        onGenerateRoute: (settings) {
          if (settings.name == '/register') {
            return MaterialPageRoute(builder: (context) => const RegisterPage());
          }
          return MaterialPageRoute(
            builder: (context) => LoginPage(onLogin: _handleLogin),
          );
        },
      ),
    );
  }

  // Main screen with navigation after login
  Widget _buildMainScreen() {
    return Scaffold(
      body: _pages()[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedPage,
        onTap: (index) => setState(() => _selectedPage = index),
        selectedItemColor: Colors.blue, // Highlight selected item
        unselectedItemColor: Colors.grey, // Non-selected item color
        backgroundColor: Colors.black, // Background color
      ),
    );
  }

  // Handle successful login and store userId
  void _handleLogin(int userId) {
    setState(() {
      _userId = userId; // Store logged-in userId
    });
  }
}
