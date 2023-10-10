import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlogScreen extends StatefulWidget {
  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  List<dynamic> blogs = [];
  bool isLoading = true;
  bool isOnline = false;
  final int maxOfflineBlogs = 5;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    setState(() {
      isOnline = false;
    });

    if (isOnline) {
      await fetchAndStoreBlogs();
    } else {
      loadOfflineBlogs();
    }
  }

  Future<void> fetchAndStoreBlogs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
    });
  }

  void loadOfflineBlogs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? offlineBlogIds = prefs.getStringList('offline_blogs');

    if (offlineBlogIds != null && offlineBlogIds.isNotEmpty) {
      blogs = offlineBlogIds.map((id) => getOfflineBlogById(id)).toList();
    }

    setState(() {
      isLoading = false;
    });
  }


  dynamic getOfflineBlogById(String id) {
    return {
      'id': id,
      'title': 'Offline Blog Title',
      'content': 'Offline Blog Content',
      'image_url': 'https://example.com/offline-image.jpg',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog Reader'),
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
          return BlogCard(
            title: blog['title'] ?? 'No Title',
            imageUrl: blog['image_url'] ?? '',
            content: blog['content'] ?? '',
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
            icon: Icon(Icons.refresh),
            label: 'Refresh',
          ),
        ],
        onTap: (index) {
          if (index == 1 && isOnline) {
            setState(() {
              isLoading = true;
            });
            fetchAndStoreBlogs();
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

  BlogCard({
    required this.title,
    required this.imageUrl,
    required this.content,
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
        ],
      ),
    );
  }
}
