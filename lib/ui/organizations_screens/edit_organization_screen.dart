import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_org/controllers/organizations_controller.dart';
import 'package:connect_org/models/organization_model.dart';
import 'package:connect_org/utils/constants.dart';
import 'package:connect_org/widgets/my_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

class EditOrganizationScreen extends StatelessWidget {
  EditOrganizationScreen({Key? key, required this.organization})
      : super(key: key);
  final Organization organization;
  final controller = Get.find<OrganizationsController>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ModalProgressHUD(
      inAsyncCall: controller.isBusy.value,
      child: Scaffold(
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
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: kDefaultPadding,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Edit Details,",
                            style: theme.textTheme.headline5,
                          ),
                          kDefaultSpaceVertical,
                          Text(
                            "Name:",
                            style: theme.textTheme.bodyText1,
                          ),
                          kDefaultSpaceVerticalHalf,
                          Material(
                            elevation: 1,
                            borderRadius: BorderRadius.circular(10),
                            child: TextField(
                              onChanged: (value) {
                                controller.newName = value;
                              },
                              decoration: kTextFormFieldDecoration(
                                theme.colorScheme.background,
                                null,
                                organization.name,
                              ),
                            ),
                          ),
                          kDefaultSpaceVertical,
                          Text(
                            "Description:",
                            style: theme.textTheme.bodyText1,
                          ),
                          kDefaultSpaceVerticalHalf,
                          SizedBox(
                            height: 150,
                            child: Material(
                              elevation: 1,
                              borderRadius: BorderRadius.circular(10),
                              child: TextField(
                                minLines: null,
                                maxLines: null,
                                expands: true,
                                onChanged: (value) {
                                  controller.newDescription = value;
                                },
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                                textAlignVertical: TextAlignVertical.top,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.all(20),
                                  hintText: organization.description,
                                  hintMaxLines: 6,
                                  filled: true,
                                  fillColor: theme.colorScheme.background,
                                ),
                              ),
                            ),
                          ),
                          kDefaultSpaceVertical,
                          Text(
                            "Location:",
                            style: theme.textTheme.bodyText1,
                          ),
                          kDefaultSpaceVerticalHalf,
                          Material(
                            elevation: 1,
                            borderRadius: BorderRadius.circular(10),
                            child: TextField(
                              onChanged: (value) {
                                controller.newLocation = value;
                              },
                              decoration: kTextFormFieldDecoration(
                                theme.colorScheme.background,
                                null,
                                organization.address,
                              ),
                            ),
                          ),
                          kDefaultSpaceVertical,
                          Material(
                            elevation: 1,
                            borderRadius: BorderRadius.circular(10),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              title: Text(
                                "Open to work",
                                style: theme.textTheme.bodyText1,
                              ),
                              trailing: buildSwitch(),
                            ),
                          ),
                          kDefaultSpaceVertical,
                          Text(
                            "Background Image:",
                            style: theme.textTheme.bodyText1,
                          ),
                          kDefaultSpaceVerticalHalf,
                          SizedBox(
                            height: 0.562 * 100.w,
                            width: 100.w,
                            child: Stack(
                              children: [
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: ImageFiltered(
                                      imageFilter: ImageFilter.blur(
                                        sigmaX: 2,
                                        sigmaY: 2,
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: organization.imageUrl,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Material(
                                    shape: const CircleBorder(),
                                    color: Colors.transparent,
                                    child: InkWell(
                                      customBorder: const CircleBorder(),
                                      splashColor: Colors.black54,
                                      onTap: () {
                                        pickImage(context, theme);
                                      },
                                      child: Container(
                                        height: 80,
                                        padding: const EdgeInsets.all(10),
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          color: Colors.white70,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt_rounded,
                                          color: Colors.black54,
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
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
                  controller.editOrganizationDetails(organization.id);
                },
                child: const Text("Save Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSwitch() {
    bool workStatus = organization.workStatus;
    return StatefulBuilder(
      builder: (context, setState) {
        return Switch(
          value: workStatus,
          onChanged: (value) {
            setState(() {
              workStatus = value;
              controller.newWorkStatus.value = value;
            });
          },
        );
      },
    );
  }

  Future<void> pickImage(BuildContext context, ThemeData theme) async {
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
      }
    }
  }

  Future<File> saveImagePermanently(String path) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(path);
    final image = File('${directory.path}/$name');
    return File(path).copy(image.path);
  }
}
