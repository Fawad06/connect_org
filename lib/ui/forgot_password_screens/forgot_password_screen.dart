import 'package:connect_org/controllers/auth_controller.dart';
import 'package:connect_org/utils/constants.dart';
import 'package:connect_org/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../widgets/my_back_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<AuthController>();

  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      return ModalProgressHUD(
        inAsyncCall: controller.isBusy.value,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 90,
            automaticallyImplyLeading: false,
            title: SquareButton(
              icon: Icons.arrow_back_ios_rounded,
              onPressed: () => Get.back(),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: kDefaultPadding,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Forgot your password?",
                            style: theme.textTheme.headline6,
                          ),
                          kDefaultSpaceVerticalHalf,
                          Text(
                            "Please enter the details below to reset your password.",
                            style: theme.textTheme.bodyText2,
                          ),
                          kDefaultSpaceVertical,
                          kDefaultSpaceVertical,
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  onChanged: (value) {
                                    controller.email.value = value;
                                  },
                                  validator: Validators.nameValidator,
                                  decoration: kTextFormFieldDecoration(
                                    theme.colorScheme.background,
                                    null,
                                    "Enter email",
                                  ),
                                ),
                                kDefaultSpaceVerticalHalf,
                                if (controller.errorString.isNotEmpty)
                                  Text(
                                    controller.errorString.value,
                                    style: theme.textTheme.caption,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        controller.resetForgottenPassword();
                      }
                    },
                    child: const Text("Send OTP"),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
