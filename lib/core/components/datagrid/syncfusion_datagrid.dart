import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class SyncfusionDataGrid extends StatefulWidget {
  final List<GridColumn> columns;
  final DataGridSource sources;
  final DataGridController dataGridController;
  final bool isLoading;
  final void Function(DataGridCellTapDetails details)? onCellTap;

  SyncfusionDataGrid(
      {Key? key,
      required this.columns,
      required this.sources,
      required this.dataGridController,
      required this.isLoading,
      this.onCellTap,
      })
      : super(key: key);

  @override
  _SyncfusionDataGridState createState() => _SyncfusionDataGridState();
}

class _SyncfusionDataGridState extends State<SyncfusionDataGrid> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SfDataGrid(
            controller: widget.dataGridController,
            source: widget.sources,
            columnWidthMode: ColumnWidthMode.fill,
            showCheckboxColumn: true,
            selectionMode: SelectionMode.multiple,
            columns: widget.columns,
            onCellTap: widget.onCellTap,
          ),
        ),
        SfDataPagerTheme(
          data: SfDataPagerThemeData(
            itemBorderWidth: 0.5,
            itemBorderRadius: BorderRadius.circular(10),
            selectedItemColor: Colors.indigo.shade500,
            selectedItemTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          child: SfDataPager(
            delegate: widget.sources,
            firstPageItemVisible: false,
            lastPageItemVisible: false,
            pageCount: 1,
            itemPadding: const EdgeInsets.all(10),
            navigationItemWidth: 50,
            direction: Axis.horizontal,
            onPageNavigationStart: (int pageIndex) {
              //You can do your customization
            },
            onPageNavigationEnd: (int pageIndex) {
              //You can do your customization
            },
            availableRowsPerPage: const [10, 20, 30],
            onRowsPerPageChanged: (int? rowsPerPage) {},
          ),
        ),
      ],
    );
  }
}
