class Task {
  int? id;
  String? title;
  String? description;
  int? isCompleted;
  String? date;
  String? startTime;
  String? repeat;

  Task({
    this.id,
    this.title,
    this.description,
    this.isCompleted,
    this.date,
    this.startTime,
    this.repeat,
  });

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['note'];
    isCompleted = json['isCompleted'];
    date = json['date'];
    startTime = json['startTime'];
    repeat = json['repeat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['date'] = this.date;
    data['note'] = this.description;
    data['isCompleted'] = this.isCompleted;
    data['startTime'] = this.startTime;
    data['repeat'] = this.repeat;
    return data;
  }
}
