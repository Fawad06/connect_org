import 'package:connect_org/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sizer/sizer.dart';

import '../../generated/assets.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/password_field.dart';

class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<AuthController>();

  SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: kDefaultPadding,
          child: Obx(
            () {
              return ModalProgressHUD(
                inAsyncCall: controller.isBusy.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                Assets.imagesSignUpScreenIllustration,
                                width: double.maxFinite,
                                fit: BoxFit.fitWidth,
                                height: 35.h,
                              ),
                              Text(
                                "Sign Up",
                                style: theme.textTheme.headline4,
                              ),
                              // kDefaultSpaceVertical,
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     buildSocialSignInButton(
                              //       theme,
                              //       SvgPicture.asset(
                              //         Assets.iconsGoogleLogo,
                              //         height: 24,
                              //         width: 24,
                              //       ),
                              //       () {},
                              //     ),
                              //     kDefaultSpaceHorizontalHalf,
                              //     buildSocialSignInButton(
                              //       theme,
                              //       SvgPicture.asset(
                              //         Assets.iconsFacebookLogo,
                              //         height: 24,
                              //         width: 24,
                              //       ),
                              //       () {},
                              //     ),
                              //     kDefaultSpaceHorizontalHalf,
                              //     buildSocialSignInButton(
                              //       theme,
                              //       SvgPicture.asset(
                              //         Assets.iconsAppleLogo,
                              //         height: 24,
                              //         width: 24,
                              //       ),
                              //       () {},
                              //     ),
                              //   ],
                              // ),
                              // kDefaultSpaceVertical,
                              // Align(
                              //   alignment: Alignment.center,
                              //   child: Text(
                              //     "or Sign Up with email",
                              //     style: theme.textTheme.caption,
                              //   ),
                              // ),
                              kDefaultSpaceVertical,
                              TextFormField(
                                onChanged: (value) {
                                  controller.firstName.value = value;
                                },
                                validator: Validators.nameValidator,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: kTextFormFieldDecoration(
                                  theme.colorScheme.background,
                                  "First Name",
                                  "Fawad, Afaq...",
                                ),
                              ),
                              kDefaultSpaceVerticalHalf,
                              TextFormField(
                                onChanged: (value) {
                                  controller.lastName.value = value;
                                },
                                validator: Validators.nameValidator,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: kTextFormFieldDecoration(
                                  theme.colorScheme.background,
                                  "Last Name",
                                  null,
                                ),
                              ),
                              kDefaultSpaceVerticalHalf,
                              TextFormField(
                                onChanged: (value) {
                                  controller.username.value = value;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: Validators.usernameValidator,
                                decoration: kTextFormFieldDecoration(
                                  theme.colorScheme.background,
                                  "Username",
                                  null,
                                ),
                              ),
                              kDefaultSpaceVerticalHalf,
                              TextFormField(
                                onChanged: (value) {
                                  controller.email.value = value;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: Validators.emailValidator,
                                keyboardType: TextInputType.emailAddress,
                                decoration: kTextFormFieldDecoration(
                                  theme.colorScheme.background,
                                  "Email",
                                  "abc@gmail.com",
                                ),
                              ),
                              kDefaultSpaceVerticalHalf,
                              TextPasswordField(
                                obscuringPasswordController:
                                    controller.obscuringPasswordController,
                                labelText: "Password",
                              ),
                              kDefaultSpaceVerticalHalf,
                              TextPasswordField(
                                validator: (value) =>
                                    Validators.confirmPasswordValidator(
                                  controller.obscuringPasswordController.text,
                                  value,
                                ),
                                labelText: "Confirm Password",
                              ),
                              kDefaultSpaceVerticalHalf,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Sign Up as Organization Manager?",
                                    style: theme.textTheme.bodyText1,
                                  ),
                                  Switch(
                                    value: controller.isManager.value,
                                    onChanged: (value) {
                                      controller.isManager.value = value;
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    kDefaultSpaceVerticalHalf,
                    if (controller.errorString.isNotEmpty)
                      Text(
                        "Error: ${controller.errorString.value}",
                        style: theme.textTheme.caption?.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    kDefaultSpaceVerticalHalf,
                    ElevatedButton(
                      onPressed: () {
                        controller.errorString.value = "";
                        if (_formKey.currentState!.validate()) {
                          controller.signUp();
                        }
                      },
                      child: const Text("Sign Up"),
                    ),
                    kDefaultSpaceVertical,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already a user?",
                          style: theme.textTheme.bodyText1,
                        ),
                        TextButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            _formKey.currentState!.reset();
                            controller.clearVariables();
                            Get.back();
                          },
                          child: Text(
                            "Log In",
                            style: theme.textTheme.headline6?.copyWith(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildSocialSignInButton(
    ThemeData theme,
    Widget child,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: theme.colorScheme.background,
        minimumSize: const Size(90, 50),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
