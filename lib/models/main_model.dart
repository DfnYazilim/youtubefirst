class MainModel {
  MainModel({
      this.key, 
      this.name, 
      this.dbValue,});

  MainModel.fromJson(dynamic json) {
    key = json['key'];
    name = json['name'];
    dbValue = json['dbValue'];
  }
  String? key;
  String? name;
  String? dbValue;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['name'] = name;
    map['dbValue'] = dbValue;
    return map;
  }

}