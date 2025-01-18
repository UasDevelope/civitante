import 'package:flutter/material.dart';
import 'package:civitante/App/utilse/widgets.dart';
class CustomPinInput extends StatelessWidget {
  final TextEditingController controller;
  final int length;
  final Function(String) onCompleted;
  final Color defaultBorderColor;
  final Color focusedBorderColor;
  final Color submittedBorderColor;
  final Color cursorColor;
  final double width;
  final double height;
  final TextStyle textStyle;

  const CustomPinInput({
    Key? key,
    required this.controller,
    required this.length,
    required this.onCompleted,
    this.defaultBorderColor = Colors.blue,
    this.focusedBorderColor = Colors.green,
    this.submittedBorderColor = Colors.grey,
    this.cursorColor = Colors.blue,
    this.width = 50,
    this.height = 60,
    this.textStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Pinput(
      controller: controller,
      length: length, // Number of fields
      onCompleted: onCompleted,
      defaultPinTheme: PinTheme(
        width: width,
        height: height,
        textStyle: textStyle,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: defaultBorderColor),
        ),
      ),
      focusedPinTheme: PinTheme(
        width: width,
        height: height,
        textStyle: textStyle,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: focusedBorderColor),
        ),
      ),
      submittedPinTheme: PinTheme(
        width: width,
        height: height,
        textStyle: textStyle,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: submittedBorderColor),
        ),
      ),
      showCursor: true,
      cursor: Container(
        height: height * 0.8,
        width: 2,
        color: cursorColor,
      ),
    );
  }
}
