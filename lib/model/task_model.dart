class TaskModel {
  final int? id;
  final String task;
  final String desc;
  final String userEmail;
  late final bool isCompleted;
  final String image;

  TaskModel({
   this.id,
   required this.task,
   required this.desc,
    required this.userEmail,
   required this.isCompleted,
   required this.image,
  });

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'task': task,
      'userEmail': userEmail,
      'desc': desc,
      'isCompleted': isCompleted ? 1 : 0,
      'image': image,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map){
    return TaskModel(
        id: map['id'],
        task: map['task'],
        userEmail: map['userEmail'] ?? '',
        desc: map['desc'],
        isCompleted: map['isCompleted'] == 1 ? true : false,
        image: map['image'],
    );
  }
}