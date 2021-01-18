class Team {
  String id;
  String name;
  String color;
  dynamic avatar;

  Team({this.id, this.name, this.color, this.avatar});

  Team.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color = json['color'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['color'] = this.color;
    data['avatar'] = this.avatar;
    return data;
  }
}
