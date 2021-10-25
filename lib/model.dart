import 'package:hive/hive.dart';
part 'model.g.dart';

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  int userId;
  @HiveField(1)
  int id;
  @HiveField(2)
  String title;
  @HiveField(3)
  bool completed;
  @HiveField(3)
  bool isFavorited = false;
  Todo({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Todo.fromJSON(Map<String, dynamic> json) {
    return Todo(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}
