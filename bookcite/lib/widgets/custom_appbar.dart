import 'package:bookcite/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? heading;
  final VoidCallback? onPressed;
  final double appBarHeight;

  const CustomAppbar({
    super.key,
    this.heading,
    required this.onPressed,
    required this.appBarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    Widget generateTitle(String title) {
      List<String> titleList = title.split(' ');

      if (titleList.length > 1) {
        return Text.rich(
          TextSpan(
            style: textTheme.headlineMedium?.copyWith(
              overflow: TextOverflow.visible,
            ),
            children: [
              TextSpan(
                text: '${titleList[0]} ',
                style: TextStyle(
                  color: AppColors.colorButtonPrimary,
                ),
              ),
              TextSpan(
                text: titleList.sublist(1).join(' '),
              ),
            ],
          ),
          textAlign: TextAlign.center,
          maxLines: 2, // allow wrapping into 2 lines
          overflow: TextOverflow.ellipsis,
        );
      } else {
        return Text(
          titleList[0],
          style: textTheme.headlineMedium?.copyWith(
            color: AppColors.colorButtonPrimary,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
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
      toolbarHeight: appBarHeight + 10, // give a bit more height for long titles
      title: (heading != null) ? generateTitle(heading!) : null,
    );
  }
}
