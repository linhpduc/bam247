import 'package:batt247/main.dart';
import 'package:flutter/material.dart';

class ToastMessage {
  static void show(Text text, BuildContext? context) {

    context ??= globalContext;
    ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        content: text,
        width: 400.0,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
