import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFFFC9C62);
const Color kSecondaryColor = Color(0xFFFE01FA);
const Color kTertiaryColor = Color(0xfff8fc8d);
const Color kContentColorLightTheme = Color(0xFF1D1D35);
const Color kContentColorDarkTheme = Color(0xFFF5FCF9);
const Color kWarningColor = Color(0xFFF3BB1C);
const Color kErrorColor = Color(0xFFF03738);
const SizedBox kDefaultSpaceVertical = SizedBox(height: 20);
const SizedBox kDefaultSpaceHorizontal = SizedBox(width: 20);
const SizedBox kDefaultSpaceVerticalHalf = SizedBox(height: 10);
const SizedBox kDefaultSpaceHorizontalHalf = SizedBox(width: 10);
const EdgeInsets kDefaultPadding = EdgeInsets.symmetric(
  horizontal: 20,
  vertical: 10,
);
const Duration kDefaultAnimationDuration = Duration(milliseconds: 400);
const kTextShadowGrey = Shadow(
  color: Colors.grey,
  blurRadius: 4,
  offset: Offset(-2, 2),
);
get kContainerShadow => [
      BoxShadow(
        color: Colors.grey.withOpacity(0.7),
        spreadRadius: 0,
        blurRadius: 4,
        offset: const Offset(0, 4),
      ),
    ];
BoxDecoration kContainerCardDecoration(BuildContext context) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Theme.of(context).colorScheme.background,
    boxShadow: kContainerShadow,
  );
}

InputDecoration kTextFormFieldDecoration(
  Color background,
  String? label,
  String? hint,
) {
  return InputDecoration(
    filled: true,
    fillColor: background,
    hintText: hint,
    labelText: label,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

Future<bool> kConfirmDialogue(
  context, {
  required String titleText,
  required Widget content,
  VoidCallback? onConfirm,
}) async {
  bool flag = false;
  await showDialog(
    context: context!,
    useSafeArea: true,
    builder: (context) {
      return SizedBox(
        width: 100,
        child: AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            titleText,
            style: Theme.of(context).textTheme.headline6,
          ),
          content: content,
          actions: [
            SizedBox(
              width: 100,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  flag = true;
                  if (onConfirm != null) onConfirm();
                  Navigator.pop(context);
                },
                child: const Text("Confirm"),
              ),
            ),
            SizedBox(
              width: 100,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
            ),
          ],
        ),
      );
    },
  );
  return flag;
}
