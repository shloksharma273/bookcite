import 'package:flutter/material.dart';
import 'package:bookcite/services/api_services.dart';
import 'package:bookcite/todayspick/todays_pick.dart';
// import 'package:bookcite/services/models/book_model.dart';

import '../utils/app_colors.dart';

class GenrePageTiles extends StatefulWidget {
  final String author;
  final String title;
  final int likes;
  const GenrePageTiles({super.key, required this.title, required this.author, required this.likes});

  @override
  State<GenrePageTiles> createState() => _GenrePageTilesState();
}

class _GenrePageTilesState extends State<GenrePageTiles> {
  SizedBox likeButton(double size, bool isLiked) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          isLiked
              ? Icon(
            Icons.favorite,
            color: AppColors.colorSurfaceSecondary,
          )
              : Icon(
            Icons.favorite,
            color: Colors.transparent,
          ),
          Icon(Icons.favorite_border_outlined)
        ],
      ),
    );
  }

  bool _isLiked = false;
  late int _currentLikes;

  void doubleTapFunc () {

    setState(() {
      if (_isLiked == false) {
        _currentLikes++;
      } else {
        _currentLikes--;
      }
      _isLiked = !_isLiked;
    });
  }

  @override
  void initState() {
    _isLiked = false;
    _currentLikes = widget.likes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal : MediaQuery.of(context).size.width * 0.03),
      child: Column(
        mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onDoubleTap: doubleTapFunc,
              onTap: () async {
                final ApiService apiService = ApiService(baseUrl: "https://bookcite.onrender.com");
                // Show loading dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(child: CircularProgressIndicator()),
                );
                try {
                  final fetchedBooks = await apiService.fetchBooksByName(widget.title);
                  if (!context.mounted) return;
                  Navigator.of(context).pop(); // Dismiss loading dialog
                  if (fetchedBooks.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TodaysPick(
                          book: fetchedBooks.first,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Book not found')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.of(context).pop(); // Dismiss loading dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border:
                      Border.all(color: AppColors.colorBlack, width: 2),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    left: 5,
                    child: Row(
                        children: [
                      likeButton(
                          MediaQuery.of(context).size.width * 0.06, _isLiked),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Text(
                        _currentLikes.toString(),
                        style: textTheme.labelMedium,
                      )
                    ]),
                  )
                ],
              ),
            ),
            Text(widget.title, textAlign: TextAlign.center,),
            Text(
              widget.author,
              style: textTheme.labelMedium,textAlign: TextAlign.center
            )
          ],
        ),
    );
  }
}
