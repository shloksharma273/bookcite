import 'package:bookcite/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import '../widgets/book_details.dart';
import 'package:bookcite/services/models/book_model.dart';

class TodaysPick extends StatelessWidget {
  final Book book;
  final String? heading;

  const TodaysPick({
    Key? key,
    required this.book,
    this.heading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(
        heading: heading ?? " ",
        onPressed: () {
          Navigator.pop(context);
        },
        appBarHeight: MediaQuery.of(context).size.height * 0.06,
      ),
      body: BookDetails(
        genreTags: book.genres,
        title: book.name,
        author: book.author,
        summary: book.summary,
      ),
    );
  }
}

