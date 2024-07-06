import 'package:flutter/material.dart';

const Widget divider = SizedBox(height: 20);

enum DatasourceType {
  machine("Attendance Machine", "machine"),
  ;

  const DatasourceType(this.label, this.code);
  final String label;
  final String code;
}

class Datasource {
  Datasource(
      this.sourceType, this.sourceProvider, this.displayName, this.endpoint);

  final String sourceType;
  final String sourceProvider;
  final String displayName;
  final String endpoint;
}

List<Datasource> _datasources = [
  Datasource(DatasourceType.machine.label, "ZKTeco", "Văn phòng HN",
      "192.168.3.101:4370"),
  Datasource(DatasourceType.machine.label, "Ronald Jack", "Van phong HCM",
      "192.168.4.101:4370"),
  Datasource(DatasourceType.machine.label, "Ronald Jack", "Van phong DN",
      "192.168.5.101:4370"),
  Datasource(DatasourceType.machine.label, "Ronald Jack", "Van phong HP",
      "192.168.6.101:4370"),
  Datasource(DatasourceType.machine.label, "ZKTeco", "Van phong QN",
      "192.168.7.101:4370"),
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
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Log sources',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    divider,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(
                          width: 400,
                          child: TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(),
                              labelText: 'Search',
                              hintText: 'type a display name',
                            ),
                          ),
                        ),
                        FilledButton.tonalIcon(
                          onPressed: () {},
                          label: const Text('Icon'),
                          icon: const Icon(Icons.add),
                        ),
                        FloatingActionButton.small(
                          foregroundColor: Theme.of(context).colorScheme.primary,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          onPressed: () {},
                          tooltip: 'Small',
                          child: const Icon(Icons.settings),
                        ),
                      ],
                    ),
                    divider,
                    DataTable(columns: _createColumns(), rows: _createRows()),
                    // schemeView(lightTheme),
                    // schemeView(darkTheme),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

List<DataColumn> _createColumns() {
  return [
    const DataColumn(label: Text('Name')),
    const DataColumn(label: Text('Source Type')),
    const DataColumn(label: Text('Endpoint')),
    const DataColumn(label: Text('Info')),
  ];
}

List<DataRow> _createRows() {
  return _datasources
      .map((source) => DataRow(cells: [
            DataCell(Text(source.displayName)),
            DataCell(Text(source.sourceType)),
            DataCell(Text(source.endpoint)),
            const DataCell(Text('...')),
          ]))
      .toList();
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
