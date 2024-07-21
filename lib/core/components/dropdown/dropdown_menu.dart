import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class BaseOptionDropdown<T> {
  String? label;
  String? value;
  T data;

  BaseOptionDropdown({this.label, this.value, required this.data});
}

class DropdownMenuComp extends StatefulWidget {
  List<BaseOptionDropdown> items;
  String? selectedValue;
  String? placeholder;

  DropdownMenuComp(
      {super.key, required this.items, this.selectedValue, this.placeholder});

  @override
  State<DropdownMenuComp> createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenuComp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: DropdownButtonFormField2<String>(
        isExpanded: true,
        value: widget.selectedValue,
        decoration: InputDecoration(
          // Add Horizontal padding using menuItemStyleData.padding so it matches
          // the menu padding when button's width is not specified.
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          // Add more decoration..
        ),
        hint: Text(
          widget.placeholder ?? '',
          style: const TextStyle(fontSize: 14),
        ),
        items: widget.items
            .map((item) => DropdownMenuItem<String>(
                  value: item.value,
                  child: Text(
                    item.label ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ))
            .toList(),
        validator: (value) {
          if (value == null) {
            return 'Please ${widget.placeholder ?? ''}.';
          }
          return null;
        },
        onChanged: (value) {
          //Do something when selected item is changed.
        },
        onSaved: (value) {
          widget.selectedValue = value.toString();
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(right: 8),
        ),
        iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.arrow_right,
            ),
            iconSize: 24,
            openMenuIcon: Icon(
              Icons.arrow_drop_down,
            )),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          offset: const Offset(0, -10),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: WidgetStateProperty.all(6),
            thumbVisibility: WidgetStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
