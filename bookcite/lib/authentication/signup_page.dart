import 'package:bookcite/services/api_services.dart';
import 'package:bookcite/utils/app_assets.dart';
import 'package:bookcite/utils/app_colors.dart';
import 'package:bookcite/widgets/custom_button.dart';
import 'package:bookcite/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpPage extends StatefulWidget {
  final ApiService apiService;
  SignUpPage({super.key, required this.apiService});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  TextEditingController _nameController = TextEditingController();
  bool _isLoading = false ;

  Future<void> _signup() async {
    bool hasSignedUp = false;
    setState(() {
      _isLoading = true;
    });
    try {
      hasSignedUp = await widget.apiService.signUp(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text);

      if (hasSignedUp == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('User Created by Name: ${_nameController.text}')),
        );
        // Navigator.pushNamed(context, '/login');
         await widget.apiService.login(email: _emailController.text, password: _passwordController.text);
         Navigator.pushNamed(context, '/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }


  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.colorSurfacePrimary,
        body: Stack(
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
                    color: AppColors.colorSurfaceSecondary),
              ),
            ),
            Positioned(
              top: 0,
              left: MediaQuery.of(context).size.width * 0.08,
              right: MediaQuery.of(context).size.width * 0.08,
              bottom: MediaQuery.of(context).size.width * 0.05,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                    ),
                    SvgPicture.asset(
                      AppAssets.homePageImage,
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.29,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.03),
                      child: RichText(
                        text: TextSpan(
                            style: textTheme.headlineMedium,
                            children: [
                              TextSpan(
                                  text: "Unlock a\n",
                                  style:
                                      TextStyle(color: AppColors.colorBlack)),
                              TextSpan(
                                  text: "new World",
                                  style: TextStyle(
                                      color: AppColors.colorButtonPrimary)),
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    HomePageTextField(
                      labelText: "Enter Name",
                      toObscure: false,
                      controller: _nameController,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    HomePageTextField(
                      labelText: "Enter Email ID",
                      toObscure: false,
                      controller: _emailController,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    HomePageTextField(
                      labelText: "Enter Password",
                      toObscure: true,
                      controller: _passwordController,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    //TODO: to add loading animation
                    _isLoading?CircularProgressIndicator(
                      color: Colors.black,
                    ):
                    CustomButton(
                      onTap: () {
                        _signup();
                      },
                      title: "Sign Up",
                    ) ,
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: textTheme.bodySmall,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Text(
                            "Log In",
                            style: textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
