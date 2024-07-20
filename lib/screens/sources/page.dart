import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// implementation
import 'package:batt247/core/resource/colors.dart';
import 'package:batt247/screens/sources/tabs/data_sources.dart';
import 'package:batt247/screens/sources/tabs/checkin_histories.dart';
import 'package:batt247/components.dart';
import 'package:batt247/models/sources.dart';
import 'package:batt247/utils/database.dart';

var uuid = const Uuid();

enum ActionMenu { resync, edit, remove }

class SourceScreen extends StatefulWidget {
  const SourceScreen({super.key, required this.dbConn});
  final AppDB dbConn;

  @override
  State<SourceScreen> createState() => _SourceScreenState();
}

class _SourceScreenState extends State<SourceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<SourceModel> sources = [];
  List<SourceModel> filteredSources = [];
  String filterName = '';

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    refreshSource();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void filterSourceByName(String name) {
    setState(() {
      filterName = name;
      filteredSources = sources
          .where((source) =>
              source.name.toLowerCase().contains(filterName.toLowerCase()))
          .toList();
    });
  }

  void refreshSource() {
    setState(() {
      widget.dbConn.readAllSource().then((items) {
        setState(() {
          filteredSources = items;
          sources = items;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> myTabs = <Widget>[
      Container(
        width: 200,
        child: Tab(text: AppLocalizations.of(context)!.data_connect_sources),
      ),
      Container(
        width: 200,
        child: Tab(text: AppLocalizations.of(context)!.checkin_histories),
      ),
    ];

    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: ColorResource.primary, // Màu của đường viền
                        width: 1.5, // Độ rộng của đường viền
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 500,
                        child: TabBar(
                          controller: _tabController,
                          tabs: myTabs,
                          mouseCursor: MouseCursor.defer,
                          dividerColor: Colors.transparent,
                        ),
                      )
                    ],
                  ),
                ),
                divider,
                Expanded(
                 child: TabBarView(
                    controller: _tabController,
                    children: [
                      DataSourcesTab(),
                      CheckInHistoriesTab(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

