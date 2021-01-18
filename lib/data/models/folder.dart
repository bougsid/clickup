import 'package:clickup/data/models/clickup_list.dart';

class Folder {
  String id;
  String name;
  bool hidden;
  bool access;
  String spaceId;
  List<ClickupList> lists;
  bool isExpanded = false;

  Folder.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    spaceId = map['space_id'];
    name = map['name'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'space_id': spaceId,
    };
  }

  Folder({this.id, this.name, this.hidden, this.access});

  Folder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    hidden = json['hidden'];
    access = json['access'];
    lists = List<ClickupList>.from(json['lists'].map((model) {
      ClickupList list = ClickupList.fromJson(model);
      list.folderId = id;
      return list;
    }));
    isExpanded = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['hidden'] = this.hidden;
    data['access'] = this.access;
    return data;
  }
}
