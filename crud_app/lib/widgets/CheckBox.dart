import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class DefaultCheckBox extends StatefulWidget {
  DefaultCheckBox(
      {Key? key,
      required this.onChange,
      required this.labelText,
      required this.value})
      : super(key: key);

  final void Function(bool value) onChange;
  final String labelText;
  final bool value;

  @override
  State<DefaultCheckBox> createState() => _DefaultCheckBoxState();
}

class _DefaultCheckBoxState extends State<DefaultCheckBox> {
  bool _value = false;

  @override
  void initState() {
    // TODO: implement initState
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Container(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.1,
              child: Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  checkColor: Color.fromRGBO(100, 115, 255, 1),
                  activeColor: Colors.white,
                  fillColor: MaterialStateProperty.all(Colors.white),
                  value: _value,
                  onChanged: (value) {
                    setState(() {
                      this._value = value ?? false;
                    });
                    widget.onChange(value ?? false);
                  }),
            ),
            Expanded(
              child: Text(
                widget.labelText,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 17),
              ),
            )
          ],
        ),
      ),
    );
  }
}
