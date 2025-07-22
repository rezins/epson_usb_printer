class Paper{
  late int id;
  late String name;
  late double width;
  late double height;

  Paper(this.id,  this.name,  this.width,  this.height);

  Paper.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['width'] = width;
    data['height'] = height;
    return data;
  }
}