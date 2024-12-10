import 'package:hive/hive.dart';

part 'problem_model.g.dart';


@HiveType(typeId: 1)
class Problem extends HiveObject{
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String type;
  @HiveField(2)
  final String description;
  Problem({
    required this.title, 
    required this.type,
    required this.description,
  });
  }