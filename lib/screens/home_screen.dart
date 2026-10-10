import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/movie.dart';
import '../delegates/movie_search_delegate.dart';
import '../services/database_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  List<int> items = List.generate(20, (index) => index);

  @override
  void initState() {
    super.initState();

    // Tema 6: Paginación con scroll infinito
    scrollController.addListener(() {
      final nearEnd = scrollController.position.pixels + 200 >=
          scrollController.position.maxScrollExtent;
      if (nearEnd && !isLoading) {
        debugPrint('--> [SCROLL INFINITO]: Cargando siguiente bloque de peliculas...');
        loadNextPage();
      }
    });

    // Tema 5: SQLite con sqflite (prueba directa para consola)
    DatabaseService.instance.insertFavorite(550, 'Fight Club').then((_) async {
      debugPrint('--> [SQLITE]: Registro insertado con exito en favorites');
      final rows = await DatabaseService.instance.getFavorites(limit: 5);
      debugPrint('--> [SQLITE]: Filas recuperadas: $rows');
    });
  }

  void loadNextPage() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      items.addAll(List.generate(10, (index) => items.length + index));
      isLoading = false;
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartelera'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final movie = await showSearch<Movie?>(
                context: context,
                delegate: MovieSearchDelegate(
                  searchMovies: (query) async => [
                    Movie(id: 1, title: 'Inception'),
                    Movie(id: 2, title: 'Interstellar'),
                  ],
                ),
              );
              if (movie != null && context.mounted) {
                context.push('/home/movie/${movie.id}');
              }
            },
          )
        ],
      ),
      body: ListView.builder(
        controller: scrollController,
        itemCount: items.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == items.length) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListTile(
            title: Text('Película #${items[index]}'),
            onTap: () => context.push('/home/movie/${items[index]}'),
          );
        },
      ),
    );
  }
}