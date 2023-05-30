import 'package:flutter/material.dart';
import 'package:youtubefirst/helpers/api.dart';

import '../models/main_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<MainModel> _list = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MainScreen"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(),)
          : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemBuilder: (context, i) {
                  var item = _list[i];
                  return Card(
                    child: ListTile(
                      title: Text("${item.key ?? "Key not found"}"),
                      subtitle:  Text("${item.dbValue ?? "DB value not found"}"),
                    ),
                  );
                },
                itemCount: _list.length,
              ),
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    getDatas();
  }

  Future<void> getDatas() async {
    setState(() {
      _isLoading = true;
    });
    // await Future.delayed(Duration(seconds: 2));
    final result = await Api()
        .dioGet(url: 'otel/otelDetailWithParams?id=6475d17194d74962e804d08d');
    if (result?.statusCode == 200) {
      var _datas = <MainModel>[];
      Iterable _iterable = result?.data;
      _datas = _iterable.map((e) => MainModel.fromJson(e)).toList();
      _list = _datas;
    } else {
      _list = [];
    }
    setState(() {
      _isLoading = false;
    });
  }
}
