import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieSearchDelegate extends SearchDelegate<Movie?> {
  final Future<List<Movie>> Function(String query) searchMovies;

  MovieSearchDelegate({required this.searchMovies})
      : super(searchFieldLabel: 'Buscar películas');

  @override
  List<Widget>? buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => query = '',
          ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    if (query.trim().isEmpty) {
      return const Center(child: Text('Escribe para buscar'));
    }

    return FutureBuilder<List<Movie>>(
      future: searchMovies(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (_, i) => ListTile(
            title: Text(movies[i].title),
            onTap: () => close(context, movies[i]),
          ),
        );
      },
    );
  }
}