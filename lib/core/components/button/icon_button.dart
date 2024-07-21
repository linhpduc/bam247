import 'package:batt247/core/resource/colors.dart';
import 'package:flutter/material.dart';

class IconButtonComp extends StatelessWidget {
  final IconData? icon;
  final Function()? onPress;
  final Color? splashColor, highLightColor, color;
  final double? splashRadius, size;

  const IconButtonComp({
    required this.icon,
    required this.onPress,
    Key? key,
    this.splashColor,
    this.splashRadius = 24,
    this.color,
    this.size,
    this.highLightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return SizedBox(
      height: 38,
      child: IconButton(
        onPressed: onPress,
        icon: Icon(
          icon,
          size: size,
          color: color,
        ),
        splashColor: splashColor,
        highlightColor: highLightColor,
        splashRadius: splashRadius,
        style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(
                        color: ColorResource.second_primary)))),
      ),
    );
  }
}
