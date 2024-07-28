class Task {
  String title;
  String description;
  String performanceTime;
  String? id;
  bool delete;

  Task(this.title, this.description, this.performanceTime,this.id,this.delete);

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'performanceTime': performanceTime,
      'id': id,
      'delete':delete
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      json['title'],
      json['description'],
      json['performanceTime'],
      json['id'],
      json['delete']
    );
  }
}
