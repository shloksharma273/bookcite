import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class UploadBookTextField extends StatefulWidget {
  final String labelText;
  const UploadBookTextField({super.key, required this.labelText});


  @override
  State<UploadBookTextField> createState() => _UploadBookTextFieldState();}

class _UploadBookTextFieldState extends State<UploadBookTextField> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.83,
      height: MediaQuery.of(context).size.height * 0.055,
      child: TextField(
        obscureText: false,
        cursorColor: AppColors.colorBlack,
        cursorHeight: MediaQuery.of(context).size.height * 20/852,
        cursorWidth: MediaQuery.of(context).size.height * 1.5/852,
        style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 15/852
        ),
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: AppColors.colorBlack)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height *
                        0.009)),
            labelText: widget.labelText,
            labelStyle: textTheme.labelMedium),
      ),
    );
  }
}
