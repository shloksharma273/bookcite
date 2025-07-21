import 'package:bookcite/components/genre_tiles/genre_tiles.dart';
import 'package:bookcite/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> genreList = [
    "Adventure",
    "Fiction",
    "Non-Fiction",
    "Thriller",
    "Romance",
    "Horror",
    "Poetry"
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
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
              top: MediaQuery.of(context).size.height * 0.05,
              right: 0,
              left: 0,
              bottom: -0.15,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.03),
                      child: Text("Search", style: textTheme.headlineLarge),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    CustomSearchBar(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.03),
                      child: Text(
                        "Top Genres",
                        style: textTheme.headlineMedium,
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.77,
                        crossAxisSpacing: MediaQuery.of(context).size.width * 0.02,
                        mainAxisSpacing: MediaQuery.of(context).size.height * 0.02,
                      ),
                        itemCount: genreList.length,
                        itemBuilder: (context, index) {
                          var label = genreList[index];
                          return GenreTiles(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.45,
                            label: label,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
