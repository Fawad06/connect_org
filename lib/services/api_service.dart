import 'dart:convert';

import 'package:connect_org/models/job_model.dart';
import 'package:connect_org/models/message_model.dart';
import 'package:connect_org/models/organization_model.dart';
import 'package:connect_org/models/project_model.dart';
import 'package:connect_org/utils/log_extension.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/chat_model.dart';
import '../models/user_model.dart';

class ApiService extends GetxService {
  final String baseUrl = "https://connect-org.herokuapp.com";
  final String restApiUrl = "/rest/api";
  final String userApiUrl = "/user";
  final String adminApiUrl = "/admin";
  final String managerApiUrl = "/manager";
  final String chatApiUrl = "/chat";

  Future<MyUser> signIn(String email, String password) async {
    final http.Response response = await http.post(
      Uri.parse(baseUrl + restApiUrl + userApiUrl + "/sign_in"),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        'email': email.trim(),
        'password': password.trim(),
      },
    );
    final Map<String, dynamic> jsonData = json.decode(response.body);

    if (response.statusCode == 200 && jsonData["user"] != null) {
      final List<String> likedOrgsIds = List<String>.from(
        jsonData["likedOrganizations"].map((x) => x["_id"]),
      );
      MyUser user = MyUser.fromJson(jsonData["user"], likedOrgsIds);
      'Message from ApiService: login successful'.log();
      return user;
    } else {
      'Message from ApiService: login error'.log();
      throw jsonData['message'] ?? "There was and error signing in.";
    }
  }

  Future<MyUser?> signUp(
    String firstName,
    String lastName,
    String username,
    String email,
    String password,
    bool isManager,
  ) async {
    final http.Response response = await http.post(
      Uri.parse(baseUrl + restApiUrl + userApiUrl + "/sign_up"),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'email': email,
        'user_type': isManager ? "Manager" : 'Simple User',
        'password': password,
      },
    );
    final jsonData = json.decode(response.body);
    if (response.statusCode == 200 && jsonData["user"] != null) {
      'Message from ApiService: sign up successful'.log();
      return null;
    } else {
      'Message from ApiService: sign up error'.log();
      throw jsonData['message'] ?? "There was an error signing up.";
    }
  }

  Future<bool> resetForgottenPassword(String emailOrUsername) async {
    final http.Response response = await http.post(
      Uri.parse(baseUrl + restApiUrl + userApiUrl + "/forget_password"),
      body: {
        "email": emailOrUsername.trim(),
      },
    );
    final Map<String, dynamic> jsonData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      "Message from ApiService: reset password email sent".log();
      return true;
    } else {
      throw jsonData["message"] ?? "There was an error resetting password";
    }
  }

  Future<MyUser> getUser(String? usernameOrEmail) async {
    final http.Response response = await http.get(
      Uri.parse(
        baseUrl +
            restApiUrl +
            userApiUrl +
            "/get_user" +
            "?user=${usernameOrEmail?.trim()}",
      ),
      headers: {
        'accept': 'application/json',
      },
    );
    final Map<String, dynamic> jsonData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["user"] != null) {
        final List<String> likedOrgsIds = List<String>.from(
          jsonData["likedOrganizations"].map((x) => x["_id"]),
        );
        MyUser user = MyUser.fromJson(jsonData["user"], likedOrgsIds);
        "Message from ApiService: user received".log();
        return user;
      } else {
        "Message from ApiService: user not received".log();
        throw "No user received";
      }
    } else {
      "Message from ApiService: error getting user".log();
      throw jsonData["message"] ?? "There was an error.";
    }
  }

  Future<List<Organization>> getAllOrganizations() async {
    final http.Response response = await http.get(
      Uri.parse(
        baseUrl + restApiUrl + userApiUrl + "/get_approved_organizations",
      ),
      headers: {'accept': 'application/json'},
    );
    final Map<String, dynamic> jsonData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["organizations"] != null) {
        final List<Organization> organizations = List<Organization>.from(
          jsonData["organizations"].map((x) => Organization.fromJson(x)),
        );
        "Message from ApiService: organizations received".log();
        return organizations;
      } else {
        throw "No Organizations received";
      }
    } else {
      "Message from ApiService: error getting organizations".log();
      throw jsonData["message"] ?? "There was an error getting organizations";
    }
  }

  Future<List<Job>> getAllJobs() async {
    final http.Response response = await http.get(
      Uri.parse(baseUrl + restApiUrl + adminApiUrl + "/get_jobs"),
      headers: {'accept': 'application/json'},
    );
    final Map<String, dynamic> jsonData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["jobs"] != null) {
        final List<Job> organizations = List<Job>.from(
          jsonData["jobs"].map((x) => Job.fromJson(x)),
        );
        "Message from ApiService: Jobs received".log();
        return organizations;
      } else {
        throw "No Job received";
      }
    } else {
      "Message from ApiService: Error getting jobs".log();
      throw jsonData["message"] ?? "There was an error getting jobs";
    }
  }

  Future<List<Chat>> getAllChats(String userOrOrgId) async {
    final http.Response response = await http.get(
      Uri.parse(
        baseUrl +
            restApiUrl +
            chatApiUrl +
            "/get_friend" +
            "?id=${userOrOrgId.trim()}",
      ),
      headers: {'accept': 'application/json'},
    );
    final Map<String, dynamic> jsonData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["friends"] != null) {
        final List<Chat> chats = List<Chat>.from(
          jsonData["friends"].map(
            (x) => Chat.fromJson(
              x["friend"],
              x["_id"],
              x["userId"],
              x["organizationId"],
            ),
          ),
        );
        "Message from ApiService: Chats received".log();
        return chats;
      } else {
        throw "No chat received";
      }
    } else {
      "Message from ApiService: Error getting chats".log();
      throw jsonData["message"] ?? "There was an error getting chats";
    }
  }

  Future<List<Message>> getAllMessages(String chatId) async {
    final http.Response response = await http.get(
      Uri.parse(
        baseUrl +
            restApiUrl +
            chatApiUrl +
            "/get_messages" +
            "?chatId=${chatId.trim()}",
      ),
      headers: {'accept': 'application/json'},
    );
    final Map<String, dynamic> jsonData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["data"] != null) {
        final List<Message> messages = List<Message>.from(
          jsonData["data"].map((x) => Message.fromJson(x)),
        );
        "Message from ApiService: Messages received".log();
        return messages;
      } else {
        throw "No message received";
      }
    } else {
      "Message from ApiService: Error getting messages".log();
      throw jsonData["message"] ?? "There was an error getting messages";
    }
  }

  Future<OrganizationDetails> getOrganizationDetails(
    String organizationId,
    String userId,
  ) async {
    final http.Response response = await http.get(
      Uri.parse(
        baseUrl +
            restApiUrl +
            managerApiUrl +
            "/get_organization_detail" +
            "?orgId=${organizationId.trim()}" +
            "&userId=${userId.trim()}",
      ),
      headers: {'accept': 'application/json'},
    );
    final Map<String, dynamic> jsonData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["organization"] != null) {
        final OrganizationDetails orgDetails = OrganizationDetails.fromJson(
          (jsonData["organization"] as List).first,
        );
        "Message from ApiService: organization details received".log();
        return orgDetails;
      } else {
        throw "No organization details received";
      }
    } else {
      "Message from ApiService: error getting organization details".log();
      throw jsonData["message"] ??
          "There was an error getting organization details";
    }
  }

  Future<Message> sendChatMessage({
    required String messageText,
    required String senderId,
    required String userId,
    required String otherUserId,
  }) async {
    final http.Response response = await http.post(
      Uri.parse(
        baseUrl + restApiUrl + chatApiUrl + "/add_message",
      ),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        'userId': userId.trim(),
        'organizationId': otherUserId.trim(),
        'message': messageText.trim(),
        'senderId': senderId.trim(),
      },
    );
    final Map<String, dynamic> jsonData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["data"] != null) {
        final Message message = Message.fromJson(jsonData["data"]);
        "Message from ApiService: Sent message received".log();
        return message;
      } else {
        throw "No Sent message received";
      }
    } else {
      "Message from ApiService: Error getting sent message".log();
      throw jsonData["message"] ?? "There was an error getting sent message";
    }
  }

  Future<bool> likeOrganization(String userId, String organizationId) async {
    final http.Response response = await http.post(
      Uri.parse(
        baseUrl + restApiUrl + userApiUrl + "/like_an_organization",
      ),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        'userId': userId.trim(),
        'organizationId': organizationId.trim(),
      },
    );
    final Map<String, dynamic> jsonData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["data"] != null) {
        "Message from ApiService: Organization liked".log();
        return true;
      } else {
        "Message from ApiService: Error liking: ${jsonData["message"]}".log();
        return false;
      }
    } else {
      "Message from ApiService: Error liking organization:".log();
      throw jsonData["message"] ?? "There was an error";
    }
  }

  Future<bool> unLikeOrganization(String userId, String organizationId) async {
    final http.Response response = await http.post(
      Uri.parse(
        baseUrl + restApiUrl + userApiUrl + "/unlike_an_organization",
      ),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        'userId': userId.trim(),
        'organizationId': organizationId.trim(),
      },
    );
    final Map<String, dynamic> jsonData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["data"]["deletedCount"] > 0) {
        "Message from ApiService: Organization unLiked".log();
        return true;
      } else {
        "Message from ApiService: Organization already unliked".log();
        return false;
      }
    } else {
      "Message from ApiService: Error unLiking organization:".log();
      throw jsonData["message"] ?? "There was an error";
    }
  }

  Future<List<Job>> getOrganizationJobs(String organizationId) async {
    final http.Response response = await http.get(
      Uri.parse(
        baseUrl +
            restApiUrl +
            managerApiUrl +
            "/get_organization_job" +
            "?orgId=${organizationId.trim()}",
      ),
      headers: {'accept': 'application/json'},
    );
    final Map<String, dynamic> jsonData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["jobs"] != null) {
        final List<Job> orgJobs = List<Job>.from(
          jsonData["jobs"].map((jobJson) {
            return Job.fromJson(jobJson);
          }),
        );
        "Message from ApiService: organization jobs received".log();
        return orgJobs;
      } else {
        throw "No organization jobs received";
      }
    } else {
      "Message from ApiService: error getting organization jobs".log();
      throw jsonData["message"] ??
          "There was an error getting organization jobs";
    }
  }

  Future<List<Organization>> getOwnerOrganizations(String userId) async {
    final http.Response response = await http.get(
      Uri.parse(
        baseUrl +
            restApiUrl +
            managerApiUrl +
            "/get_owner_organizations" +
            "?ownerId=${userId.trim()}",
      ),
      headers: {'accept': 'application/json'},
    );
    final Map<String, dynamic> jsonData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["organizations"] != null) {
        final List<Organization> ownerOrgs = List<Organization>.from(
          jsonData["organizations"].map(
            (json) => Organization.fromJson(json),
          ),
        );
        "Message from ApiService: Owner organizations received".log();
        return ownerOrgs;
      } else {
        throw "No  Owner organizations received";
      }
    } else {
      "Message from ApiService: error getting  Owner organizations".log();
      throw jsonData["message"] ??
          "There was an error getting  Owner organizations";
    }
  }

  Future<Organization> editOrganizationDetails({
    required String organizationId,
    required String name,
    required String description,
    required String address,
  }) async {
    final http.Response response = await http.put(
      Uri.parse(
        baseUrl + restApiUrl + managerApiUrl + "/edit_organization",
      ),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        'orgId': organizationId.trim(),
        'name': name.trim(),
        'address': address.trim(),
        'description': description.trim(),
      },
    );
    final Map<String, dynamic> jsonData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["data"]["data"] != null) {
        final Organization organization = Organization.fromJson(
          jsonData["data"]["data"],
        );
        "Message from ApiService: Edited organization received".log();
        return organization;
      } else {
        throw "No Edited organization received";
      }
    } else {
      "Message from ApiService: error getting Edited organization".log();
      throw jsonData["message"] ??
          "There was an error getting Edited organization";
    }
  }

  Future<Organization> setOrganizationWorkStatus({
    required bool setWorkStatusAsOpen,
    required String organizationId,
  }) async {
    final http.Response response = await http.post(
      Uri.parse(
        baseUrl +
            restApiUrl +
            managerApiUrl +
            "/${setWorkStatusAsOpen ? "open_work" : "close_work"}",
      ),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        'organizationId': organizationId.trim(),
      },
    );
    final Map<String, dynamic> jsonData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["data"]["_id"] != null) {
        final Organization organization = Organization.fromJson(
          jsonData["data"],
        );
        "Message from ApiService: workStatus organization received".log();
        return organization;
      } else {
        throw "No workStatus organization received";
      }
    } else {
      "Message from ApiService: error getting workStatus organization".log();
      throw jsonData["message"] ??
          "There was an error getting workStatus organization";
    }
  }

  Future<Organization> updateOrganizationPicture({
    required String organizationId,
    required String filePath,
  }) async {
    var headers = {'accept': 'application/json'};
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse(
        baseUrl + restApiUrl + managerApiUrl + '/upload_organization_picture',
      ),
    );
    request.fields.addAll({
      'orgId': organizationId.trim(),
    });
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    final Map<String, dynamic> jsonData =
        json.decode(await response.stream.bytesToString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["data"]["data"] != null) {
        final Organization organization = Organization.fromJson(
          jsonData["data"]["data"],
        );
        "Message from ApiService: updated pic organization received".log();
        return organization;
      } else {
        throw "No updated pic organization received";
      }
    } else {
      "Message from ApiService: error getting updated pic organization".log();
      throw jsonData["message"] ??
          "There was an error getting updated pic organization";
    }
  }

  Future<Job> createJob({
    required String title,
    required String description,
    required String minSalary,
    required String maxSalary,
    required String orgId,
    required bool isFullTime,
    required DateTime dateDue,
  }) async {
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request = http.Request(
      'POST',
      Uri.parse(baseUrl + restApiUrl + managerApiUrl + '/create_job'),
    );
    request.bodyFields = {
      'title': title,
      'description': description.trim(),
      'minSalary': minSalary.trim(),
      'maxSalary': maxSalary.trim(),
      'organizationId': orgId.trim(),
      'isFullTime': "$isFullTime",
      'dueDate': dateDue.toIso8601String(),
    };
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    final Map<String, dynamic> jsonData =
        json.decode(await response.stream.bytesToString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["data"]["_id"] != null) {
        final Job job = Job.fromJson(jsonData["data"]);
        "Message from ApiService: job created".log();
        return job;
      } else {
        throw "job not created";
      }
    } else {
      "Message from ApiService: error job created".log();
      throw jsonData["message"] ?? "There was an error job created";
    }
  }

  Future<Job> setJobAsActive(String jobId) async {
    final http.Response response = await http.post(
      Uri.parse(
        baseUrl + restApiUrl + managerApiUrl + "/on_job",
      ),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        'jobId': jobId.trim(),
      },
    );
    final Map<String, dynamic> jsonData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["data"]["_id"] != null) {
        final Job job = Job.fromJson(jsonData["data"]);
        "Message from ApiService: job set as on".log();
        return job;
      } else {
        throw "No job set as on received";
      }
    } else {
      "Message from ApiService: error getting job set as on".log();
      throw jsonData["message"] ?? "There was an error getting job set as on";
    }
  }

  Future<Job> setJobAsNotActive(String jobId) async {
    final http.Response response = await http.post(
      Uri.parse(
        baseUrl + restApiUrl + managerApiUrl + "/off_job",
      ),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        'jobId': jobId.trim(),
      },
    );
    final Map<String, dynamic> jsonData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["data"]["_id"] != null) {
        final Job job = Job.fromJson(jsonData["data"]);
        "Message from ApiService: job set as off".log();
        return job;
      } else {
        throw "No job set as off received";
      }
    } else {
      "Message from ApiService: error getting job set as off".log();
      throw jsonData["message"] ?? "There was an error getting job set as off";
    }
  }

  Future<bool> applyForJob(
    String userId,
    String jobId,
    String cvFilePath,
  ) async {
    var headers = {'accept': 'application/json'};
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        baseUrl + restApiUrl + userApiUrl + '/submit_application',
      ),
    );
    request.fields.addAll({
      'userId': userId.trim(),
      'jobId': jobId.trim(),
    });
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        cvFilePath,
      ),
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final Map<String, dynamic> jsonData =
        json.decode(await response.stream.bytesToString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["data"]["_id"] != null) {
        "Message from ApiService: job set as off".log();
        return true;
      } else {
        throw "No job applied";
      }
    } else {
      "Message from ApiService: error getting job applied".log();
      throw jsonData["message"] ?? "There was an error getting job applied";
    }
  }

  Future reportOrganization(
    String userId,
    String organizationId,
    String reportReason,
  ) async {
    final http.Response response = await http.post(
      Uri.parse(
        baseUrl + restApiUrl + userApiUrl + "/report_to_organization",
      ),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        'reporterId': userId.trim(),
        'reportToId': organizationId.trim(),
        'reason': reportReason.trim(),
      },
    );
    final Map<String, dynamic> jsonData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["organizations"] != null) {
        return true;
      } else {
        throw "organization not reported";
      }
    } else {
      "Message from ApiService: error organization reported".log();
      throw jsonData["message"] ?? "There was an error organization reported";
    }
  }

  Future createProject({
    required String title,
    required String description,
    required DateTime dateStarted,
    required DateTime dateEnded,
    required String senderId,
    required String receiverId,
    required List<ProjectTask> tasks,
  }) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse(baseUrl + restApiUrl + managerApiUrl + '/create_project'),
    );
    request.body = json.encode({
      "title": title,
      "description": description,
      "dateStarted": dateStarted.toIso8601String(),
      "dateEnded": dateEnded.toIso8601String(),
      "sender": senderId,
      "receiver": receiverId,
      "tasks": tasks
          .map((e) => {
                "ownerId": e.ownerId,
                "title": e.title,
                "description": e.description,
              })
          .toList(),
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    final Map<String, dynamic> jsonData =
        json.decode(await response.stream.bytesToString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["data"]["_id"] != null) {
        "Message from ApiService: project created".log();
      } else {
        throw "project not created";
      }
    } else {
      "Message from ApiService: error project created".log();
      throw jsonData["message"] ?? "There was an error project created";
    }
  }

  Future<List<Project>> getProjects({
    required String organizationId,
  }) async {
    organizationId.log();
    var headers = {'accept': 'application/json'};
    var request = http.Request(
      'GET',
      Uri.parse(
        baseUrl +
            restApiUrl +
            managerApiUrl +
            '/get_organization_project' +
            '?orgId=${organizationId.trim()}',
      ),
    );
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    final Map<String, dynamic> jsonData =
        json.decode(await response.stream.bytesToString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["projects"] != null) {
        final List<Project> projects = List<Project>.from(
          jsonData["projects"].map(
            (json) => Project.fromJson(json),
          ),
        );
        "Message from ApiService: projects received".log();
        return projects;
      } else {
        throw "project not received";
      }
    } else {
      "Message from ApiService: error project received".log();
      throw jsonData["message"] ?? "There was an error project received";
    }
  }

  Future<Organization> createOrganization(
    String userId,
    String name,
    String description,
    String location,
    String email,
    String ntn,
  ) async {
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://connect-org.herokuapp.com/rest/api/manager/create_organization'));
    request.bodyFields = {
      'ownerId': userId,
      'name': name,
      'description': description,
      'address': location,
      'email': email,
      'ntn': ntn,
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final Map<String, dynamic> jsonData =
        json.decode(await response.stream.bytesToString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["data"]["data"] != null) {
        final Organization org =
            Organization.fromJson(jsonData["data"]["data"]);
        "Message from ApiService: organization created".log();
        return org;
      } else {
        throw "organization not created";
      }
    } else {
      "Message from ApiService: error organization created".log();
      throw jsonData["message"] ?? "There was an error organization created";
    }
  }

  Future<Job> updateJobImage({
    required String jobId,
    required String filePath,
  }) async {
    var headers = {'accept': 'application/json'};
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse(baseUrl + restApiUrl + managerApiUrl + '/upload_job_picture'),
    );
    request.fields.addAll({
      'jobId': jobId.trim(),
    });
    request.files.add(
      await http.MultipartFile.fromPath('file', filePath),
    );
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    final Map<String, dynamic> jsonData =
        json.decode(await response.stream.bytesToString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["data"]["data"] != null) {
        final Job job = Job.fromJson(jsonData["data"]["data"]);
        "Message from ApiService: updated pic job received".log();
        return job;
      } else {
        throw "No updated pic job received";
      }
    } else {
      "Message from ApiService: error getting updated pic job".log();
      throw jsonData["message"] ?? "There was an error getting updated pic job";
    }
  }

  Future<bool> setTaskAsComplete({
    required String taskId,
    required String filePath,
  }) async {
    var headers = {'accept': 'application/json'};
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse(baseUrl + restApiUrl + managerApiUrl + '/edit_task'),
    );
    request.fields.addAll({'taskId': taskId.trim()});
    request.files.add(
      await http.MultipartFile.fromPath('file', filePath),
    );
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    final Map<String, dynamic> jsonData =
        json.decode(await response.stream.bytesToString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      "Message from ApiService: task updated".log();
      return true;
    } else {
      "Message from ApiService: error updating task".log();
      throw jsonData["message"] ?? "There was an error updating task";
    }
  }

  Future editUser(
    String userId,
    String firstName,
    String lastName,
    String username,
    String email,
    String? filePath,
  ) async {
    final http.Response response = await http.put(
      Uri.parse(
        baseUrl + restApiUrl + userApiUrl + "/edit_profile",
      ),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        'userId': userId.trim(),
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
        'userName': username.trim(),
        'email': email.trim(),
      },
    );
    final Map<String, dynamic> jsonData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["data"]["_id"] != null) {
        final MyUser user = MyUser.fromJson(jsonData["data"], []);
        "Message from ApiService: Edited user received".log();
        if (filePath != null) {
          await updateUserPicture(userId: user.id, filePath: filePath);
        }
      } else {
        throw "No Edited user received";
      }
    } else {
      "Message from ApiService: error getting Edited user".log();
      throw jsonData["message"] ?? "There was an error getting Edited user";
    }
  }

  Future<bool> updateUserPicture({
    required String userId,
    required String filePath,
  }) async {
    var headers = {'accept': 'application/json'};
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse(
        baseUrl + restApiUrl + managerApiUrl + '/upload_user_picture',
      ),
    );
    request.fields.addAll({
      'userId': userId.trim(),
    });
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    final Map<String, dynamic> jsonData =
        json.decode(await response.stream.bytesToString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData["user"]["_id"] != null) {
        "Message from ApiService: updated pic user".log();
        return true;
      } else {
        throw "No updated pic user";
      }
    } else {
      "Message from ApiService: error getting updated pic user".log();
      throw jsonData["message"] ??
          "There was an error getting updated pic user";
    }
  }
  // Future<List<Chat>> getAllNotifications(String userOrOrgId) async {
  //   final http.Response response = await http.get(
  //     Uri.parse(
  //       baseUrl +
  //           restApiUrl +
  //           chatApiUrl +
  //           "/get_friend" +
  //           "?id=${userOrOrgId.trim()}",
  //     ),
  //     headers: {'accept': 'application/json'},
  //   );
  //   final Map<String, dynamic> jsonData = json.decode(response.body);
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     if (jsonData["friends"] != null) {
  //       final List<Chat> chats = List<Chat>.from(
  //         jsonData["friends"].map((x) => Chat.fromJson(x)),
  //       );
  //       "Message from ApiService: Chats received".log();
  //       return chats;
  //     } else {
  //       throw "No chat received";
  //     }
  //   } else {
  //     "Message from ApiService: Error getting chats".log();
  //     throw jsonData["message"] ?? "There was an error getting chats";
  //   }
  // }
}
