import 'package:bookcite/authentication/login_page.dart';
import 'package:bookcite/authentication/signup_page.dart';
import 'package:bookcite/homepage/home_page.dart';
import 'package:bookcite/services/api_services.dart';
import 'package:bookcite/utils/app_colors.dart';
import 'package:bookcite/utils/responsive_sizer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        '/home' : (context) => HomePage()
      },
    );
  }
}

