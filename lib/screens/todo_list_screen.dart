import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:youtubefirst/helpers/api.dart';
import 'package:youtubefirst/helpers/extensions.dart';
import 'package:youtubefirst/models/todo_model.dart';
import 'package:youtubefirst/widgets/loading_widget.dart';

import 'new_todo_screen.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<TodoModel> _todos = [];
  bool _isLoading = false;

  @override
  void initState() {
    getDatas();
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  Future<void> getDatas() async {
    setState(() {
      _isLoading = true;
    });
    final result = await Api().dioGet(url: 'todo');
    if (result?.statusCode == 200) {
      var _datas = <TodoModel>[];
      Iterable _iterable = result?.data;
      _datas = _iterable.map((e) => TodoModel.fromJson(e)).toList();

      _todos = _datas;
    } else {
      _todos = [];
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                isDismissible: false,
                context: context,
                builder: (_) => NewTodoScreen()).then((value) {
              print(value);
              if (value == true) getDatas().then((value) => null);
            });
          },
          child: const Icon(Icons.add)),
      appBar: AppBar(
        title: const Text("TodoList"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Waiting'),
            Tab(text: 'Done'),
          ],
        ),
      ),

      body: _isLoading
          ? LoadingWidget(
              color: Colors.orange,
            )
          : true ? TabBarView(
        controller: _tabController,
        children:List.generate(2, (tabIndex) => ListView.builder(
          itemBuilder: (context, i) {
            var item = _todos.where((element) => element.isDone == (tabIndex != 0)).toList()[i];
            return  Card(
              child: ListTile(
                onTap: () {
                  if (item.isDone == false) {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text("Is this done"),
                          content: Text(item.title ?? "-"),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel")),
                            ElevatedButton(
                                onPressed: () {
                                  Api().dioPost(
                                      url: 'todo/utku?id=${item.id}',
                                      obj: {}).then((value) {
                                    if (value?.statusCode == 200) {
                                      setState(() {
                                        item.isDone = true;
                                      });
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Couldnt't update",
                                          backgroundColor: Colors.red);
                                    }
                                    Navigator.pop(context);
                                  });
                                },
                                child: Text("Done")),
                          ],
                        ));
                  }
                },
                trailing: GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Are you sure about to delete'),
                            content: Text("${item.title ?? "-"}"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel")),
                              ElevatedButton(
                                  onPressed: () {
                                    Api()
                                        .dioDelete(
                                        url: 'todo?id=${item.id}')
                                        .then((value) {
                                      if (value?.statusCode == 200) {
                                        getDatas()
                                            .then((value) => null);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Couldnt't delete",
                                            backgroundColor:
                                            Colors.red);
                                      }
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: Text("Delete")),
                            ],
                          ));
                    },
                    child: Icon(Icons.remove_circle_outline,
                        color: Colors.red)),
                leading: item.isDone == true
                    ? Icon(
                  Icons.check,
                  color: Colors.green,
                )
                    : Icon(Icons.check_box_outline_blank),
                title: Text("${item.title ?? "-"}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${item.description ?? "-"}",
                      textAlign: TextAlign.left,
                    ),
                    Text(item.createdTime.mongoDateTime()),
                  ],
                ),
              ),
            );
          },
          itemCount: _todos.where((element) => element.isDone == (tabIndex != 0)).length,
        )),
      ):  ListView.builder(
              itemBuilder: (context, i) {
                var item = _todos[i];
                return Card(
                  child: ListTile(
                    onTap: () {
                      if (item.isDone == false) {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: Text("Is this done"),
                                  content: Text(item.title ?? "-"),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel")),
                                    ElevatedButton(
                                        onPressed: () {
                                          Api().dioPost(
                                              url: 'todo/utku?id=${item.id}',
                                              obj: {}).then((value) {
                                            if (value?.statusCode == 200) {
                                              setState(() {
                                                item.isDone = true;
                                              });
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "Couldnt't update",
                                                  backgroundColor: Colors.red);
                                            }
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Text("Done")),
                                  ],
                                ));
                      }
                    },
                    trailing: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text('Are you sure about to delete'),
                                    content: Text("${item.title ?? "-"}"),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Cancel")),
                                      ElevatedButton(
                                          onPressed: () {
                                            Api()
                                                .dioDelete(
                                                    url: 'todo?id=${item.id}')
                                                .then((value) {
                                              if (value?.statusCode == 200) {
                                                getDatas()
                                                    .then((value) => null);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: "Couldnt't delete",
                                                    backgroundColor:
                                                        Colors.red);
                                              }
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: Text("Delete")),
                                    ],
                                  ));
                        },
                        child: Icon(Icons.remove_circle_outline,
                            color: Colors.red)),
                    leading: item.isDone == true
                        ? Icon(
                            Icons.check,
                            color: Colors.green,
                          )
                        : Icon(Icons.check_box_outline_blank),
                    title: Text("${item.title ?? "-"}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${item.description ?? "-"}",
                          textAlign: TextAlign.left,
                        ),
                        Text(item.createdTime.mongoDateTime()),
                      ],
                    ),
                  ),
                );
              },
              itemCount: _todos.length,
            ),
    );
  }
}
