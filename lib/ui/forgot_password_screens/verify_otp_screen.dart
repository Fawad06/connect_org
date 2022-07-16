import 'package:connect_org/ui/logins_screen/login_screen.dart';
import 'package:connect_org/utils/constants.dart';
import 'package:connect_org/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../widgets/my_back_button.dart';
import '../../widgets/password_field.dart';

class VerifyOTPScreen extends StatefulWidget {
  const VerifyOTPScreen({Key? key}) : super(key: key);

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  bool isVerified = false;
  final _formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
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
                  child: isVerified
                      ? Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Change your password",
                                style: theme.textTheme.headline6,
                              ),
                              kDefaultSpaceVerticalHalf,
                              Text(
                                "Enter a new password for account xxxxxxxxxxxxx.",
                                style: theme.textTheme.bodyText2,
                              ),
                              kDefaultSpaceVertical,
                              TextPasswordField(
                                onChanged: (value) {
                                  controller.text = value;
                                },
                                labelText: "Password",
                              ),
                              kDefaultSpaceVertical,
                              TextPasswordField(
                                validator: (value) =>
                                    Validators.confirmPasswordValidator(
                                  controller.text,
                                  value,
                                ),
                                labelText: "Confirm Password",
                              ),
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Verify Yourself",
                              style: theme.textTheme.headline6,
                            ),
                            kDefaultSpaceVerticalHalf,
                            Text(
                              "Please enter the six digit code sent to xxxxxxxxxxxxx into below fields.",
                              style: theme.textTheme.bodyText2,
                            ),
                            kDefaultSpaceVertical,
                            Material(
                              elevation: 4,
                              borderRadius: BorderRadius.circular(20),
                              color: theme.colorScheme.background,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 40,
                                ),
                                child: Center(
                                  child: PinCodeTextField(
                                    appContext: context,
                                    length: 6,
                                    textInputAction: TextInputAction.done,
                                    autoFocus: true,
                                    keyboardType: TextInputType.number,
                                    pinTheme: PinTheme(
                                      selectedFillColor:
                                          theme.scaffoldBackgroundColor,
                                      activeColor: theme.colorScheme.primary,
                                      selectedColor: theme.colorScheme.primary,
                                      inactiveColor:
                                          theme.colorScheme.onBackground,
                                    ),
                                    onChanged: (value) {},
                                    onCompleted: (value) {
                                      setState(() {
                                        isVerified = true;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Did not receive any code?",
                                  style: theme.textTheme.bodyText1,
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Click here.",
                                    style: theme.textTheme.bodyText1?.copyWith(
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
              if (isVerified)
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Fluttertoast.showToast(
                          msg: "Password Updated",
                          backgroundColor: theme.primaryColor,
                          gravity: ToastGravity.BOTTOM,
                          toastLength: Toast.LENGTH_SHORT,
                        );
                        Get.offAll(() => LoginScreen());
                      }
                    },
                    child: const Text("Update Password"))
            ],
          ),
        ),
      ),
    );
  }
}
