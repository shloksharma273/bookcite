import 'package:bookcite/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import '../widgets/book_details.dart';

class TodaysPick extends StatefulWidget {
  const TodaysPick({super.key});

  @override
  State<TodaysPick> createState() => _TodaysPickState();
}

class _TodaysPickState extends State<TodaysPick> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        appBar: CustomAppbar(heading: "Today's Pick", onPressed: (){
          Navigator.pop(context);
        }, appBarHeight: MediaQuery.of(context).size.height * 0.06,),
        body: BookDetails(genreTags: ["drama", "fiction", "fantasy", "adventure"], title: "White Nights", author: "Fyodor Dostoevsky", summary: "Fyodor Dostoevsky's White Nights is a poignant novella set in St. Petersburg, Russia, during the fleeting period of white nights when dusk never fully settles. The story is narrated by a lonely and introverted young man, a self-proclaimed dreamer, who spends his days lost in his vivid imagination and his nights wandering the city's streets.\nOne evening, he encounters Nastenka, a young woman crying by a canal. He intervenes when she's being harassed and they strike up an unusual friendship. Over the course of four white nights, they meet and share their deepest thoughts, dreams, and disappointments. Nastenka reveals her own story of a sheltered life with her strict, blind grandmother and her unrequited love for a lodger who promised to return for her.\nAs the dreamer listens to Nastenka's tale and helps her try to reconnect with her lost love, he inevitably falls deeply in love with her. However, his love remains unrequited, as Nastenka's heart is set on the man she's waiting for. The novella explores themes of loneliness, unfulfilled desire, the power of imagination versus reality, and the bittersweet nature of fleeting connections. It's a tender and melancholic portrayal of the human yearning for companionship and the pain of unreciprocated affection.")
    );
  }
}

