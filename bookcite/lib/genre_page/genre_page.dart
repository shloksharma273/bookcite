import 'package:bookcite/widgets/custom_appbar.dart';
import 'package:bookcite/widgets/genre_page_tiles.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class GenrePage extends StatefulWidget {
  const GenrePage({super.key});

  @override
  State<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  List bookList = [
    ["To Kill a Mockingbird", "Harper Lee", 378],
    ["1984", "George Orwell", 152],
    ["Pride and Prejudice", "Jane Austen", 291],
    ["The Great Gatsby", "F. Scott Fitzgerald", 486],
    ["The Catcher in the Rye", "J.D. Salinger", 225],
    ["Lord of the Rings", "J.R.R. Tolkien", 401],
    ["Harry Potter and the Sorcerer's Stone", "J.K. Rowling", 119],
    ["The Hobbit", "J.R.R. Tolkien", 333],
    ["The Diary of a Young Girl", "Anne Frank", 267],
    ["Dune", "Frank Herbert", 450]
  ];
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(
        onPressed: () {},
        appBarHeight: MediaQuery.of(context).size.height * 0.07,
        heading: "Editor's Pick",
      ),
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * -0.6,
            right: MediaQuery.of(context).size.width * 0.1,
            child: Container(
              width: 800, // Adjust size as needed
              height: 800,
              decoration: BoxDecoration(
                color:
                    AppColors.colorSurfaceSecondary, // Adjust color as needed
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * -0.6,
            left: 0,
            child: Container(
              width: 800, // Adjust size as needed
              height: 800,
              decoration: BoxDecoration(
                color:
                    AppColors.colorSurfaceSecondary, // Adjust color as needed
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.01,
            right: 0,
            left: 0,
            bottom: MediaQuery.of(context).size.height * 0.001 ,
            child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.55,
              crossAxisSpacing: MediaQuery.of(context).size.width * 0.02,
              mainAxisSpacing: MediaQuery.of(context).size.height * 0.01,
            ),
              itemCount: bookList.length,
              itemBuilder: (context, index) {
                var book = bookList[index];
                return GenrePageTiles(author: book[1], title: book[0], likes: book[2]);
              },
            ),

          )],
      ),
    );
  }
}
