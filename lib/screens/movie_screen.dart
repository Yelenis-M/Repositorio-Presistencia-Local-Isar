import 'package:flutter/material.dart';

class MovieScreen extends StatelessWidget {
  final String movieId;
  const MovieScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Película $movieId')),
      body: Center(child: Text('Detalle de película: $movieId')),
    );
  }
}