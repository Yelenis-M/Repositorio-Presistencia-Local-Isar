import 'package:isar_community/isar.dart';

part 'favorite_movie.g.dart';

@collection
class FavoriteMovie {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late int movieId;

  late String title;
  String? posterPath;
}