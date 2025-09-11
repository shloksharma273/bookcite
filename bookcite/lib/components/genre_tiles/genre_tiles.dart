import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class GenreTiles extends StatelessWidget {
  final double width;
  final double height;
  final String label;
  final double _radius = 11;
  const GenreTiles(
      {super.key,
      required this.width,
      required this.height,
      required this.label});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: AppColors.colorButtonPrimary,
                borderRadius: BorderRadius.circular(_radius),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.5),
                      spreadRadius: 3,
                      blurRadius: 4,
                      offset: Offset(-3, 5)),
                ]),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0x45000000),  AppColors.colorButtonPrimary], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                borderRadius: BorderRadius.circular(_radius)
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Text(label, style: textTheme.bodyMedium?.copyWith(
                color: Colors.white
              ), textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
