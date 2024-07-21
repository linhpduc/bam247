import 'package:batt247/core/resource/colors.dart';
import 'package:flutter/material.dart';

class ButtonComponent extends StatelessWidget {
  final String? title;
  final Widget? icon;
  final Function() onPressed;
  final Function()? onLongPressed;
  final TextStyle? style;
  final double? borderRadius;
  final double? widthValue;
  final double? heightValue;
  final ButtonStyle? buttonStyle;
  final bool enable = true;

  const ButtonComponent({
    Key? key,
    this.title,
    this.style,
    this.widthValue,
    this.onLongPressed,
    this.heightValue,
    required this.onPressed,
    this.borderRadius,
    this.buttonStyle,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widthValue,
      height: heightValue,
      child: TextButton(
        onLongPress: onLongPressed,
        onPressed: onPressed,
        style: ButtonStyle(
          splashFactory: enable ? null : NoSplash.splashFactory,
          padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(vertical: 16, horizontal: 15)),
          backgroundColor: WidgetStateProperty.all(
              (ColorResource.button_primary).withOpacity(!enable ? 0.5 : 1)),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          )),
        ),
        child: Row(
          children: [
            if (icon != null) icon!,
            if (icon != null) const SizedBox(width: 5),
            Text(
              title ?? '',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
