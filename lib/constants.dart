import 'package:flutter/material.dart';

const double narrowScreenWidthThreshold = 450;
const double mediumWidthBreakpoint = 768;
const double largeWidthBreakpoint = 1280;
const double transitionLength = 500;

enum ColorSeed {
  baseColor('Base blue', Color(0xff007AF5)),
  green('Green', Color(0xff22BE70)),
  orange('Orange', Color(0xffFFB129)),;

  const ColorSeed(this.label, this.color);
  final String label;
  final Color color;
}

enum ScreenSelected {
  home(0),
  sources(1),
  records(2),
  helps(3);

  const ScreenSelected(this.value);
  final int value;
}

enum SourceTypeModel {
  machine("machine", "Attendance Machines");

  const SourceTypeModel(this.code, this.name);
  final String code;
  final String name;
}

enum MachineBrandname {
  unknown("unknown", "---Select---"),
  zkteco("zkteco", "ZKTeco"),
  ronaldjack("ronaldjack", "Ronald Jack");

  const MachineBrandname(this.value, this.name);
  final String value;
  final String name;
}
