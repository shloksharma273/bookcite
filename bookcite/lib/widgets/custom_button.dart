import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback? onTap;
  final String title;
  const CustomButton({super.key, required this.onTap, required this.title});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.83,
      height: MediaQuery.of(context).size.height * 0.055,
      child: ElevatedButton(
        onPressed: widget.onTap,
        style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.height *
                      0.009),
            ),
            backgroundColor: AppColors.colorButtonPrimary),
        child: Text(widget.title, style: const TextStyle(
            color: AppColors.colorBlack
        ),),
      ),
    );
  }
}
