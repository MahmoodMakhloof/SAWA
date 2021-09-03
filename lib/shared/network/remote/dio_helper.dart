import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;
  static dioInit() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response<dynamic>> getData({
    required String url,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    String? localToken = token;
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': localToken == null ? '' : localToken,
      'lang': lang,
    };
    return await dio!.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response<dynamic>> postData(
      {required String url,
      Map<String, dynamic>? query,
      String lang = 'en',
      String? token,
      required Map<String, dynamic> data}) async {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token != null ? token : '',
    };
    return await dio!.post(
      url,
      data: data,
      queryParameters: query,
    );
  }

  static Future<Response<dynamic>> updateData(
      {required String url,
      Map<String, dynamic>? query,
      String lang = 'en',
      String? token,
      required Map<String, dynamic> data}) async {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token != null ? token : '',
    };
    return await dio!.put(
      url,
      data: data,
      queryParameters: query,
    );
  }
}
