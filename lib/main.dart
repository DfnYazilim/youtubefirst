import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtubefirst/providers/todo_provider.dart';
import 'package:youtubefirst/screens/main_screen.dart';
import 'package:youtubefirst/screens/todo_list_screen.dart';
import 'package:youtubefirst/screens/todo_list_v2.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_)=>TodoProvider()),
  ],child: const MyApp(),),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,

      ),
      debugShowCheckedModeBanner: false,
      home: TodoListV2(),
    );
  }
}


