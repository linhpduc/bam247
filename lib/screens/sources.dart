import 'package:batt247/constants.dart';
import 'package:batt247/models/machines.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

import '../components.dart';
import '../models/sources.dart';
import '../utils/database.dart';

var uuid = const Uuid();

class SourceScreen extends StatefulWidget {
  const SourceScreen({super.key});

  @override
  State<SourceScreen> createState() => _SourceScreenState();
}

class _SourceScreenState extends State<SourceScreen> {
  Batt247Database dbConn = Batt247Database.instance;

  List<SourceModel> sources = [];
  String filterName = '';
  List<SourceModel> filteredSources = [];

  @override
  void initState() {
    refreshSource();
    // filteredSources = sources;
    super.initState();
  }

  @override
  void dispose() {
    dbConn.close();
    super.dispose();
  }

  void filterSourceByName(String name) { 
    setState(() { 
      filterName = name;
      filteredSources = sources 
          .where((source) => source.name.contains(filterName)) 
          .toList(); 
    }); 
  }

  void refreshSource() {
    setState(() {
      dbConn.readAllSource().then((items) {
        setState(() {
          filteredSources = items;
          sources = items;
        });
      });
    });
  }

  Future<void> _dialogNewSource(BuildContext context) {
    SourceModel newSource = SourceModel(
      sourceId: uuid.v7(),
      typeCode: SourceTypeModel.machine,
      name: "",
      description: "",
      intervalInSeconds: 600,
      realtimeEnabled: 0,
      clientEndpoint: "https://checkin.base.vn",
      clientId: "",
      clientSecret: "",
    );
    MachineModel newMachine = MachineModel(
      sourceId: newSource.sourceId, 
      brandname: MachineBrandname.unknown,
      ipAddress: "", 
      tcpPort: 4370,
      realtimeCapturable: 0,
      metadata: "",
    );
    return showDialog(
      context: context, 
      builder: (BuildContext context) {
        var ctrlName = TextEditingController();
        var ctrlEndpoint = TextEditingController();
        var ctrlClientEndpoint = TextEditingController();
        var ctrlClientID = TextEditingController();
        var ctrlClientSecret = TextEditingController();
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          scrollable: true,
          title: const Text("Add a new source"),
          content: Form(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Card.filled(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text("Connection info"),
                          divider,
                          TextFormField(
                            controller: ctrlName,
                            decoration: const InputDecoration(
                              labelText: "Display name*",
                              hintText: 'E.g: Headquarter office',
                              border: OutlineInputBorder(),
                              // isDense: true,
                            ),
                          ),
                          divider,
                          DropdownMenu<String>(
                            initialSelection: newSource.typeCode.code,
                            onSelected: (String? code) {
                              setState(() {
                                newSource.typeCode = SourceTypeModel.values.byName(code!);
                              });
                            },
                            dropdownMenuEntries: List.generate(SourceTypeModel.values.length, (index) {
                              return DropdownMenuEntry<String>(
                                value: SourceTypeModel.values[index].code, 
                                label: SourceTypeModel.values[index].name
                              );
                            }).toList(),
                          ),
                          divider,
                          DropdownMenu<String>(
                            initialSelection: newMachine.brandname?.value,
                            onSelected: (String? value) {
                              setState(() {
                                newMachine.brandname = MachineBrandname.values.byName(value!);
                              });
                            },
                            dropdownMenuEntries: List.generate(MachineBrandname.values.length, (index) {
                              return DropdownMenuEntry<String>(
                                value: MachineBrandname.values[index].value, 
                                label: MachineBrandname.values[index].name
                              );
                            }).toList(),
                          ),
                          divider,
                          TextFormField(
                            controller: ctrlEndpoint,
                            decoration: const InputDecoration(
                              labelText: "Connection endpoint*",
                              hintText: 'E.g: 192.168.1.1:4370',
                              border: OutlineInputBorder(),
                              // isDense: true,
                            ),
                          ),
                          divider,
                          Row(
                            children: [
                              FilledButton.tonal(
                                onPressed: (){}, 
                                child: const Text("Test connection")
                              ),
                              const Expanded(
                                child: Icon(Icons.done),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card.filled(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text("Base Checkin configurations"),
                          divider,
                          TextFormField(
                            controller: ctrlClientEndpoint,
                            decoration: const InputDecoration(
                              prefix: Text("https://"),
                              labelText: "Client Endpoint",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          divider,
                          TextFormField(
                            controller: ctrlClientID,
                            decoration: const InputDecoration(
                              labelText: "Client ID",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          divider,
                          TextFormField(
                            controller: ctrlClientSecret,
                            decoration: const InputDecoration(
                              labelText: "Client Secret",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          divider,
                          Row(
                            children: [
                              FilledButton.tonal(
                                onPressed: (){}, 
                                child: const Text("Sanity check")
                              ),
                              const Expanded(
                                child: Icon(Icons.done),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FilledButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Create'),
              onPressed: () {
                newSource.name = ctrlName.text;
                switch (newSource.typeCode) {
                  case SourceTypeModel.machine:
                    dbConn.createSource(newSource.toMap());
                    List<String> tupleEndpoint = ctrlEndpoint.text.split(":");
                    newMachine.ipAddress = tupleEndpoint[0];
                    newMachine.tcpPort = tupleEndpoint.length > 1 ? int.parse(tupleEndpoint[1]) : 4370;
                    dbConn.createMachine(newMachine.toMap());
                    break;
                  default:
                }
                refreshSource();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Create successfully"), width: 400.0, behavior: SnackBarBehavior.floating,));
              },
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  'Sources',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                divider,
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(labelText: 'Filter by source name'),
                        onChanged: filterSourceByName,
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () async => await _dialogNewSource(context),
                      icon: const Icon(Icons.add),
                      label: const Text('New source'),
                    )
                  ],
                ),
                divider,
                Card.filled(
                  color: Theme.of(context).colorScheme.onSecondary,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: filteredSources.isNotEmpty 
                      ? ListView.separated(
                        shrinkWrap: true,
                        itemCount: filteredSources.length,
                        itemBuilder: (BuildContext context, int index) {
                          return SourceItem(info: filteredSources[index]);
                        },
                        separatorBuilder: (BuildContext context, int index) => const Divider(),
                      )
                      : const ListTile(
                        titleAlignment: ListTileTitleAlignment.center,
                        leading: Icon(Icons.sentiment_very_dissatisfied),
                        title: Text("No record to display."),
                      ),
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

class SourceItem extends StatefulWidget {
  const SourceItem({super.key, required this.info});
  final SourceModel info;

  @override
  State<SourceItem> createState() => _SourceItemState();
}

class _SourceItemState extends State<SourceItem> {
  ListTileTitleAlignment? titleAlignment;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      titleAlignment: titleAlignment,
      leading: const Icon(Icons.devices_fold_outlined),
      title: Text(widget.info.name),
      subtitle: Text(join(widget.info.description??"", widget.info.sourceId, widget.info.clientEndpoint??"", widget.info.clientId??"", widget.info.clientSecret??"", widget.info.createdTime?.toString())),
      trailing: PopupMenuButton<ListTileTitleAlignment>(
        onSelected: (ListTileTitleAlignment? value) {
          setState(() {
            titleAlignment = value;
          });
        },
        itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<ListTileTitleAlignment>>[
          const PopupMenuItem<ListTileTitleAlignment>(
            value: ListTileTitleAlignment.top,
            child: Text('Sync'),
          ),
          const PopupMenuItem<ListTileTitleAlignment>(
            value: ListTileTitleAlignment.center,
            child: Text('Edit'),
          ),
          const PopupMenuItem<ListTileTitleAlignment>(
            value: ListTileTitleAlignment.bottom,
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }
}
