import 'package:flutter/material.dart';

class BulletListText extends StatelessWidget {
  const BulletListText({
    Key? key,
    required this.texts,
  }) : super(key: key);

  final List<String> texts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: texts
          .map((e) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "• ",
                    textAlign: TextAlign.start,
                    style: theme.textTheme.headline6?.copyWith(
                      fontSize: 24,
                      height: 0.9,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "$e\n",
                      style: theme.textTheme.bodyText2,
                    ),
                  ),
                ],
              ))
          .toList(),
    );
  }
}
