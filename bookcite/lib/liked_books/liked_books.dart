import 'package:bookcite/services/api_services.dart';
import 'package:bookcite/services/models/book_model.dart';
import 'package:bookcite/widgets/custom_appbar.dart';
import 'package:bookcite/widgets/genre_page_tiles.dart';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class LikedBooks extends StatefulWidget {
  final String genre;
  const LikedBooks({super.key, required this.genre});

  @override
  State<LikedBooks> createState() => _LikedBooksState();
}

class _LikedBooksState extends State<LikedBooks>  {
  late Future<List<Book>> _booksFuture;
  final ApiService _apiService = ApiService(baseUrl: "https://bookcite.onrender.com");

  @override
  void initState() {
    super.initState();
    _booksFuture = _apiService.fetchLikedBooks(); // <-- Use fetchLikedBooks here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(
        onPressed: () => Navigator.pop(context),
        appBarHeight: (widget.genre.length) > 17 ? MediaQuery.of(context).size.height * 0.10 : MediaQuery.of(context).size.height * 0.07,
        heading: widget.genre,
      ),
      body: Stack(
        children: [
          // Background decorations
          Positioned(
            top: MediaQuery.of(context).size.height * -0.6,
            right: MediaQuery.of(context).size.width * 0.1,
            child: Container(
              width: 800,
              height: 800,
              decoration: BoxDecoration(
                color: AppColors.colorSurfaceSecondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * -0.6,
            left: 0,
            child: Container(
              width: 800,
              height: 800,
              decoration: BoxDecoration(
                color: AppColors.colorSurfaceSecondary,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Books Grid / Loader / Empty state
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.13,
            child: FutureBuilder<List<Book>>(
              future: _booksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return  Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: Center(
                      child: Text("Empty… just like a teen rom-com before the meet-cute."), // <-- Updated message
                    ),
                  );
                }

                final books = snapshot.data!;
                return GridView.builder(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.01,
                    horizontal: MediaQuery.of(context).size.width * 0.02,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.535,
                    crossAxisSpacing: MediaQuery.of(context).size.width * 0.02,
                    mainAxisSpacing: MediaQuery.of(context).size.height * 0.01,
                  ),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return GenrePageTiles(
                      author: book.author,
                      title: book.name,
                      likes: book.likes,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
