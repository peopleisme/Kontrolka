import 'dart:ffi';

import 'package:hive/hive.dart';

part 'film_model.g.dart';


@HiveType(typeId: 2)
class Film extends HiveObject{
  @HiveField(0)
  final bool seen;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String poster;
  @HiveField(3)
  final double myRating;
  @HiveField(4)
  final double imdbRating;
  @HiveField(5)
  final String plot;
  @HiveField(6)
  final int year;
  Film({
    required this.seen, 
    required this.title, 
    required this.poster,
    required this.myRating,
    required this.imdbRating,
    required this.plot,
    required this.year
  });
  }