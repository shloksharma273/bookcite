import 'package:bookcite/utils/app_colors.dart';
import 'package:flutter/material.dart';

class BookDetails extends StatefulWidget {
  final String title;
  final String author;
  final List<String> genreTags;
  final String summary;

  const BookDetails(
      {
        super.key,
        required this.genreTags,
        required this.title,
        required this.author,
        required this.summary
      });

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        Positioned(
          bottom: -(MediaQuery.of(context).size.height) * 0.3,
          left: -(MediaQuery.of(context).size.width * 0.2),
          child: Container(
            width: MediaQuery.of(context).size.width * (10.0),
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * (10.0)),
                color: AppColors.colorSurfacePrimary),
          ),
        ),

        Positioned(
          top: MediaQuery.of(context).size.height * 0.03,
          left: MediaQuery.of(context).size.width * 0.00,
          right: MediaQuery.of(context).size.width * 0.00,
          bottom: MediaQuery.of(context).size.width * 0.05,
          child: SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.09,
                  ),

                  Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.colorButtonPrimary, width: 2.0),
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.height * 0.02),
                          color: Colors.transparent,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.04,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              widget.title,
                              style: textTheme.headlineMedium,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Text("- ${widget.author}",
                                style: textTheme.bodyLarge)
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Wrap(
                    spacing: MediaQuery.of(context).size.width * 0.02,
                    runSpacing: MediaQuery.of(context).size.height * 0.009,
                    children: widget.genreTags.map((genre){
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.04,
                        width: genre.length > 7 ? MediaQuery.of(context).size.width * 0.3 : MediaQuery.of(context).size.width * 0.2,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.height * 0.02),
                            border: Border.all(
                                width: 1.0,
                                color: AppColors.colorButtonPrimary)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                              MediaQuery.of(context).size.width * 0.005),
                          child: Center(
                            child: Text(
                              genre,
                              style: textTheme.labelLarge
                                  ?.copyWith(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      );
                    }).toList(),),


                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                        MediaQuery.of(context).size.width * 0.02),
                    child: RichText(
                      text: TextSpan(
                          style: textTheme.headlineMedium,
                          children: [
                            TextSpan(
                                text: "Short ",
                                style: TextStyle(
                                  color: AppColors.colorButtonPrimary,
                                )),
                            TextSpan(text: "Take")
                          ]),
                    ),
                  ),
                  Text(
                      widget.summary,
                      style: textTheme.bodyMedium),
                ],
              ),
            ),
          ),)

      ],
    );
  }
}
