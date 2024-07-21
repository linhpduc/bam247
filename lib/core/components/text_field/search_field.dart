import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          labelText: AppLocalizations.of(context)!.filter_by_name,
          labelStyle: const TextStyle(fontSize: 14),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
