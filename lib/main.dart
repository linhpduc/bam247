import 'package:flutter/material.dart';

import 'constants.dart';
import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool useMaterial3 = true;
  ThemeMode themeMode = ThemeMode.system;
  ColorSeed colorSelected = ColorSeed.baseColor;

  bool get useLightMode => switch (themeMode) {
    ThemeMode.system => View.of(context).platformDispatcher.platformBrightness == Brightness.light,
    ThemeMode.light => true,
    ThemeMode.dark => false
  };

  void handleBrightnessChange(bool useLightMode) {
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void handleColorSelect(int value) {
    setState(() {
      colorSelected = ColorSeed.values[value];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Batt247',
      themeMode: themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorSchemeSeed: colorSelected.color,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: colorSelected.color,
      ),
      home: Home(
        useLightMode: useLightMode,
        colorSelected: colorSelected,
        handleBrightnessChange: handleBrightnessChange,
        handleColorSelect: handleColorSelect,
      ),
    );
  }
}
