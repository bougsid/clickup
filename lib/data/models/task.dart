import 'package:equatable/equatable.dart';

import 'status.dart';

class Task extends Equatable {
  String id;
  String listId;
  String name;
  Status status;
  String orderindex;
  List<String> tags;
  String priority;
  DateTime dueDate;
  DateTime startDate;
  String url;
  Task({
    this.id,
    this.listId,
    this.name,
    this.status,
    this.orderindex,
    this.tags,
    this.priority,
    this.dueDate,
    this.startDate,
    this.url,
  });

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    listId = json['list']['id'];
    name = json['name'];
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
    orderindex = json['orderindex'];
    tags = json['tags'].cast<String>();
    priority = json['priority'];
    if (json['due_date'] != null)
      dueDate =
          DateTime.fromMillisecondsSinceEpoch(int.parse(json['due_date']));
    if (json['start_date'] != null)
      startDate =
          DateTime.fromMillisecondsSinceEpoch(int.parse(json['start_date']));
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['list_id'] = this.listId;
    data['name'] = this.name;
    if (this.status != null) {
      data['status'] = this.status.toJson();
    }
    data['orderindex'] = this.orderindex;
    data['tags'] = this.tags;
    data['priority'] = this.priority;
    data['due_date'] = this.dueDate;
    data['start_date'] = this.startDate;
    data['url'] = this.url;
    return data;
  }

  Task.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    listId = map['list_id'];
    name = map['name'];
    status = Status(name: map['status']);
    dueDate = map['due_date'] != null
        ? DateTime.fromMillisecondsSinceEpoch(map['due_date'])
        : null;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'list_id': this.listId,
      'name': this.name,
      'status': this.status.name,
      'due_date':
          this.dueDate != null ? this.dueDate.millisecondsSinceEpoch : null,
    };
  }

  Task copyWith({
    String id,
    String name,
    Status status,
    String orderindex,
    List<String> tags,
    String priority,
    DateTime dueDate,
    DateTime startDate,
    String url,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      orderindex: orderindex ?? this.orderindex,
      tags: tags ?? this.tags,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      startDate: startDate ?? this.startDate,
      url: url ?? this.url,
    );
  }

  @override
  List<Object> get props => [id];
}
