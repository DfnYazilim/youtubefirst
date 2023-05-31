import 'package:dio/dio.dart';

class Api {
  static const apiUrl = "http://localhost:9901/api/";

  Future<Response?> dioGet({required String url}) async {
    try{
      print('Dio getting : ${url}');
      Response response = await Dio().get(apiUrl + url);
      return response;
    } on DioError catch(e){
      return e.response;
    }
  }
  Future<Response?> dioDelete({required String url}) async {
    try{
      print('Dio deleting : ${url}');
      Response response = await Dio().delete(apiUrl + url);
      return response;
    } on DioError catch(e){
      return e.response;
    }
  }
  Future<Response?> dioPost({required String url, required dynamic obj}) async {
    try{
      print('Dio posting : ${url}');
      Response response = await Dio().post(apiUrl + url,data: obj);
      return response;
    } on DioError catch(e){
      return e.response;
    }
  }

  Future<Response?> dioPut({required String url, required dynamic obj}) async {
    try{
      print('Dio putting : ${url}');
      Response response = await Dio().put(apiUrl + url,data: obj);
      return response;
    } on DioError catch(e){
      return e.response;
    }
  }
}