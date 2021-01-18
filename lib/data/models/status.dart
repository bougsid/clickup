import 'package:equatable/equatable.dart';

class Status extends Equatable {
  String name;
  int orderindex;
  String color;
  String type;

  Status({this.name, this.orderindex, this.color, this.type});

  Status.fromJson(Map<String, dynamic> json) {
    name = json['status'];
    orderindex = json['orderindex'];
    color = json['color'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.name;
    data['orderindex'] = this.orderindex;
    data['color'] = this.color;
    data['type'] = this.type;
    return data;
  }

  @override
  List<Object> get props => [name];
}
