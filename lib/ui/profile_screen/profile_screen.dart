import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_org/generated/assets.dart';
import 'package:connect_org/services/user_service.dart';
import 'package:connect_org/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../widgets/my_back_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final userService = Get.find<UserService>();
  late bool isManager;
  String firstName = "";
  String lastName = "";
  String username = "";
  String email = "";
  File? file;

  @override
  initState() {
    isManager = userService.user.value!.userType == "Manager" ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  toolbarHeight: 90,
                  floating: true,
                  automaticallyImplyLeading: false,
                  title: SquareButton(
                    onPressed: () => Get.back(),
                    icon: Icons.arrow_back_ios_rounded,
                  ),
                ),
                SliverPadding(
                  padding: kDefaultPadding,
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        buildAvatar(theme, setState),
                        kDefaultSpaceVerticalHalf,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Verified Status: ",
                              style: theme.textTheme.bodyText2!.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            userService.user.value!.isVerified
                                ? const Icon(
                                    Icons.verified_rounded,
                                    color: Colors.green,
                                  )
                                : const Icon(
                                    Icons.block,
                                    color: Colors.red,
                                  )
                          ],
                        ),
                        kDefaultSpaceVertical,
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "First Name:",
                                    style: theme.textTheme.bodyText1,
                                  ),
                                  kDefaultSpaceVerticalHalf,
                                  Material(
                                    elevation: 1,
                                    borderRadius: BorderRadius.circular(10),
                                    child: TextField(
                                      onChanged: (value) {
                                        firstName = value;
                                      },
                                      decoration: kTextFormFieldDecoration(
                                        theme.colorScheme.background,
                                        null,
                                        userService.user.value!.firstName,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            kDefaultSpaceHorizontalHalf,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Last Name:",
                                    style: theme.textTheme.bodyText1,
                                  ),
                                  kDefaultSpaceVerticalHalf,
                                  Material(
                                    elevation: 1,
                                    borderRadius: BorderRadius.circular(10),
                                    child: TextField(
                                      onChanged: (value) {
                                        lastName = value;
                                      },
                                      decoration: kTextFormFieldDecoration(
                                        theme.colorScheme.background,
                                        null,
                                        userService.user.value!.lastName,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        kDefaultSpaceVertical,
                        Text(
                          "Username:",
                          style: theme.textTheme.bodyText1,
                        ),
                        kDefaultSpaceVerticalHalf,
                        Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(10),
                          child: TextField(
                            onChanged: (value) {
                              username = value;
                            },
                            decoration: kTextFormFieldDecoration(
                              theme.colorScheme.background,
                              null,
                              userService.user.value!.username,
                            ),
                          ),
                        ),
                        kDefaultSpaceVertical,
                        Text(
                          "Email:",
                          style: theme.textTheme.bodyText1,
                        ),
                        kDefaultSpaceVerticalHalf,
                        Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(10),
                          child: TextField(
                            onChanged: (value) {
                              email = value;
                            },
                            decoration: kTextFormFieldDecoration(
                              theme.colorScheme.background,
                              null,
                              userService.user.value!.email,
                            ),
                          ),
                        ),
                        kDefaultSpaceVertical,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: kDefaultPadding,
            child: ElevatedButton(
              onPressed: () {
                userService.editUser(
                  firstName.isNotEmpty
                      ? firstName
                      : userService.user.value!.firstName,
                  lastName.isNotEmpty
                      ? lastName
                      : userService.user.value!.lastName,
                  username.isNotEmpty
                      ? username
                      : userService.user.value!.username,
                  email.isNotEmpty ? email : userService.user.value!.email,
                  file?.path,
                );
              },
              child: const Text("Save Changes"),
            ),
          ),
        ],
      ),
    );
  }

  Center buildAvatar(ThemeData theme, void Function(VoidCallback fn) setState) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 150, maxHeight: 150),
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Get.dialog(
                  CachedNetworkImage(
                    imageUrl: userService.user.value!.imageUrl!,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 72,
                  backgroundImage: file != null
                      ? FileImage(file!)
                      : userService.user.value!.imageUrl != null
                          ? CachedNetworkImageProvider(
                              userService.user.value!.imageUrl!,
                            ) as ImageProvider
                          : const AssetImage(Assets.imagesProfileDp),
                ),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 0,
              child: Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () async {
                      file = await pickImage(context, theme);
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primary,
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<File?> pickImage(BuildContext context, ThemeData theme) async {
    bool? gallery;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Choose photo destination",
            style: theme.textTheme.headline6,
          ),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                    gallery = false;
                  },
                  child: Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(10),
                    color: theme.colorScheme.background,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.grey.withOpacity(0.7),
                        ),
                        Text(
                          "Camera",
                          style: theme.textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              kDefaultSpaceHorizontalHalf,
              SizedBox(
                height: 100,
                width: 100,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                    gallery = true;
                  },
                  child: Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(10),
                    color: theme.colorScheme.background,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image,
                          color: Colors.grey.withOpacity(0.7),
                        ),
                        Text(
                          "Gallery",
                          style: theme.textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    final ImagePicker _picker = ImagePicker();
    if (gallery != null) {
      final XFile? image = await _picker.pickImage(
        source: gallery! ? ImageSource.gallery : ImageSource.camera,
      );
      if (image != null) {
        final permanentImage = await saveImagePermanently(image.path);
        return permanentImage;
      }
    }
    return null;
  }

  Future<File> saveImagePermanently(String path) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(path);
    final image = File('${directory.path}/$name');
    return File(path).copy(image.path);
  }
}
