import 'package:flutter/material.dart';

enum ButtonType { normal, outline, text }

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool loading;
  final bool disabled;
  final ButtonType type;
  final Color color;
  final Widget? icon;
  final MainAxisSize mainAxisSize;

  const AppButton(
    this.text, {
    Key? key,
    required this.onPressed,
    this.icon,
    this.color = const Color(0XFFFF651D),
    this.loading = false,
    this.disabled = false,
    this.type = ButtonType.normal,
    this.mainAxisSize = MainAxisSize.max,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buildLoading(Color color) {
      if (!loading) return Container();
      return Row(
        children: [
          const SizedBox(width: 8),
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: color,
            ),
          )
        ],
      );
    }

    switch (type) {
      case ButtonType.outline:
        if (icon != null) {
          return OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: color),
              minimumSize: const Size(64, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: disabled ? null : onPressed,
            icon: icon!,
            label: Row(
              mainAxisSize: mainAxisSize,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                        letterSpacing: 1.25,
                      ),
                ),
                buildLoading(color)
              ],
            ),
          );
        }
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: color),
            minimumSize: const Size(64, 44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: disabled ? null : onPressed,
          child: Row(
            mainAxisSize: mainAxisSize,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: color,
                      letterSpacing: 1.25,
                    ),
              ),
              buildLoading(color)
            ],
          ),
        );

      case ButtonType.text:
        if (icon != null) {
          return TextButton.icon(
            onPressed: disabled ? null : onPressed,
            icon: icon!,
            label: Row(
              mainAxisSize: mainAxisSize,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                        letterSpacing: 1.25,
                      ),
                ),
                buildLoading(Theme.of(context).primaryColor)
              ],
            ),
          );
        }
        return TextButton(
          onPressed: disabled ? null : onPressed,
          child: Row(
            mainAxisSize: mainAxisSize,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).primaryColor,
                      letterSpacing: 1.25,
                    ),
              ),
              buildLoading(Theme.of(context).primaryColor)
            ],
          ),
        );
      default:
        if (icon != null) {
          return ElevatedButton.icon(
            onPressed: disabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(64, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: icon!,
            label: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        letterSpacing: 1.25,
                      ),
                ),
                buildLoading(Colors.white)
              ],
            ),
          );
        }
        return ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(64, 44),
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: mainAxisSize,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(letterSpacing: 1.25, color: Colors.white),
              ),
              buildLoading(Colors.white)
            ],
          ),
        );
    }
  }
}
