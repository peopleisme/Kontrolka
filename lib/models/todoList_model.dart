import 'package:hive/hive.dart';
import 'package:namer_app/models/task_model.dart';

part 'todoList_model.g.dart';

@HiveType(typeId: 3)
class todoList extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String date;
  @HiveField(2)
  late bool isDaily;
  @HiveField(3)
  List<Task> taskList;
  todoList(
      {required this.name,
      required this.date,
      required this.isDaily,
      required this.taskList});
}
