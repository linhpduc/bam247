import 'package:flutter/material.dart';
import '../models/sources.dart';

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
          return const SingleChildScrollView(
            child: LogSourceDT(),
          );
        },
      ),
    );
  }
}

class LogSource extends DataTableSource {
  List<Sources>? data;
  LogSource({required this.data});

  @override
  int get rowCount => data?.length ?? 0;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow? getRow(int index) {
    return index <= rowCount
    ? DataRow(
      cells: [
        DataCell(Text(data![index].name)),
        DataCell(Text(data![index].description ?? "")),
        const DataCell(Text("status")),
        const DataCell(Text("d")),
      ],
      onSelectChanged: (newValue) {
        print(newValue);
      }
      )
    : null;
  }
}

class LogSourceDT extends StatefulWidget {
  const LogSourceDT({super.key});

  @override
  State<LogSourceDT> createState() => _LogSourceDTState();
}

class _LogSourceDTState extends State<LogSourceDT> {
  List<Sources>? filterSources;
  int _pageSize = 10;

  @override
  void initState() {
    filterSources = mySources;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      availableRowsPerPage: const [5, 10, 25, 50],
      rowsPerPage: _pageSize,
      onRowsPerPageChanged: (value) {
        setState(() {
          _pageSize = value!;
        });
      },
      showCheckboxColumn: true,
      header: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black45,
          ),
          borderRadius: BorderRadius.circular(8)
        ),
        child: TextField(
          controller: TextEditingController(),
          decoration: const InputDecoration(hintText: "Enter something to filter"),
          onChanged: (value) {
            setState(() {
              mySources = filterSources!.where((row) => row.name.contains(value)).toList();
            });
          },
        ),
      ),
      columns: const <DataColumn>[
        DataColumn(
          label: Text('Name'),
        ),
        DataColumn(
          label: Text('Desciption'),
        ),
        DataColumn(
          label: Text('Status'),
        ),
        DataColumn(
          label: Text('#'),
        ),
      ],
      source: LogSource(data: mySources),
    );
  }
}
