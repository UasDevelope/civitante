import 'package:civitante/App/shared/app_text.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final Function(String) onChanged;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          maxLines: null,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

class InfoTile extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  const InfoTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(icon, color: Colors.grey, height: 25,width:30,),
                SizedBox(width: 12),
                AppText(
                  text: title,
                  fontWeight:FontWeight.w500,
                  fontSize:12,
                  color:AppColors.Slate_gray
                ),
              ],
            ),
            Row(
              children: [
                AppText(text:
                  value,
                    fontWeight:FontWeight.w600,
                    fontSize:14,
                    color:AppColors.appColor
                ),
                SizedBox(width: 8),
                Icon(Icons.chevron_right, color:AppColors.appColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
