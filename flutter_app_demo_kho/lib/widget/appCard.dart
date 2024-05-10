import 'package:flutter/material.dart';
import 'package:flutter_app_demo_kho/configs/colors.dart';
import 'package:flutter_app_demo_kho/configs/const.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final bool hasShadow;
  const AppCard({
    super.key,
    required this.child,
    this.color = const Color.fromARGB(255, 250, 233, 243),
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(cornerMedium),
        ),
        color: color,
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: lightColorScheme.primaryContainer,
                  offset: Offset(0, 0),
                  blurRadius: 4,
                )
              ]
            : null,
      ),
      child: child,
    );
  }
}
