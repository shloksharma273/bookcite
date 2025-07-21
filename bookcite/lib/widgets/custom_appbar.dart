import 'package:bookcite/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? heading;
  final VoidCallback? onPressed;
  final double appBarHeight;
  const CustomAppbar(
      {super.key,
      this.heading,
      required this.onPressed,
      required this.appBarHeight});

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    RichText generateTitle(String title) {
      List<String> titleList = title.split(' ');
      if (titleList.length > 1) {
        return RichText(
          text: TextSpan(style: textTheme.headlineMedium, children: [
            TextSpan(
                text: '${titleList[0]} ',
                style: TextStyle(
                  color: AppColors.colorButtonPrimary,
                )),
            TextSpan(text: titleList.sublist(1).join(' '))
          ]),
        );
      } else {
        return RichText(
          text: TextSpan(style: textTheme.headlineMedium, children: [
            TextSpan(
              text: titleList[0],
              style: TextStyle(
                color: AppColors.colorButtonPrimary,
              ),
            ),
          ]),
        );
      }
    }

    return AppBar(
      backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: onPressed,
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            size: MediaQuery.of(context).size.width * 0.05,
          ),
        ),
        centerTitle: true,
        title: (heading != null) ? generateTitle(heading.toString()) : null)
    ;
  }
}
