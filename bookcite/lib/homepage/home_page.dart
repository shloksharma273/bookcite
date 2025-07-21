import 'package:bookcite/widgets/custom_appbar.dart';
import 'package:bookcite/widgets/homepage_appbar.dart';
import 'package:bookcite/widgets/homepage_feed_card.dart';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/book_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: HomepageAppbar(
          appBarHeight: MediaQuery.of(context).size.height * 0.07),
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
            top: MediaQuery.of(context).size.height * 0.347,
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.04),
                child: HomepageFeedCard(
                    author: "Fyodor Dostoevsky",
                    book: "The White Nights",
                    likes: 280,
                    quote:
                        "My God, a whole moment of happiness! Is that too little for the whole of a man's life?")),
          ),
        ],
      ),
    );
  }
}
