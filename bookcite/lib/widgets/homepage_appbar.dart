import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class HomepageAppbar extends StatefulWidget implements PreferredSizeWidget{
  final double appBarHeight;
  const HomepageAppbar({ required this.appBarHeight, super.key});

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  State<HomepageAppbar> createState() => _HomepageAppbarState();
}

class _HomepageAppbarState extends State<HomepageAppbar> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppBar(
      leading: IconButton(onPressed: () {}, icon: Icon(Icons.dehaze)),
      backgroundColor: Colors.transparent,
      centerTitle: false,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(style: textTheme.headlineMedium, children: [
              TextSpan(
                  text: "book",
                  style: TextStyle(
                    color: AppColors.colorButtonPrimary,
                  )),
              TextSpan(text: "Cite")
            ]),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
        ),
        IconButton(
            onPressed: () {}, icon: Icon(Icons.favorite_border_outlined))
      ],
    );
  }
}
