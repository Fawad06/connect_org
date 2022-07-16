class MyUser {
  final String id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String? imageUrl;
  final String userType;
  final bool isVerified;
  final bool isActive;
  final DateTime dateCreated;
  final List<String> likedOrganizations;

  MyUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.imageUrl,
    required this.userType,
    required this.isVerified,
    required this.isActive,
    required this.dateCreated,
    required this.likedOrganizations,
  });

  MyUser.fromJson(
    Map<String, dynamic> jsonData,
    List<String> likedOrganizationIds,
  )   : id = jsonData["_id"] ?? "null id",
        firstName = jsonData["firstName"] ?? "null firstName",
        lastName = jsonData["lastName"] ?? "null lastName",
        username = jsonData["userName"] ?? "null userName",
        email = jsonData["email"] ?? "null email",
        imageUrl = jsonData["image"],
        userType = jsonData["userType"] ?? "null userType",
        isVerified = jsonData['isVerified'],
        isActive = jsonData['isActive'],
        dateCreated = DateTime.parse(jsonData['createdAt']),
        likedOrganizations = likedOrganizationIds;

  toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "email": email,
        "image": imageUrl,
        "user_type ": userType,
      };
}
