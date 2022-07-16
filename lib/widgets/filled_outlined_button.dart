import 'package:flutter/material.dart';

class FilledOutlineButton extends StatelessWidget {
  const FilledOutlineButton({
    Key? key,
    this.isFilled = true,
    required this.onPressed,
    this.text,
    this.child,
  })  : assert(text != null || child != null),
        super(key: key);

  final bool isFilled;
  final VoidCallback onPressed;
  final String? text;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return MaterialButton(
      elevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide.none,
      ),
      color: isFilled ? primary : Colors.transparent,
      onPressed: onPressed,
      child: child ??
          Text(
            text!,
            style: TextStyle(
              color: isFilled ? Colors.white : primary,
              fontSize: 12,
            ),
          ),
    );
  }
}
