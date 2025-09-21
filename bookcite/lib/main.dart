import 'package:bookcite/authentication/login_page.dart';
import 'package:bookcite/authentication/signup_page.dart';
import 'package:bookcite/genre_page/genre_page.dart';
import 'package:bookcite/homepage/home_page.dart';
import 'package:bookcite/search_page/search_page.dart';
import 'package:bookcite/services/api_services.dart';
import 'package:bookcite/upload_book/upload_book.dart';
// import 'package:bookcite/todayspick/todays_pick.dart';
import 'package:bookcite/utils/responsive_sizer.dart';
// import 'package:bookcite/genre_page/genre_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  final ApiService _apiService = ApiService(baseUrl: "https://bookcite.onrender.com");
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      builder: (context, child) {
        final responsiveTextTheme = ResponsiveSizer.createResponsiveTextTheme(context);
        return Theme(
        data: Theme.of(context).copyWith(textTheme: responsiveTextTheme),
        child: child!, // Make sure to return the original child
        );
      },
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: FutureBuilder<bool> (
        future: _apiService.isLoggedIn(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(
              color: Colors.white,
            ));
          } else {
            if (snapshot.hasData && snapshot.data == true){
              return HomePage();
            } else {
              return SignUpPage(apiService: _apiService,);
            }
          }
        }
      ),
      routes: {
        '/login' : (context) => LoginPage(apiService: _apiService),
        '/signUp' : (context) => SignUpPage(apiService: _apiService),
        '/home' : (context) => HomePage(),
        '/search' : (context) => SearchPage(),
        '/uploadbook' : (context) => UploadBook(),
        // '/todayspick' : (context) => TodaysPick(),
        '/fiction': (context) => GenrePage(genre: "Fiction"),
        '/mystery-thriller': (context) => GenrePage(genre: "Mystery, Thriller & Suspense"),
        '/romance': (context) => GenrePage(genre: "Romance"),
        '/sci-fi-fantasy': (context) => GenrePage(genre: "Science Fiction & Fantasy"),
        '/horror': (context) => GenrePage(genre: "Horror & Supernatural"),
        '/ya': (context) => GenrePage(genre: "Young Adult (YA)"),
        '/children': (context) => GenrePage(genre: "Children’s Books"),
        '/non-fiction': (context) => GenrePage(genre: "Non-Fiction"),
        '/classics': (context) => GenrePage(genre: "Classics"),
        '/poetry-drama': (context) => GenrePage(genre: "Poetry & Drama"),
        '/comics': (context) => GenrePage(genre: "Graphic Novels & Comics"),
        '/academic': (context) => GenrePage(genre: "Educational & Academic"),

      },
    );
  }
}

