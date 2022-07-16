import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_org/models/organization_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

import '../services/user_service.dart';
import '../utils/constants.dart';
import 'expandable_text.dart';

class OrganizationWidget extends StatelessWidget {
  const OrganizationWidget({
    Key? key,
    required this.onLikePressed,
    required this.organization,
    required this.onPressed,
  }) : super(key: key);

  final Organization organization;
  final VoidCallback onPressed;
  final void Function(bool isLiked) onLikePressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: kContainerShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              title: Text(organization.name),
              subtitle: Text(organization.address),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            CachedNetworkImage(
              imageUrl: organization.imageUrl,
              fit: BoxFit.cover,
              height: 300,
              width: double.maxFinite,
              progressIndicatorBuilder: (
                context,
                url,
                downloadProgress,
              ) {
                return Center(
                  child: CircularProgressIndicator(
                    value: downloadProgress.progress,
                  ),
                );
              },
              errorWidget: (context, url, error) {
                return const Icon(Icons.error, color: Colors.red);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildLikeButton(),
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(FontAwesomeIcons.paperPlane),
                      ),
                    ],
                  ),
                  kDefaultSpaceVerticalHalf,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4,
                    ),
                    child: MyExpandableText(
                      text: organization.description,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  LikeButton buildLikeButton() {
    return LikeButton(
      size: 28,
      circleColor: const CircleColor(
        start: Colors.pink,
        end: Colors.red,
      ),
      bubblesColor: const BubblesColor(
        dotPrimaryColor: Colors.pink,
        dotSecondaryColor: Colors.red,
      ),
      isLiked: Get.find<UserService>()
          .user
          .value!
          .likedOrganizations
          .contains(organization.id),
      onTap: (previousLikedState) {
        final nextLikedState = previousLikedState == true ? false : true;
        onLikePressed(nextLikedState);
        return Future<bool?>(() => nextLikedState);
      },
      likeBuilder: (bool isLiked) {
        return Icon(
          isLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
          color: isLiked ? Colors.red : Colors.grey,
          size: 28,
        );
      },
      likeCount: organization.likes,
      countBuilder: (count, isLiked, text) {
        var color = isLiked ? Colors.red : Colors.grey;
        Widget result;
        if (count == 0) {
          result = Text(
            "  Like",
            style: TextStyle(color: color),
          );
        } else {
          result = Text(
            "  $text",
            style: TextStyle(color: color),
          );
        }
        return result;
      },
    );
  }
}
