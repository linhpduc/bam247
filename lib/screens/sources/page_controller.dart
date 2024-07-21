import 'package:batt247/components.dart';
import 'package:batt247/constants.dart';
import 'package:batt247/core/components/dropdown/dropdown_menu.dart';
import 'package:batt247/main.dart';
import 'package:batt247/models/machines.dart';
import 'package:batt247/models/sources.dart';
// import 'package:batt247/screens/sources/page%20copy.dart';
import 'package:batt247/utils/database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PageSourceController {
  String selectedValue = SourceTypeModel.values[0].code;
  List<BaseOptionDropdown> options =
      List.generate(SourceTypeModel.values.length, (index) {
    return BaseOptionDropdown(
        value: SourceTypeModel.values[index].code,
        label: SourceTypeModel.values[index].name,
        data: SourceTypeModel.values[index]);
  }).toList();

  Future<void> dialogNewSource(BuildContext context,
      {required Future<void> Function(
              SourceModel newSource, MachineModel newMachine)
          onCreate}) {
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
          var connStatus = false;
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
                            Text(
                              "Connection properties",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
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
                                hintText:
                                    'Enter the description about the source to collect attendance records.',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            divider,
                            DropdownMenu<String>(
                              initialSelection: newSource.typeCode.code,
                              onSelected: (String? code) {
                                newSource.typeCode =
                                    SourceTypeModel.values.byName(code!);
                              },
                              dropdownMenuEntries: List.generate(
                                  SourceTypeModel.values.length, (index) {
                                return DropdownMenuEntry<String>(
                                    value: SourceTypeModel.values[index].code,
                                    label: SourceTypeModel.values[index].name);
                              }).toList(),
                            ),
                            divider,
                            DropdownMenu<String>(
                              initialSelection: newMachine.brandname?.value,
                              onSelected: (String? value) {
                                newMachine.brandname =
                                    MachineBrandname.values.byName(value!);
                              },
                              dropdownMenuEntries: List.generate(
                                  MachineBrandname.values.length, (index) {
                                return DropdownMenuEntry<String>(
                                    value: MachineBrandname.values[index].value,
                                    label: MachineBrandname.values[index].name);
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
                                OutlinedButton(
                                    onPressed: () async {
                                      print("port checking");
                                      List<String> tupleEndpoint =
                                          ctrlTCPConnection.text.split(":");
                                      String host = tupleEndpoint[0];
                                      int port = tupleEndpoint.length > 1
                                          ? int.parse(tupleEndpoint[1])
                                          : 4370;
                                    },
                                    child: const Text("Test connection")),
                                Expanded(
                                  child: connStatus
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : const Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                        ),
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
                            const Text(
                                "Synchronizing configurations (Base Checkin)"),
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
                                    onPressed: () {},
                                    child: const Text("Sanity check")),
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

                  List<String> tupleEndpoint =
                      ctrlTCPConnection.text.split(":");
                  newMachine.ipAddress = tupleEndpoint[0];
                  newMachine.tcpPort = tupleEndpoint.length > 1
                      ? int.parse(tupleEndpoint[1])
                      : 4370;

                  onCreate(newSource, newMachine);
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
        });
  }

  Future<void> onCreate(
    SourceModel newSource,
    MachineModel newMachine,
  ) {
    if (newSource.typeCode == SourceTypeModel.machine) {
      AppDB.instance.createMachine(newMachine.toMap());
    }
    return AppDB.instance.createSource(newSource.toMap());
  }

  Future<void>? onRemove(SourceModel? source) {
    if (source!.sourceId.isEmpty) return null;
    AppDB.instance.deleteSource(source.sourceId);
    switch (source.typeCode) {
      case SourceTypeModel.machine:
        AppDB.instance.deleteMachine(source.sourceId);
        ScaffoldMessenger.of(globalContext!).showSnackBar(const SnackBar(
          content: Text("Removed"),
          width: 400.0,
          behavior: SnackBarBehavior.floating,
        ));
        break;
      default:
    }
    return null;
  }
}
