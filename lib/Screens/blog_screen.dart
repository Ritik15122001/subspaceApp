import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Favorite.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  List<dynamic> blogs = [];
  List<dynamic> favoriteBlogs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('https://intent-kit-16.hasura.app/api/rest/blogs'),
      headers: {
        'x-hasura-admin-secret':
        '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        blogs = jsonDecode(response.body)['blogs'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void toggleFavorite(int index) {
    setState(() {
      final blog = blogs[index];
      if (favoriteBlogs.contains(blog)) {
        favoriteBlogs.remove(blog);
      } else {
        favoriteBlogs.add(blog);
      }
    });
  }

  void likeBlog(int index) {
    // Implement like functionality here.
  }

  void dislikeBlog(int index) {
    // Implement dislike functionality here.
  }

  void shareBlog(int index) {
    // Implement share functionality here.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog & Article'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search action here
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: blogs.length,
        itemBuilder: (context, index) {
          final blog = blogs[index];
          final isFavorite = favoriteBlogs.contains(blog);
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlogDetailsScreen(
                    title: blog['title'] ?? 'No Title',
                    imageUrl: blog['image_url'] ?? '',
                    content: blog['content'] ?? 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                        'Pellentesque ac elit eget velit vestibulum vulputate. '
                        'Nulla facilisi. Suspendisse potenti. Donec dapibus massa nec '
                        'libero cursus, sit amet cursus mi vehicula. Integer eu '
                        'tincidunt sapien. Quisque pharetra viverra arcu in laoreet. '
                        'Pellentesque habitant morbi tristique senectus et netus et '
                        'malesuada fames ac turpis egestas. Integer vitae posuere libero.''',
                    isFavorite: isFavorite,
                    onFavoritePressed: () {
                      toggleFavorite(index);
                    },
                  ),
                ),
              );
            },
            child: BlogCard(
              title: blog['title'] ?? 'No Title',
              imageUrl: blog['image_url'] ?? '',
              content: blog['content'] ?? '',
              isFavorite: isFavorite,
              onFavoritePressed: () {
                toggleFavorite(index);
              },
              onLikePressed: () {
                likeBlog(index);
              },
              onDislikePressed: () {
                dislikeBlog(index);
              },
              onSharePressed: () {
                shareBlog(index);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FavoriteScreen(favoriteBlogs),
              ),
            );
          }
        },
      ),
    );
  }
}

class BlogCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String content;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;
  final VoidCallback onLikePressed;
  final VoidCallback onDislikePressed;
  final VoidCallback onSharePressed;

  BlogCard({
    required this.title,
    required this.imageUrl,
    required this.content,
    required this.isFavorite,
    required this.onFavoritePressed,
    required this.onLikePressed,
    required this.onDislikePressed,
    required this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Image.network(imageUrl),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              content,
              style: TextStyle(fontSize: 14.0),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: onFavoritePressed,
              ),
              IconButton(
                icon: Icon(Icons.thumb_up),
                onPressed: onLikePressed,
              ),
              IconButton(
                icon: Icon(Icons.thumb_down),
                onPressed: onDislikePressed,
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: onSharePressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BlogDetailsScreen extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String content;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;

  BlogDetailsScreen({
    required this.title,
    required this.imageUrl,
    required this.content,
    required this.isFavorite,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.network(imageUrl),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                content,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: onFavoritePressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
