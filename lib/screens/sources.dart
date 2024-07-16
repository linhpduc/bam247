import 'package:batt247/constants.dart';
import 'package:batt247/models/machines.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../components.dart';
import '../models/sources.dart';
import '../utils/database.dart';

var uuid = const Uuid();
enum ActionMenu { resync, edit, remove }

class SourceScreen extends StatefulWidget {
  const SourceScreen({super.key, required this.dbConn});
  final Batt247Database dbConn;

  @override
  State<SourceScreen> createState() => _SourceScreenState();
}

class _SourceScreenState extends State<SourceScreen> {

  List<SourceModel> sources = [];
  String filterName = '';
  List<SourceModel> filteredSources = [];

  @override
  void initState() {
    refreshSource();
    // filteredSources = sources;
    super.initState();
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
      widget.dbConn.readAllSource().then((items) {
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
      clientEndpoint: "",
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
        var ctrlDescription = TextEditingController();
        var ctrlTCPConnection = TextEditingController();
        var ctrlClientEndpoint = TextEditingController();
        var ctrlClientID = TextEditingController();
        var ctrlClientSecret = TextEditingController();
        var connStatus = true;
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
                          const Text("Connection properties"),
                          divider,
                          TextFormField(
                            controller: ctrlName,
                            decoration: const InputDecoration(
                              labelText: "Display name*",
                              hintText: 'E.g: Headquarter office',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          divider,
                          TextField(
                            controller: ctrlDescription,
                            maxLines: 3,
                            maxLength: 128,
                            decoration: const InputDecoration(
                              labelText: "Description",
                              hintText: 'Enter the description about the source to collect attendance records.',
                              border: OutlineInputBorder(),
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
                            controller: ctrlTCPConnection,
                            decoration: const InputDecoration(
                              labelText: "Machine's IP address*",
                              hintText: 'E.g: 192.168.1.1:4370',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          divider,
                          Row(
                            children: [
                              FilledButton.tonal(
                                onPressed: (){
                                  setState(() {
                                    connStatus = true;
                                  });
                                }, 
                                child: const Text("Test connection")
                              ),
                              Expanded(
                                child: connStatus ? const Icon(Icons.done, color: Colors.green,) : const Icon(Icons.error_outline, color: Colors.red,),
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
                          const Text("Synchronizing configurations (Base Checkin)"),
                          divider,
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: ctrlClientEndpoint,
                              decoration: const InputDecoration(
                                prefix: Text("https://"),
                                labelText: "Client Endpoint",
                                border: OutlineInputBorder(),
                              ),
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
                            obscureText: true,
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
                newSource.description = ctrlDescription.text;
                newSource.clientEndpoint = ctrlClientEndpoint.text;
                newSource.clientId = ctrlClientID.text;
                newSource.clientSecret = ctrlClientSecret.text;
                widget.dbConn.createSource(newSource.toMap());
                switch (newSource.typeCode) {
                  case SourceTypeModel.machine:
                    List<String> tupleEndpoint = ctrlTCPConnection.text.split(":");
                    newMachine.ipAddress = tupleEndpoint[0];
                    newMachine.tcpPort = tupleEndpoint.length > 1 ? int.parse(tupleEndpoint[1]) : 4370;
                    widget.dbConn.createMachine(newMachine.toMap());
                    break;
                  default:
                }
                refreshSource();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Create successfully"),
                  width: 400.0, 
                  behavior: SnackBarBehavior.floating,
                ));
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
                    SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Filter by source name',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: filterSourceByName,
                      ),
                    ),
                    Expanded(child: Container()),
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
                          return SourceItem(
                            info: filteredSources[index], 
                            dbConn: widget.dbConn, 
                            handleUpdateParentWidget: refreshSource,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) => const Divider(),
                      )
                      : const ListTile(
                        titleAlignment: ListTileTitleAlignment.center,
                        leading: Icon(Icons.search_off),
                        title: Text("No sources found."),
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
  const SourceItem({super.key, required this.info, required this.dbConn, required this.handleUpdateParentWidget});
  final SourceModel info;
  final Batt247Database dbConn;
  final void Function() handleUpdateParentWidget;

  @override
  State<SourceItem> createState() => _SourceItemState();
}

class _SourceItemState extends State<SourceItem> {
  bool connStatus = true;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.devices_fold_outlined),
      title: Text(widget.info.name),
      subtitle: Text("${widget.info.description}"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          connStatus 
          ? SizedBox(width: 100, child: TextButton.icon(
            onPressed: (){}, 
            label: const Text("Ok"), 
            icon: const Icon(Icons.check_circle), 
            style: TextButton.styleFrom(
              foregroundColor: Colors.green, 
              backgroundColor: Colors.green[50]
            ),
          ))
          : SizedBox(width: 100, child: TextButton.icon(
            onPressed: (){}, 
            label: const Text("Error"), 
            icon: const Icon(Icons.sync_problem), 
            style: TextButton.styleFrom(
              foregroundColor: Colors.red, 
              backgroundColor: Colors.red[50],
              textStyle: Theme.of(context).textTheme.labelSmall,
            ),
          )),
          const SizedBox(width: 15),
          PopupMenuButton<ActionMenu>(
            tooltip: "Actions",
            color: Theme.of(context).colorScheme.onSecondary,
            onSelected: (ActionMenu? action) {
              switch (action) {
                case ActionMenu.remove:
                  showDialog(
                    context: context, 
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Warning"),
                        content: Text("Do you want to remove ${widget.info.name}?"),
                        actions: [
                          OutlinedButton(onPressed: () => Navigator.pop(context, "Cancel"), autofocus: true, child: const Text("Cancel"),),
                          TextButton(
                            onPressed: () {
                              widget.dbConn.deleteSource(widget.info.sourceId);
                              switch (widget.info.typeCode) {
                                case SourceTypeModel.machine:
                                  widget.dbConn.deleteMachine(widget.info.sourceId);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Removed"), width: 400.0, behavior: SnackBarBehavior.floating,));
                                  break;
                                default:
                              }
                              Navigator.pop(context, "Remove");
                            }, 
                            child: const Text("Remove")),
                        ],
                      );
                    },
                  ).then((_) {
                    widget.handleUpdateParentWidget();
                  });
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<ActionMenu>>[
              PopupMenuItem<ActionMenu>(
                value: ActionMenu.resync,
                child: ListTile(
                  iconColor: Theme.of(context).colorScheme.secondary,
                  textColor: Theme.of(context).colorScheme.secondary,
                  leading: const Icon(Icons.sync,),
                  title: const Text('Resync'),
                ),
              ),
              PopupMenuItem<ActionMenu>(
                value: ActionMenu.edit,
                child: ListTile(
                  iconColor: Theme.of(context).colorScheme.secondary,
                  textColor: Theme.of(context).colorScheme.secondary,
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit'),
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<ActionMenu>(
                value: ActionMenu.remove,
                child: ListTile(
                  iconColor: Theme.of(context).colorScheme.error,
                  textColor: Theme.of(context).colorScheme.error,
                  leading: const Icon(Icons.delete_forever),
                  title: const Text('Remove'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
