import 'package:flutter/material.dart';

class DetailsBox extends StatelessWidget {
  const DetailsBox({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      constraints: const BoxConstraints(minHeight: 100),
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme.textTheme.headline6,
          ),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }
}
