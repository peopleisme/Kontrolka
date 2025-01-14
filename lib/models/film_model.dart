import 'package:hive/hive.dart';

part 'film_model.g.dart';


@HiveType(typeId: 2)
class Film extends HiveObject{
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String poster;
  @HiveField(2)
  final double myRating;
  @HiveField(3)
  final double imdbRating;
  @HiveField(4)
  final String plot;
  @HiveField(5)
  final int year;
  Film({
    required this.title, 
    required this.poster,
    required this.myRating,
    required this.imdbRating,
    required this.plot,
    required this.year
  });
  }