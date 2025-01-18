import 'package:flutter/material.dart';
import '../../../utilse/widgets.dart';

class HomeSerchField extends StatelessWidget {
  final String hintText;
  final Function(String)? onChanged;

  const HomeSerchField({
    Key? key,
    this.hintText = "Search...",
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:
            GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w400),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0), // Add padding to center the icon
          child: Image.asset(
            AppImages.search,
            height: 20.0, // Adjust the size of the icon
            width: 20.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            width: 0.25, // Slightly thicker for focus
            color: AppColors.textFieldHintColor, // Same color on focus
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15), // Adjust height
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0), // Makes it circular
          borderSide: BorderSide(
            width: 0.25, // Slightly thicker for focus
            color: AppColors.textFieldHintColor, // Sam
          ),
        ),
      ),
    );
  }
}
