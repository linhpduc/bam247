import 'package:batt247/components.dart';
import 'package:batt247/core/components/dropdown/dropdown_menu.dart';
import 'package:batt247/core/components/index.dart';
import 'package:batt247/main.dart';
import 'package:batt247/models/sources.dart';
import 'package:batt247/screens/sources/page_controller.dart';
import 'package:batt247/utils/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DataSourcesTab extends StatefulWidget {
  final AppDB dbConn;
  const DataSourcesTab({super.key, required this.dbConn});

  @override
  State<DataSourcesTab> createState() => _DataSourcesTabState();
}

class _DataSourcesTabState extends State<DataSourcesTab> {
  final PageSourceController _controller = PageSourceController();
  final DataGridController dataGridController = DataGridController();
  List<SourceModel> data = [];
  late DataSource sources = DataSource(sources: [], originData: []);
  bool isLoading = true;
  List<DataGridRow> rows = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      data = await widget.dbConn.readAllSource();
      setState(() {
        sources = mapSourcesToDataSource(data);
      });
    } catch (e) {
      // Handle errors
      print('Error loading data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> onFilter(String keyword) async {
    print('search: ${keyword}');
    setState(() {
      isLoading = true;
    });

    try {
      List<SourceModel> currentData = [];
      if (keyword.isEmpty) {
        currentData = data;
      } else {
        currentData = data
            .where((item) =>
                item.name.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      }
      setState(() {
        sources = mapSourcesToDataSource(currentData);
      });
    } catch (e) {
      // Handle errors
      print('Error filter data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  DataSource mapSourcesToDataSource(List<SourceModel> data) {
    final dataRows = data.map<DataGridRow>((item) {
      return DataGridRow(cells: [
        DataGridCell(columnName: item.name, value: item.name),
        DataGridCell(columnName: item.sourceId, value: item.typeCode),
        DataGridCell(columnName: item.sourceId, value: item.sourceId),
        DataGridCell(columnName: 'status', value: item.name == '1'),
        const DataGridCell(columnName: 'actions', value: ''),
      ]);
    }).toList();
    return DataSource(
      sources: dataRows,
      originData: data,
      onEdit: (id) {},
      onRemove: (id) {},
      onResync: (id) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.data_sources,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          divider,
          Row(
            children: <Widget>[
              SizedBox(
                width: 300,
                child: SearchTextField(
                  callbackSearch: onFilter,
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 230,
                child: DropdownMenuComp(
                  placeholder: "Select an option",
                  items: _controller.options,
                  selectedValue: _controller.selectedValue,
                ),
              ),
              Expanded(child: Container()),
              ButtonComponent(
                  onPressed: () => _controller
                          .dialogNewSource(context,
                              onCreate: _controller.onCreate)
                          .then((_) {
                        _loadData();
                      }),
                  title: AppLocalizations.of(context)!.add_data_source,
                  icon: const Icon(Icons.add, color: Colors.white, size: 16)),
              const SizedBox(width: 5),
              IconButtonComp(
                icon: Icons.settings_outlined,
                onPress: () => null,
                color: Colors.black,
              ),
            ],
          ),
          divider,
          Expanded(
            child: SyncfusionDataGrid(
              columns: columns,
              dataGridController: dataGridController,
              sources: sources,
              isLoading: isLoading,
            ),
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }
}

final columns = <GridColumn>[
  GridColumn(
    columnName: 'name',
    width: 400,
    label: Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Text(
        tr().name,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  ),
  GridColumn(
    columnName: 'source',
    label: Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Text(
        tr().data_source,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  ),
  GridColumn(
    columnName: 'ipAddress',
    label: Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Text(
        tr().ip_address,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  ),
  GridColumn(
    columnName: 'status',
    label: Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Text(
        tr().status,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  ),
  GridColumn(
    columnName: 'actions',
    width: 100,
    label: Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: const Text(
        "",
        overflow: TextOverflow.ellipsis,
      ),
    ),
  ),
];

enum ActionMenu { resync, edit, delete }

class DataSource extends DataGridSource {
  DataSource({
    required List<DataGridRow> sources,
    this.onEdit,
    this.onRemove,
    this.onResync,
    required this.originData,
  }) {
    _sources = sources;
  }
  void Function(SourceModel source)? onEdit;
  void Function(SourceModel source)? onRemove;
  void Function(SourceModel source)? onResync;
  List<SourceModel> originData = [];
  List<DataGridRow> _sources = [];

  List<Map<String, dynamic>> actions = [
    {
      'action': ActionMenu.resync,
      'label': tr().resync,
      'icon': Icons.sync,
      'color': Colors.white,
    },
    {
      'action': ActionMenu.edit,
      'label': tr().edit,
      'icon': Icons.edit,
      'color': Colors.white,
    },
    {
      'action': ActionMenu.delete,
      'label': tr().delete,
      'icon': Icons.delete,
      'color': Colors.redAccent,
    },
  ];

  @override
  List<DataGridRow> get rows => _sources;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      if (e.columnName == 'actions') {
        return Center(
          child: PopupMenuButton<ActionMenu>(
            position: PopupMenuPosition.under,
            onSelected: (value) {
              // Handle the selected action here
              if (value == ActionMenu.resync) {
                print('resyncing...');
              } else if (value == ActionMenu.edit) {
                print('editing...');
              } else if (value == ActionMenu.delete) {
                print('deleting...');
              }
            },
            itemBuilder: (BuildContext context) {
              return actions.map((Map<String, dynamic> choice) {
                return PopupMenuItem<ActionMenu>(
                  value: choice["action"] as ActionMenu,
                  child: ListTile(
                    iconColor: choice["color"],
                    textColor: choice["color"],
                    leading: Icon(choice["icon"]),
                    title: Text(choice["label"]),
                  ),
                );
              }).toList();
            },
            icon: const Icon(Icons.more_vert),
          ),
        );
      } else if (e.columnName == 'status') {
        return Center(
          child: BadgeStatus(isConnected: e.value),
        );
      } else {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(e.value.toString()),
        );
      }
    }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) {
    // TODO: implement handlePageChange
    return super.handlePageChange(oldPageIndex, newPageIndex);
  }
}
