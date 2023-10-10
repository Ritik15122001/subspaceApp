import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'blog_screen.dart';

class FavoriteScreen extends StatelessWidget {
  final List<dynamic> favoriteBlogs;

  FavoriteScreen(this.favoriteBlogs);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Blogs'),
      ),
      body: ListView.builder(
        itemCount: favoriteBlogs.length,
        itemBuilder: (context, index) {
          final blog = favoriteBlogs[index];
          return ListTile(
            leading: Image.network(blog['image_url'] ?? ''),
            title: Text(blog['title'] ?? 'No Title'),
            subtitle: Text(blog['content'] ?? 'No Content'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlogDetailsScreen(
                    title: blog['title'] ?? 'No Title',
                    imageUrl: blog['image_url'] ?? '',
                    content: blog['content'] ?? 'No Content', isFavorite: false, onFavoritePressed: () {},
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
