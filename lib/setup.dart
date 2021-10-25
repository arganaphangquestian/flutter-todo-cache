import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  await Hive.initFlutter();
  getIt.registerSingleton<Dio>(setupDio());
}

Dio setupDio() {
  var dio = Dio();
  dio.options.baseUrl = 'https://jsonplaceholder.typicode.com';
  dio.options.connectTimeout = 5000; //5s
  dio.options.receiveTimeout = 3000; //5s
  dio.interceptors.add(setJsonHeader());
  return dio;
}

InterceptorsWrapper setJsonHeader() {
  return InterceptorsWrapper(
    onRequest: (options, handler) {
      options.contentType = "application/json";
      // Loading
    },
    onResponse: (options, handler) {},
    onError: (options, handler) {
      // GetX pop up
      debugPrint("Error cok");
    },
  );
}
