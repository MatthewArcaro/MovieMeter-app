import 'package:flutter/material.dart';
import 'movie.dart';
import 'moviesbycategory.dart';

class CategoriesPage extends StatelessWidget {
  final int userId;
  final Function(Movie) toggleFavorite;
  final List<Movie> favoriteMovies; 

  CategoriesPage({
    super.key,
    required this.userId,
    required this.toggleFavorite,
    required this.favoriteMovies, 
  });

  final List<Map<String, String>> categories = [
    {'id': '28', 'name': 'Action'},
    {'id': '35', 'name': 'Comedy'},
    {'id': '27', 'name': 'Horror'},
    {'id': '10749', 'name': 'Romance'},
    {'id': '16', 'name': 'Animation'},
    {'id': '878', 'name': 'Science Fiction'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MoviesByCategoryPage(
                    categoryId: category['id']!,
                    categoryName: category['name']!,
                    userId: userId,
                    toggleFavorite: toggleFavorite,
                    favoriteMovies: favoriteMovies, // Pass the favorites list
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: const Color.fromARGB(255, 254, 208, 83),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_movies,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          category['name']!,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
