import 'package:flutter/material.dart';

class DefaultButton extends StatefulWidget {
  DefaultButton(
      {Key? key, required this.onTap, required this.labelText, this.isPrimary})
      : super(key: key);

  final void Function()? onTap;
  final String labelText;
  final bool? isPrimary;

  @override
  State<DefaultButton> createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: // sign in button
          Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: widget.isPrimary == null || widget.isPrimary == true
                    ? Color.fromRGBO(100, 115, 255, 1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(10)),
            child: Center(
                child: Text(
              widget.labelText,
              style: TextStyle(
                  color: widget.isPrimary == null || widget.isPrimary == true
                      ? Colors.white
                      : Color.fromRGBO(100, 115, 255, 1),
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            )),
          ),
        ),
      ),
    );
  }
}
