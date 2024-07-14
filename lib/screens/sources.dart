import 'package:batt247/components.dart';
import 'package:flutter/material.dart';
import '../models/sources.dart';
import '../utils/database.dart';

class SourceScreen extends StatefulWidget {
  const SourceScreen({super.key});

  @override
  State<SourceScreen> createState() => _SourceScreenState();
}

class _SourceScreenState extends State<SourceScreen> {
  Batt247Database db = Batt247Database.instance;

  final List<SourceModel> sources = mySources;
  String filterName = '';
  List<SourceModel> filteredSources = [];

  @override
  void initState() {
    db.getAllSource().then((items) {
      setState(() {
        filteredSources = items;
      });
    });
    // filteredSources = sources;
    super.initState();
  }

  @override
  void dispose() {
    db.close();
    super.dispose();
  }

  void filterSourceByName(String name) { 
    setState(() { 
      filterName = name;
      filteredSources = sources 
          .where((source) => source.name!.contains(filterName)) 
          .toList(); 
    }); 
  }

  Future<void> _dialogNewSource(BuildContext context) {
    return showDialog(
      context: context, 
      builder: (BuildContext context) {
        var nameCtrl = TextEditingController();
        var endpointCtrl = TextEditingController();
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text("Connection info"),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            controller: nameCtrl,
                            decoration: InputDecoration(
                              labelText: "Display name",
                              hintText: 'E.g: Headquarter office',
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            controller: endpointCtrl,
                            decoration: InputDecoration(
                              labelText: "Endpoint",
                              hintText: 'E.g: 192.168.1.1:4370',
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
                ),
                const Expanded(
                  child: Card.filled(
                    child: Column(
                      children: [
                        Text("Base Checkin configurations"),
                      ],
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
                db.create(SourceModel.fromMap({"source_id": "23423523", "name": nameCtrl.text, "created_time": 1720952235709}));
                Navigator.of(context).pop();
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
            child: Card(
              margin: const EdgeInsets.only(top: 14, bottom: 14, right: 8),
              color: Theme.of(context).colorScheme.onSecondary,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Sources',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      divider,
                      Row(
                        children: <Widget>[
                          FilledButton.icon(
                            onPressed: ()async => await _dialogNewSource(context),
                            icon: const Icon(Icons.add),
                            label: const Text('New source'),
                          )
                        ],
                      ),
                      // TextField(
                      //   decoration: const InputDecoration(labelText: 'Filter by source name'),
                      //   onChanged: filterSourceByName,
                      // ),
                      divider,
                      for (var source in filteredSources)
                        SourceItem(info: source)
                    ],
                  ),
                ),
              ),
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
  @override
  Widget build(BuildContext context) {
    return Text(widget.info.name!);
  }
}
