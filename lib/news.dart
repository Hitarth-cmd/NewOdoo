import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  fetchNews() async {
    final url = 'https://newsapi.org/v2/top-headlines?country=us&apiKey=b111cbf3a94d403cb5022a484a344f83';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        articles = data['articles'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                  child: article['urlToImage'] != null
                      ? Image.network(article['urlToImage'], height: 200, width: double.infinity, fit: BoxFit.cover)
                      : SizedBox(height: 0),
                ),
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(article['title'] ?? '', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8.0),
                      Text(article['description'] ?? '', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text("Read More", style: TextStyle(fontSize: 16)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDetailScreen(article: article),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NewsDetailScreen extends StatelessWidget {
  final Map article;

  NewsDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: article['urlToImage'] != null
                    ? Image.network(article['urlToImage'], height: 250, width: double.infinity, fit: BoxFit.cover)
                    : SizedBox(height: 0),
              ),
              SizedBox(height: 10.0),
              Text(
                article['title'] ?? '',
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Text(
                article['description'] ?? '',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20.0),
              Text(
                article['content'] ?? '',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}