import 'package:flutter/material.dart';

class DefaultDropdown extends StatefulWidget {
  DefaultDropdown({
    Key? key,
    required this.selectedItem,
    required this.items,
    required this.onChange,
    required this.labelText,
  }) : super(key: key);

  final String labelText;
  final String selectedItem;
  final List<String> items;
  final void Function(String value) onChange;

  @override
  State<DefaultDropdown> createState() => _DefaultDropdownState();
}

class _DefaultDropdownState extends State<DefaultDropdown> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              widget.labelText,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white),
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1.0,
                    style: BorderStyle.solid,
                    color: Color.fromRGBO(100, 115, 255, 1)),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            child: DropdownButton(
                underline: const SizedBox(),
                borderRadius: BorderRadius.circular(10),
                isExpanded: true,
                value: widget.selectedItem,
                items:
                    widget.items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) => {widget.onChange(value!)}),
          ),
        ],
      ),
    );
  }
}
