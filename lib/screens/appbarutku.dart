import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtubefirst/providers/todo_provider.dart';

class AppBarUtku extends StatelessWidget {
  const AppBarUtku({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Consumer<TodoProvider>(builder: (BuildContext context, asd, Widget? child) {
            return Text(asd.list.length.toString());
          },);
  }
}