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
  List<List<String>> genreList = [
    ['Fiction','/fiction'],
    ['Mystery, Thriller & Suspense','/mystery-thriller'],
    ['Romance','/romance'],
    ['Science Fiction & Fantasy','/sci-fi-fantasy'],
    ['Horror & Supernatural','/horror'],
    ['Young Adult (YA)','/ya'],
    ['Children\'s Books','/children'],
    ['Non-Fiction','/non-fiction'],
    ['Classics','/classics'],
    ['Poetry & Drama','/poetry-drama'],
    ['Graphic Novels & Comics','/comics'],
    ['Educational & Academic','/academic'],
  ];

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Stack(
        children: [
          // background decoration
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

          // content
          Positioned(
            top: MediaQuery.of(context).size.height * 0.05,
            right: 0,
            left: 0,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03,
                    ),
                    child: Text("Search", style: textTheme.headlineLarge),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                  // search bar
                  const CustomSearchBar(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                  // subtitle
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03,
                    ),
                    child: Text(
                      "Top Genres",
                      style: textTheme.headlineMedium,
                    ),
                  ),

                  // genres grid
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.77,
                        crossAxisSpacing: MediaQuery.of(context).size.width * 0.02,
                        mainAxisSpacing: MediaQuery.of(context).size.height * 0.02,
                      ),
                      itemCount: genreList.length,
                      itemBuilder: (context, index) {
                        var label = genreList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, label[1]);
                          },
                          child: GenreTiles(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.45,
                            label: label[0],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
