// import 'package:bookcite/genre_page/genre_page.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import 'package:bookcite/services/api_services.dart';
// import 'package:bookcite/services/models/book_model.dart';
import 'package:bookcite/liked_books/liked_books.dart'; // You'll create this

class HomepageAppbar extends StatefulWidget implements PreferredSizeWidget{
  final double appBarHeight;
  final String favouriteRoute;
  final String searchRoute;
  const HomepageAppbar({ required this.appBarHeight, super.key, required this.favouriteRoute, required this.searchRoute});

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  State<HomepageAppbar> createState() => _HomepageAppbarState();
}

class _HomepageAppbarState extends State<HomepageAppbar> {
  final ApiService apiService = ApiService(baseUrl: 'https://bookcite.onrender.com');

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppBar(
      leading: IconButton(onPressed: () {
        Scaffold.of(context).openDrawer();
      }, icon: Icon(Icons.dehaze)),
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LikedBooks(genre: "Liked Books"),
              ),
            );
          },
          icon: Icon(Icons.favorite_border_outlined),
        ),
      ],
    );
  }
}
