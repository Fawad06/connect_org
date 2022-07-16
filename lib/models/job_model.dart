import 'organization_model.dart';

class Job {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int salaryMin;
  final int salaryMax;
  final DateTime dateCreated;
  final DateTime dueDate;
  final bool isFullTime;
  final bool? isActive;
  final Organization organization;

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.isFullTime,
    this.isActive,
    required this.dateCreated,
    required this.dueDate,
    required this.imageUrl,
    required this.salaryMin,
    required this.salaryMax,
    required this.organization,
  });

  String get getPay {
    bool minIsThousand = false;
    bool maxIsThousand = false;
    minIsThousand = salaryMin >= 1000;
    maxIsThousand = salaryMax >= 1000;
    return salaryMin == salaryMax
        ? "\$${(minIsThousand ? salaryMin / 1000 : salaryMin).toStringAsFixed(0) + (minIsThousand ? "k" : "")}/per year"
        : "\$${(minIsThousand ? salaryMin / 1000 : salaryMin).toStringAsFixed(0) + (minIsThousand ? "k" : "")}-\$${(maxIsThousand ? salaryMax / 1000 : salaryMax).toStringAsFixed(0) + (maxIsThousand ? "k" : "")}/per year";
  }

  Job.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['_id'],
        title = jsonData['title'],
        description = jsonData['description'],
        salaryMin = jsonData['minSalary'],
        salaryMax = jsonData['maxSalary'],
        isFullTime = jsonData['isFullTime'],
        isActive = jsonData["isActive"],
        dueDate = DateTime.parse(jsonData['dueDate']),
        dateCreated = DateTime.parse(jsonData['createdAt']),
        organization = Organization.fromJson(jsonData['organizationDetail']??jsonData["organization"]),
        imageUrl = jsonData['image'] ??
            "https://img.freepik.com/free-vector/freelance-character-modern-job-typography-banner_81522-2194.jpg?size=626&ext=jpg";
}
