import 'package:dio/src/response.dart';
import 'package:flutter/material.dart';
import 'package:youtubefirst/helpers/api.dart';

import '../models/todo_model.dart';

class TodoProvider with ChangeNotifier {
  final _api = Api();
  List<TodoModel> _list = [];

  List<TodoModel> get list => _list;

  List<TodoModel> get waitingList => _list.where((ele)=>ele.isDone == false).toList();
  List<TodoModel> get doneList => _list.where((ele)=>ele.isDone == true).toList();

  Future<void> getDatas() async {
    final result = await _api.dioGet(url: 'todo');
    if (result?.statusCode == 200) {
      var _datas = <TodoModel>[];
      Iterable _iterable = result?.data;
      _datas = _iterable.map((e) => TodoModel.fromJson(e)).toList();

      _list = _datas;
    } else {
      _list = [];
    }
    notifyListeners();
  }
  Future<Response?> newTodo({required TodoModel model})async {
    final result = await _api
        .dioPost(
        url: 'todo', obj: model.toJson());
    print(result?.data);
    var success = result?.statusCode == 200;
    if(success){
      var newModel = TodoModel.fromJson(result?.data);
      _list.add(newModel);
      notifyListeners();
    }
    return result;
  }

  Future<Response?> setTodoDone({required String id }) async {
    final result = await _api.dioPost(url: 'todo/utku?id=${id}', obj: {});
    if(result?.statusCode == 200) {
      _list.firstWhere((element) => element.id == id,orElse: ()=>TodoModel()).isDone = true;
      notifyListeners();
    }
    return result;
  }

  Future<Response?> deleteTodo({String? id}) async {
    final result = await _api.dioDelete(url: 'todo?id=$id');
    if(result?.statusCode == 200){
      _list.removeWhere((element) => element.id ==id);
      notifyListeners();
    }
    return result;
  }
}
