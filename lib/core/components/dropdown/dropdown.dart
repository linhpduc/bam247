import 'package:flutter/material.dart';

class DropdownComp extends StatelessWidget {
  final String selectedValue;
  final List<DropdownMenuEntry<String>> items;
  final ValueChanged<String?> onSelected;

  const DropdownComp({
    Key? key,
    required this.selectedValue,
    required this.items,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: DropdownMenu<String>(
          textStyle: const TextStyle(fontSize: 14),
          initialSelection: selectedValue,
          onSelected: onSelected,
          dropdownMenuEntries: items,
      ),
    );
  }
}
