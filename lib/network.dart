import 'package:cach/model.dart';
import 'package:cach/setup.dart';
import 'package:dio/dio.dart';

class TodoNetwork {
  static Future<List<Todo>> getTodos() async {
    var result = await getIt.get<Dio>().get("/todos");
    var data =
        (result.data as List<dynamic>).map((e) => Todo.fromJSON(e)).toList();
    return data;
  }
}
