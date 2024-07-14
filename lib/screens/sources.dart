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
    // db.getAllSource().then((items) {
    //   setState(() {
    //     filteredSources = items;
    //   });
    // });
    filteredSources = sources;
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
          .where((source) => source.name.contains(filterName)) 
          .toList(); 
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Card(
            color: Theme.of(context).colorScheme.onSecondary,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Shadow Color Only',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    divider,
                    TextField(
                      decoration: const InputDecoration(labelText: 'Filter by name'),
                      onChanged: filterSourceByName,
                    ),
                    divider,
                    for (var source in filteredSources)
                      SourceItem(info: source)
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

class SourceItem extends StatefulWidget {
  const SourceItem({super.key, required this.info});
  final SourceModel info;

  @override
  State<SourceItem> createState() => _SourceItemState();
}

class _SourceItemState extends State<SourceItem> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.info.name);
  }
}
