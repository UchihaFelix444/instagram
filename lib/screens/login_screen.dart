import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/screens/signup_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUser() async {
      setState(() {
        isLoading = true;
      });
      String res = await AuthMethods().loginUser(email: emailController.text, password: passwordController.text);
      if(res == "success")
        {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const ResponsiveLayout(webScreenLayout: WebScreenLayout(), mobileScreenLayout: MobileScreenLayout()),
            ),
          );
        }
      else
        {
            showSnackBar(context, res);
        }
      setState(() {
        isLoading =  false;
      });
  }

  void navigateToSignUp()
  {
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SignupScreen(),
        ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Space at the top
              Flexible(flex: 2, child: Container()),
              //Logo
              SvgPicture.asset('assets/ic_instagram.svg', color: primaryColor, height: 64),
              const SizedBox(height: 64),
              //Text field input for email
              TextFieldInput(
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                textEditingController: emailController,
              ),
              const SizedBox(height: 24),
              //Text field input for password
              TextFieldInput(
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                textEditingController: passwordController,
                isPass: true,
              ),
              const SizedBox(height: 24),
              //Login
              InkWell(
                onTap: loginUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    color: blueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4)
                      )
                    )
                  ),
                  child: isLoading ? const Center(child: CircularProgressIndicator(
                    color: primaryColor,
                  ),) : const Text('Log in'),
                ),
              ),
              const SizedBox(height: 24),
              Flexible(flex: 2, child: Container()),
              //Transition
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8
                    ),
                    child: const Text("Don't have an account?"),
                  ),
                  GestureDetector(
                    onTap: navigateToSignUp,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8
                      ),
                      child: const Text("Sign up.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),),
                    ),
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
