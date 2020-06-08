import 'package:dio/dio.dart';

class ApiRepository {
  Dio api;

  ApiRepository() {
    api = Dio(
      BaseOptions(
        baseUrl: "http://192.168.15.14:3333",
      ),
    );
  }
}
