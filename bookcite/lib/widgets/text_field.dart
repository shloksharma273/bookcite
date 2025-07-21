import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class HomePageTextField extends StatefulWidget {
  final String labelText;
  final bool toObscure;
  const HomePageTextField({super.key, required this.labelText, required this.toObscure});


  @override
  State<HomePageTextField> createState() => _HomePageTextFieldState();}

class _HomePageTextFieldState extends State<HomePageTextField> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.83,
      height: MediaQuery.of(context).size.height * 0.055,
      child: TextField(
        obscureText: widget.toObscure,
        cursorColor: AppColors.colorBlack,
        cursorHeight: MediaQuery.of(context).size.height * 20/852,
        cursorWidth: MediaQuery.of(context).size.height * 1.5/852,
        style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 15/852
        ),
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: AppColors.colorButtonPrimary)),
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
