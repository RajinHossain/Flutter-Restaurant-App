import 'package:flutter/material.dart';

class InputBox extends StatefulWidget {
  InputBox(
      {Key? key,
      required this.controller,
      this.hintText,
      required this.labelText,
      required this.isReadOnly,
      required this.isPassword,
      required this.isPrimary,
      this.maxLines,
      this.padding,
      this.centerText,
      this.isNumber})
      : super(key: key);

  final TextEditingController controller;
  final String? hintText;
  final String labelText;
  final bool isPassword;
  final bool isReadOnly;
  final bool isPrimary;
  final int? maxLines;
  final List<double>? padding;
  final bool? centerText;
  final bool? isNumber;

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: // email
          Padding(
        padding: widget.padding != null
            ? EdgeInsets.fromLTRB(widget.padding![0], widget.padding![1],
                widget.padding![2], widget.padding![3])
            : const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                widget.labelText,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: widget.isPrimary ? Colors.black : Colors.white),
                textAlign: TextAlign.start,
              ),
            ),
            TextField(
              keyboardType: widget.isNumber != null && widget.isNumber == true
                  ? TextInputType.number
                  : TextInputType.name,
              textAlign:
                  widget.centerText != null ? TextAlign.center : TextAlign.left,
              maxLines: widget.maxLines ?? 1,
              obscureText: widget.isPassword,
              readOnly: widget.isReadOnly,
              controller: widget.controller,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(249, 249, 249, 1)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(100, 115, 255, 1)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Color.fromRGBO(249, 249, 249, 1),
                  filled: true,
                  hintText: widget.hintText),
            ),
          ],
        ),
      ),
    );
  }
}
