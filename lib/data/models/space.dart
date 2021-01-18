import 'folder.dart';

class Space {
  String id;
  String name;
  bool private;
  List<Folder> folders;
  bool multipleAssignees;
  bool isExpanded = false;

  Space({
    this.id,
    this.name,
    this.private,
    this.multipleAssignees,
  });

  Space.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  Space.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    private = json['private'];
    multipleAssignees = json['multiple_assignees'];
    isExpanded = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['private'] = this.private;
    data['multiple_assignees'] = this.multipleAssignees;
    return data;
  }
}
