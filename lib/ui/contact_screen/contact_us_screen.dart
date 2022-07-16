import 'package:connect_org/generated/assets.dart';
import 'package:connect_org/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../widgets/my_back_button.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 90,
        title: SquareButton(
          icon: Icons.arrow_back_ios_rounded,
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: kDefaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Contact Us,",
                  style: theme.textTheme.headline5
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 60),
                Container(
                  width: double.maxFinite,
                  height: 500,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.background,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(200),
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    boxShadow: kContainerShadow,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.phone,
                          color: theme.iconTheme.color,
                          size: 28,
                        ),
                        title: Text(
                          "000-111-222-333",
                          style: theme.textTheme.headline6,
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.mail,
                          color: theme.iconTheme.color,
                          size: 28,
                        ),
                        title: Text(
                          "abc123@gmail.com",
                          style: theme.textTheme.headline6,
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: SvgPicture.asset(
                          Assets.iconsLocation,
                          color: theme.iconTheme.color,
                          width: 34,
                        ),
                        title: Text(
                          "417 Pin Oak Dr.",
                          style: theme.textTheme.headline6,
                        ),
                        subtitle: Text(
                          "New Philadelphia, OH 44663",
                          style: theme.textTheme.headline6,
                        ),
                      ),
                      Row(
                        children: const [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(hintText: "Name"),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(hintText: "Email"),
                            ),
                          ),
                        ],
                      ),
                      const TextField(
                        decoration: InputDecoration(hintText: "Message"),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("Send Message"),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
