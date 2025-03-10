import 'package:hive/hive.dart';

part 'todo_model.g.dart';



@HiveType(typeId: 1)
class Task extends HiveObject{
  @HiveField(0)
  final String task;
  @HiveField(1)
  final String time;
  @HiveField(2)
  final String isChecked;
  Task({
    required this.task,
    required this.time,
    required this.isChecked,
  });
  }