class OrganizationDetails {
  final Organization organization;
  final String chatId;
  final List<OrganizationService> services;
  final List<Review> reviews;

  OrganizationDetails({
    required this.organization,
    required this.chatId,
    required this.services,
    required this.reviews,
  });

  OrganizationDetails.fromJson(Map<String, dynamic> jsonData)
      : organization = Organization.fromJson(jsonData),
        chatId = jsonData["chatId"] ?? "",
        services = List<OrganizationService>.from(jsonData["myServices"]
            .map((element) => OrganizationService.fromJson(element))
            .toList()),
        reviews = List<Review>.from(jsonData["reviews"].map((element) {
          final reviewerDetailJson = (jsonData["reviewerDetail"] as List)
              .where((revJson) => revJson["_id"] == element["userId"])
              .first;
          return Review.fromJson(element, reviewerDetailJson);
        }).toList());
}

class Organization {
  final String id;
  final String ownerId;
  final String name;
  final String email;
  final String description;
  final String address;
  final String nationalTaxNumber;
  final String imageUrl;
  final int likes;
  final bool workStatus;
  final bool isVerified;
  final bool isApproved;
  final DateTime dateCreated;

  Organization({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.email,
    required this.description,
    required this.address,
    required this.nationalTaxNumber,
    required this.imageUrl,
    required this.workStatus,
    required this.isVerified,
    required this.isApproved,
    required this.dateCreated,
    required this.likes,
  });

  Organization.fromJson(Map<String, dynamic> json)
      : id = json["_id"],
        ownerId = json["ownerId"],
        name = json["name"],
        description = json["description"],
        address = json["address"],
        email = json["email"],
        nationalTaxNumber = json["ntn"],
        workStatus = json["workStatus"],
        imageUrl = json["image"] ??
            "https://thumbs.dreamstime.com/z/organization-word-cloud-business-concept-58626767.jpg",
        isVerified = json["isVerified"],
        isApproved = json["isApproved"],
        likes = (json["likes"] ?? []).length,
        dateCreated = DateTime.parse(json["createdAt"]);

  copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? email,
    String? description,
    String? address,
    String? nationalTaxNumber,
    String? imageUrl,
    int? likes,
    bool? workStatus,
    bool? isVerified,
    bool? isApproved,
    DateTime? dateCreated,
  }) {
    return Organization(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      email: email ?? this.email,
      description: description ?? this.description,
      address: address ?? this.address,
      nationalTaxNumber: nationalTaxNumber ?? this.nationalTaxNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      workStatus: workStatus ?? this.workStatus,
      isVerified: isVerified ?? this.isVerified,
      isApproved: isApproved ?? this.isApproved,
      dateCreated: dateCreated ?? this.dateCreated,
      likes: likes ?? this.likes,
    );
  }
}

class OrganizationService {
  final String id;
  final String orgId;
  final String name;
  final DateTime dateCreated;
  OrganizationService.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData["_id"],
        orgId = jsonData["organizationId"],
        name = jsonData["serviceName"],
        dateCreated = DateTime.parse(jsonData["createdAt"]);
}

class Review {
  final String id;
  final String message;
  final String reviewerName;
  final String reviewerImageUrl;
  final int star;
  final DateTime dateCreated;
  Review.fromJson(
    Map<String, dynamic> jsonData,
    Map<String, dynamic> reviewerJsonData,
  )   : id = jsonData["_id"],
        message = jsonData["message"],
        star = jsonData["stars"],
        dateCreated = DateTime.parse(jsonData["createdAt"]),
        reviewerName =
            reviewerJsonData["firstName"] + reviewerJsonData["lastName"],
        reviewerImageUrl = reviewerJsonData["image"];
}
