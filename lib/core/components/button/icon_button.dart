import 'package:batt247/core/resource/colors.dart';
import 'package:flutter/material.dart';

class IconButtonComp extends StatelessWidget {
  final IconData? icon;
  final Function()? onPress;
  final Color? splashColor, highLightColor, color, borderColor;
  final double? splashRadius, size;

  const IconButtonComp({
    required this.icon,
    required this.onPress,
    Key? key,
    this.splashColor,
    this.splashRadius = 24,
    this.color,
    this.borderColor,
    this.size,
    this.highLightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: IconButton(
        onPressed: onPress,
        icon: Icon(icon,size: size,color: color),
        splashColor: splashColor,
        highlightColor: highLightColor,
        splashRadius: splashRadius,
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: borderColor ?? ColorResource.second_primary),
            ),
          ),
        ),
      ),
    );
  }
}
