import 'package:connect_org/models/user_model.dart';

class Post {
  final String id;
  final String title;
  final String text;
  final String imageUrl;
  final DateTime dateCreated;
  final MyUser author;

  final bool isLiked;

  final int likes;
  Post(
    this.id,
    this.title,
    this.text,
    this.imageUrl,
    this.dateCreated,
    this.isLiked,
    this.likes,
    this.author,
  );
}
