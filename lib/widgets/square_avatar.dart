import 'package:flutter/material.dart';

class SquareAvatar extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final ImageProvider? backgroundImage;
  final ColorFilter? colorFilter;

  const SquareAvatar({
    Key? key,
    this.width = 40,
    this.height = 40,
    this.backgroundColor = Colors.blue,
    this.backgroundImage,
    this.colorFilter,
  })  : assert(backgroundColor != null || backgroundImage != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor,
        image: backgroundImage != null
            ? DecorationImage(
                image: backgroundImage!,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                colorFilter: colorFilter,
              )
            : null,
      ),
    );
  }
}
