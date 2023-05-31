import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:youtubefirst/models/todo_model.dart';
import 'package:youtubefirst/providers/todo_provider.dart';
import 'package:youtubefirst/widgets/loading_widget.dart';

import 'appbarutku.dart';
import 'new_todo_screen.dart';

class TodoListV2 extends StatefulWidget  {
  const TodoListV2({Key? key}) : super(key: key);

  @override
  State<TodoListV2> createState() => _TodoListV2State();
}

class _TodoListV2State extends State<TodoListV2>with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TodoProvider tp;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
     tp = Provider.of<TodoProvider>(context,listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                isDismissible: false,
                context: context,
                builder: (_) => NewTodoScreen());
          },
          child: const Icon(Icons.add)),
      appBar: AppBar(
        title: AppBarUtku(),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Waiting'),
            Tab(text: 'Done'),
          ],
        ),
      ),
      body:
           FutureBuilder(builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
             if(snapshot.connectionState ==ConnectionState.waiting){
               return LoadingWidget();
             } else {
               return TabBarView(
                 controller: _tabController,
                 children: List.generate(
                     2,
                         (tabIndex) {
                       return Consumer<TodoProvider>(builder: (BuildContext context, pv, Widget? child) {
                         return ListView.builder(
                           itemBuilder: (context, i) {
                             List<TodoModel> _list = [];
                             _list = tabIndex == 0 ? pv.waitingList: pv.doneList;
                             var item = _list[i];
                             return Card(
                               child: ListTile(
                                 onTap: () {
                                   if (item.isDone == false) {
                                     showDialog(
                                         context: context,
                                         builder: (_) => AlertDialog(
                                           title: Text("Is this done"),
                                           content:
                                           Text(item.title ?? "-"),
                                           actions: [
                                             ElevatedButton(
                                                 onPressed: () {
                                                   Navigator.pop(context);
                                                 },
                                                 child: Text("Cancel")),
                                             ElevatedButton(
                                                 onPressed: () {pv.setTodoDone(id: item.id ?? "").then((value) {
                                                   if (value
                                                       ?.statusCode ==
                                                       200) {

                                                   } else {
                                                     Fluttertoast.showToast(
                                                         msg:
                                                         "Couldnt't update",
                                                         backgroundColor:
                                                         Colors.red);
                                                   }
                                                   Navigator.pop(
                                                       context);
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
                                             title: Text(
                                                 'Are you sure about to delete'),
                                             content: Text(
                                                 "${item.title ?? "-"}"),
                                             actions: [
                                               ElevatedButton(
                                                   onPressed: () {
                                                     Navigator.pop(
                                                         context);
                                                   },
                                                   child: Text("Cancel")),
                                               ElevatedButton(
                                                   onPressed: () {
                                                     pv.deleteTodo(id: item.id)
                                                         .then((value) {
                                                       if (value
                                                           ?.statusCode ==
                                                           200) {

                                                       } else {
                                                         Fluttertoast.showToast(
                                                             msg:
                                                             "Couldnt't delete",
                                                             backgroundColor:
                                                             Colors
                                                                 .red);
                                                       }
                                                       Navigator.pop(
                                                           context);
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
                                   crossAxisAlignment:
                                   CrossAxisAlignment.start,
                                   children: [
                                     Text(
                                       "${item.description ?? "-"}",
                                       textAlign: TextAlign.left,
                                     ),
                                     // Text(item.createdTime.mongoDateTime()),
                                   ],
                                 ),
                               ),
                             );
                           },
                           itemCount:
                           tabIndex == 0 ? pv.waitingList.length : pv.doneList.length,
                         );
                       },);
                     }),
               );
             }
           },future: tp.getDatas(),)
          ,
    );
  }
}