import 'package:flutter/material.dart';
import 'API_Service.dart';

class MovieDetailPage extends StatefulWidget {
  final String movieTitle;
  final String movieDescription;
  final double movieRating;
  final int movieId;
  final String posterUrl;
  final String releaseDate;
  final int userId;

  const MovieDetailPage({
    super.key,
    required this.movieTitle,
    required this.movieDescription,
    required this.movieRating,
    required this.movieId,
    required this.posterUrl,
    required this.releaseDate,
    required this.userId,
  });

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  late Future<List<dynamic>> _comments;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    // Replace with your API call to fetch comments
    _comments = ApiService.fetchComments(widget.movieId);
  }

  Future<void> _postComment(String content) async {
    if (content.isNotEmpty) {
      await ApiService.postComment(widget.movieId, widget.userId, content);
      _commentController.clear();
      setState(() {
        _fetchComments(); // Refresh comments after posting
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movieTitle, style: const TextStyle(fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster with border
            Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    widget.posterUrl,
                    height: 200,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Movie Title
            Text(
              widget.movieTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Movie Release Date and Rating
            Text(
              'Release Date: ${widget.releaseDate}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              'Rating: ⭐ ${widget.movieRating}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Movie Description
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.movieDescription,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Discussion Board
            const Text(
              'Discussion Board',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _comments,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return const Center(child: Text('No comments yet.'));
                  } else {
                    final comments = snapshot.data!;
                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return ListTile(
                          title: Text(comment['content']),
                          subtitle: Text(
                            'Posted by: ${comment['username'] ?? 'Anonymous'}',
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),

            // Input Field for Comments
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Write your comment...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await _postComment(_commentController.text);
                    },
                    child: const Text('Post'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
