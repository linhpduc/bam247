import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class SvgComp extends StatelessWidget {
  final double? width;
  final double? height;
  final String url;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final BoxFit? boxFit;
  final Color? color;

  const SvgComp({
    Key? key,
    required this.url,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
    this.boxFit,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(0),
      child: Container(
        width: width,
        height: width,
        padding: padding,
        child: SvgPicture.asset(
          url,
          color: color,
          fit: boxFit ?? BoxFit.contain,
        ),
      ),
    );
  }
}
