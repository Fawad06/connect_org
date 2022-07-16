import 'package:connect_org/controllers/auth_controller.dart';
import 'package:connect_org/generated/assets.dart';
import 'package:connect_org/ui/forgot_password_screens/forgot_password_screen.dart';
import 'package:connect_org/ui/sign_up_screen/sign_up_screen.dart';
import 'package:connect_org/utils/validators.dart';
import 'package:connect_org/widgets/password_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sizer/sizer.dart';

import '../../utils/constants.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<AuthController>();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () => kConfirmDialogue(
        context,
        titleText: "Are you sure?",
        content: Text(
          "Press confirm to exit.",
          style: theme.textTheme.bodyText2,
        ),
      ),
      child: Scaffold(
        body: Obx(() {
          return ModalProgressHUD(
            inAsyncCall: controller.isBusy.value,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: kDefaultPadding,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          Assets.imagesLoginScreenIllustration,
                          width: double.maxFinite,
                          height: 35.h,
                        ),
                        Text(
                          "Login",
                          style: theme.textTheme.headline4,
                        ),
                        kDefaultSpaceVertical,
                        TextFormField(
                          onChanged: (value) {
                            controller.email.value = value;
                          },
                          validator: Validators.emailValidator,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          validator: (value) =>
                              value != null && value.length > 5
                                  ? null
                                  : "Password too short",
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        kDefaultSpaceVerticalHalf,
                        if (controller.errorString.isNotEmpty)
                          Text(
                            "Error: ${controller.errorString.value}",
                            style: theme.textTheme.caption?.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        TextButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            _formKey.currentState!.reset();
                            controller.clearVariables();
                            Get.to(() => ForgotPasswordScreen());
                          },
                          child: Text(
                            "Forgot your password?",
                            style: theme.textTheme.bodyText1
                                ?.copyWith(color: Colors.blue),
                          ),
                        ),
                        kDefaultSpaceVertical,
                        ElevatedButton(
                          onPressed: () {
                            controller.errorString.value = "";
                            if (_formKey.currentState!.validate()) {
                              controller.signIn();
                            }
                          },
                          child: const Text("Log In"),
                        ),
                        // kDefaultSpaceVertical,
                        // Align(
                        //   alignment: Alignment.center,
                        //   child: Text(
                        //     "or sign in with...",
                        //     style: theme.textTheme.caption,
                        //   ),
                        // ),
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
                        kDefaultSpaceVertical,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "New to ConnectOrg? ",
                              style: theme.textTheme.bodyText1,
                            ),
                            TextButton(
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                _formKey.currentState!.reset();
                                controller.clearVariables();
                                Get.to(() => SignUpScreen());
                              },
                              child: Text(
                                "Register",
                                style: theme.textTheme.headline6?.copyWith(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  ElevatedButton buildSocialSignInButton(
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
