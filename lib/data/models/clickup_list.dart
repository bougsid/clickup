import 'status.dart';

class ClickupList {
  String id;
  String name;
  int orderindex;
  String content;
  dynamic assignee;
  dynamic taskCount;
  String dueDate;
  bool dueDateTime;
  DateTime startDate;
  DateTime startDateTime;
  String folderId;
  String spaceId;
  List<Status> statuses;
  String inboundAddress;

  ClickupList(
      {this.id,
      this.name,
      this.orderindex,
      this.content,
      this.assignee,
      this.taskCount,
      this.dueDate,
      this.dueDateTime,
      this.startDate,
      this.startDateTime,
      this.folderId,
      this.spaceId,
      this.statuses,
      this.inboundAddress});

  ClickupList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    orderindex = json['orderindex'];
    content = json['content'];
    assignee = json['assignee'];
    taskCount = json['task_count'];
    dueDate = json['due_date'];
    dueDateTime = json['due_date_time'];
    startDate = json['start_date'];
    startDateTime = json['start_date_time'];
    // folder = json['folder']['id'];
    // space = json['space']['id'];
    if (json['statuses'] != null) {
      statuses = new List<Status>();
      json['statuses'].forEach((v) {
        statuses.add(new Status.fromJson(v));
      });
    }
    inboundAddress = json['inbound_address'];
  }

  ClickupList.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    folderId = map['folder_id'];
    name = map['name'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'folder_id': folderId,
      'name': name,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['orderindex'] = this.orderindex;
    data['content'] = this.content;
    data['assignee'] = this.assignee;
    data['task_count'] = this.taskCount;
    data['due_date'] = this.dueDate;
    data['due_date_time'] = this.dueDateTime;
    data['start_date'] = this.startDate;
    data['start_date_time'] = this.startDateTime;
    data['folder'] = this.folderId;
    data['space'] = this.spaceId;
    if (this.statuses != null) {
      data['statuses'] = this.statuses.map((v) => v.toJson()).toList();
    }
    data['inbound_address'] = this.inboundAddress;
    return data;
  }
}
