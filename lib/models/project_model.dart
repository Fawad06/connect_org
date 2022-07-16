import 'package:connect_org/models/organization_model.dart';

class Project {
  final String id;
  final String title;
  final String description;
  final DateTime dateStarted;
  final DateTime dateCreated;
  final DateTime? dateEnded;
  final bool isAccepted;
  final String senderId;
  final String receiverId;
  final Organization collaborator1;
  final Organization collaborator2;
  final List<ProjectTask> tasks;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.dateStarted,
    required this.dateCreated,
    required this.dateEnded,
    required this.isAccepted,
    required this.senderId,
    required this.receiverId,
    required this.collaborator1,
    required this.collaborator2,
    required this.tasks,
  });

  Project.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        title = json['title'],
        description = json['description'],
        isAccepted = json['isAccepted'],
        senderId = json['sender'],
        receiverId = json['receiver'],
        dateStarted = DateTime.parse(json['dateStarted']),
        dateEnded = DateTime.parse(json['dateEnded']),
        dateCreated = DateTime.parse(json['createdAt']),
        collaborator1 = Organization.fromJson(json["collaborator1"]),
        collaborator2 = Organization.fromJson(json["collaborator2"]),
        tasks = List<ProjectTask>.from(
          json["tasks"]
              .map((taskJson) => ProjectTask.fromJson(taskJson))
              .toList(),
        );
}

class ProjectTask {
  final String id;
  final String ownerId;
  final String title;
  final String description;
  final String? fileUrl;
  bool isCompleted;

  ProjectTask({
    required this.id,
    required this.ownerId,
    required this.title,
    this.fileUrl,
    required this.description,
    required this.isCompleted,
  });

  ProjectTask.fromJson(Map<String, dynamic> json)
      : id = json["_id"],
        ownerId = json["ownerId"],
        title = json["title"],
        description = json["description"],
        isCompleted = json["isCompleted"],
        fileUrl = json["fileUrl"];
}
