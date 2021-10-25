import 'package:cach/model.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

final GetIt getIt = GetIt.instance;

void setup() async {
  getIt.registerSingleton<Dio>(
    Dio(
      BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        connectTimeout: 5000,
        receiveTimeout: 3000,
      ),
    ),
  );
}

void setupStorage() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Todo>(TodoAdapter());
}
