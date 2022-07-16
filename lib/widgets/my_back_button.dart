import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  const SquareButton({
    Key? key,
    this.icon,
    required this.onPressed,
    this.child,
  })  : assert(icon != null || child != null),
        super(key: key);
  final IconData? icon;
  final Widget? child;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints.tight(const Size(45, 45)),
      child: Material(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.circular(10),
        elevation: 4,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: child ??
                Icon(
                  icon,
                  size: 24,
                  color: theme.iconTheme.color,
                ),
          ),
        ),
      ),
    );
  }
}
