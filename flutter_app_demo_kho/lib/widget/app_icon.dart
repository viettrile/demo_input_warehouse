import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_demo_kho/configs/config.dart';

class CustomTextWithIcon extends StatelessWidget {
  final String text;
  final String iconPath;
  final TextStyle? style;
  final Color? iconColor;
  final double iconSize;

  const CustomTextWithIcon({
    required this.text,
    required this.iconPath,
    this.style,
    this.iconColor,
    this.iconSize = 20.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Image.asset(
          iconPath,
          color: iconColor ?? lightColorScheme.scrim,
          width: iconSize,
          height: iconSize,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: style ??
                TextStyle(
                  color: lightColorScheme.onSurface,
                  fontSize: 16,
                  // fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
          ),
        ),
      ],
    );
  }
}
