import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class HomepageFeedCard extends StatefulWidget {
  final String author;
  final String quote;
  final String book;
  final int likes;
  const HomepageFeedCard({ required this.author, required this.book, required this.quote, required this.likes, super.key});

  @override
  State<HomepageFeedCard> createState() => _HomepageFeedCardState();
}

class _HomepageFeedCardState extends State<HomepageFeedCard> {

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

  SizedBox likeButton(double size, bool isLiked){
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          isLiked ? Icon(Icons.favorite, color: AppColors.colorSurfaceSecondary,) : Icon(Icons.favorite, color: Colors.transparent,),
          Icon(Icons.favorite_border_outlined)
        ],
      ),
    );
  }

  @override void initState() {
    _currentLikes = widget.likes;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onDoubleTap: doubleTapFunc,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.28,
        width: MediaQuery.of(context).size.width * (361 / 393),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * 0.03),
            color: AppColors.colorSurfacePrimary,
            border: Border.all(color: AppColors.colorBlack)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal:
              MediaQuery.of(context).size.width * 0.03),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.quote,
                textAlign: TextAlign.center,
                style: textTheme.labelLarge,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '(${widget.book})',
                    style: textTheme.labelMedium,
                  ),
                  Text(
                    "- ${widget.author}",
                    style: textTheme.labelMedium,
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                children: [
                  likeButton(MediaQuery.of(context).size.width * 0.06, _isLiked),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  Text(
                    _currentLikes.toString() , style: textTheme.labelMedium,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
