import 'package:bookcite/authentication/signup_page.dart';
import 'package:bookcite/services/api_services.dart';
import 'package:bookcite/services/models/auth_response.dart';
import 'package:bookcite/utils/app_assets.dart';
import 'package:bookcite/utils/app_colors.dart';
import 'package:bookcite/widgets/custom_button.dart';
import 'package:bookcite/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  final ApiService apiService ;
  const LoginPage({super.key, required this.apiService});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  
  Future<void> _login() async{
    print("_login function");
    setState(() {
      _isLoading = true; } );

    try{
      AuthResponse authResponse = await widget.apiService.login(email: _emailController.text, password: _passwordController.text);
      //TODO : add cookies storing here
      Navigator.of(context).pushReplacementNamed('/home');
    } catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    }

    finally {
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
                      controller: _emailController,
                      labelText: "Enter Email ID",
                      toObscure: false,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    HomePageTextField(
                      controller: _passwordController,
                        labelText: "Enter Password", toObscure: true),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.001,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forget Password?",
                          style: textTheme.bodySmall,
                        ),
                      ),
                    ),

                    CustomButton(onTap: (){
                      _login() ;
                      print("Login Button");
                    }, title: "Login",),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04

                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Not Register Yet? " , style: textTheme.bodySmall,),
                        GestureDetector(
                          onTap: () { Navigator.pushNamed(context, '/signUp');
                          },
                          child: Text("Create Account", style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),),
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
