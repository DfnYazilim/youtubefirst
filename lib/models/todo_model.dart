class TodoModel {
  TodoModel({
      this.id,
      this.title,
      this.description,
      this.isDone, 
      this.createdTime,
  });

  TodoModel.fromJson(dynamic json) {
    id = json['_id'];
    title = json['title'];
    description = json['description'];
    isDone = json['isDone'];
    createdTime = json['createdTime'];
  }
  String? id;
  String? title;
  String? description;
  bool? isDone;
  String? createdTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['title'] = title;
    map['description'] = description;
    // map['isDone'] = isDone;

    // map['createdTime'] = createdTime;
    return map;
  }

}