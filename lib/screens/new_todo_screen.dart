import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../helpers/api.dart';
import '../models/todo_model.dart';

class NewTodoScreen extends StatefulWidget {
   // Function<bool>(bool i) fn;
   NewTodoScreen({Key? key,}) : super(key: key);

  @override
  State<NewTodoScreen> createState() => _NewTodoScreenState();
}

class _NewTodoScreenState extends State<NewTodoScreen> {
  final _saveKey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _saveKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                validator: (v) {
                  if (v == null || v.length < 3) {
                    return "Min 3 chars";
                  }
                },
                controller: _title,
                decoration: const InputDecoration(
                    hintText: "Title", labelText: "Title")),
            TextFormField(
                validator: (v) {
                  if (v == null || v.length < 3) {
                    return "Min 10 chars";
                  }
                },
                controller: _description,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                    hintText: "Description",
                    labelText: "Description")),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: ElevatedButton(
                onPressed: () {
                  _saveKey.currentState!.save();
                  if (_saveKey.currentState!.validate()) {
                    TodoModel tomodel = TodoModel(
                        title: _title.text,
                        description: _description.text);

                    Api()
                        .dioPost(
                        url: 'todo', obj: tomodel.toJson())
                        .then((value) {
                      if (value?.statusCode == 200) {
                        // widget.fn = true;
                        Navigator.pop(context,true);
                      }
                      Fluttertoast.showToast(
                          msg: value?.statusCode == 200
                              ? "Success"
                              : "Fail",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor:
                          value?.statusCode == 200
                              ? Colors.green
                              : Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    });
                  }
                },
                child: const Text("New TODO"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}