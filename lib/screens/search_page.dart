import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  static const String id = 'search_page';
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Search",
          style: TextStyle(color: Color(0XFF1E319D)),
        ),
      ),
      body: const Center(
        child: Text(
          "Search Page",
        ),
      ),
    );
  }
}
