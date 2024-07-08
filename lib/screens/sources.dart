import 'package:flutter/material.dart';

const Widget divider = SizedBox(height: 20);

enum DatasourceType {
  machine("Attendance Machine", "machine"),;

  const DatasourceType(this.label, this.code);
  final String label;
  final String code;
}

class Datasource {
  Datasource(this.sourceType, this.sourceProvider, this.displayName, this.endpoint);

  final String sourceType;
  final String sourceProvider;
  final String displayName;
  final String endpoint;
}

List<Datasource> _datasources = [
  Datasource(DatasourceType.machine.label, "ZKTeco", "Văn phòng HN", "192.168.3.101:4370"),
  Datasource(DatasourceType.machine.label, "Ronald Jack", "Van phong HCM", "192.168.4.101:4370"),
  Datasource(DatasourceType.machine.label, "Ronald Jack", "Van phong DN", "192.168.5.101:4370"),
  Datasource(DatasourceType.machine.label, "Ronald Jack", "Van phong HP", "192.168.6.101:4370"),
  Datasource(DatasourceType.machine.label, "ZKTeco", "Van phong QN", "192.168.7.101:4370"),
];

class DatasourceScreen extends StatefulWidget {
  const DatasourceScreen({super.key});

  @override
  State<DatasourceScreen> createState() => _DatasourceState();
}

class _DatasourceState extends State<DatasourceScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Card(
              color: Theme.of(context).colorScheme.onSecondary,
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
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                              labelText: 'Search',
                              hintText: 'type a display name',
                            ),
                          ),
                        ),
                        FilledButton.tonalIcon(
                          onPressed: () {},
                          label: const Text('New source'),
                          icon: const Icon(Icons.add),
                        ),
                        FloatingActionButton(
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
