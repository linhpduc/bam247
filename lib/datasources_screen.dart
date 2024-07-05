import 'package:flutter/material.dart';

const Widget divider = SizedBox(height: 10);

enum DatasourceType {
  attendance_machine,
}

class Datasource {
  Datasource(this.source_type, this.source_provider, this.display_name, this.endpoint);

  final String source_type;
  final String source_provider;
  final String display_name;
  final String endpoint;
}

List<Datasource> _datasources = [
  Datasource("attendance_machine", "ZKTeco", "Van phong HN", "192.168.3.101:4370"),
  Datasource("attendance_machine", "Ronald Jack", "Van phong HCM", "192.168.4.101:4370"),
  Datasource("attendance_machine", "Ronald Jack", "Van phong DN", "192.168.5.101:4370"),
  Datasource("attendance_machine", "Ronald Jack", "Van phong HP", "192.168.6.101:4370"),
  Datasource("attendance_machine", "ZKTeco", "Van phong QN", "192.168.7.101:4370"),
];

class DatasourceScreen extends StatefulWidget {
  const DatasourceScreen({super.key});

  @override
  State<DatasourceScreen> createState() => _DatasourceState();
}

class _DatasourceState extends State<DatasourceScreen> {
  List<bool> _selected = [];

  @override
  void initState() {
    super.initState();
    _selected = List<bool>.generate(_datasources.length, (int index) => false);
  }

  @override
  Widget build(BuildContext context) {
    Color selectedColor = Theme.of(context).primaryColor;
    ThemeData lightTheme = ThemeData(
      colorSchemeSeed: selectedColor,
      brightness: Brightness.light,
    );
    ThemeData darkTheme = ThemeData(
      colorSchemeSeed: selectedColor,
      brightness: Brightness.dark,
    );

    Widget schemeView(ThemeData theme) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ColorSchemeView(
          colorScheme: theme.colorScheme,
        ),
      );
    }

    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Log sources',
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                schemeView(lightTheme),
                schemeView(darkTheme),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ColorSchemeView extends StatelessWidget {
  const ColorSchemeView({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ColorGroup(
          children: [
            ColorChip(
              label: 'primaryFixed',
              color: colorScheme.primaryFixed,
              onColor: colorScheme.onPrimaryFixed,
            ),
            ColorChip(
              label: 'onPrimaryFixed',
              color: colorScheme.onPrimaryFixed,
              onColor: colorScheme.primaryFixed,
            ),
            ColorChip(
              label: 'primaryFixedDim',
              color: colorScheme.primaryFixedDim,
              onColor: colorScheme.onPrimaryFixedVariant,
            ),
            ColorChip(
              label: 'onPrimaryFixedVariant',
              color: colorScheme.onPrimaryFixedVariant,
              onColor: colorScheme.primaryFixedDim,
            ),
          ],
        ),
      ],
    );
  }
}

class ColorGroup extends StatelessWidget {
  const ColorGroup({super.key, required this.children});

  final List<ColorChip> children;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: children,
        ),
      ),
    );
  }
}

class ColorChip extends StatelessWidget {
  const ColorChip({
    super.key,
    required this.color,
    required this.label,
    this.onColor,
  });

  final Color color;
  final Color? onColor;
  final String label;

  static Color contrastColor(Color color) =>
      switch (ThemeData.estimateBrightnessForColor(color)) {
        Brightness.dark => Colors.white,
        Brightness.light => Colors.black
      };

  @override
  Widget build(BuildContext context) {
    final Color labelColor = onColor ?? contrastColor(color);

    return Container(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(child: Text(label, style: TextStyle(color: labelColor))),
          ],
        ),
      ),
    );
  }
}
