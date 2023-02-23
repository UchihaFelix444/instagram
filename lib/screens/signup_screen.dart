import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  Uint8List? image;
  bool isLoading = false;


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    bioController.dispose();
    userNameController.dispose();
  }

  selectImage() async
  {
    Uint8List im =  await pickImage(ImageSource.gallery);
    setState(() {
      image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().signUpUser(email: emailController.text, password: passwordController.text, username: userNameController.text, bio: bioController.text, file: image!);
    if(res != "success")
      {
        showSnackBar(context, res);
      }else
        {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const ResponsiveLayout(webScreenLayout: WebScreenLayout(), mobileScreenLayout: MobileScreenLayout()),
            ),
          );
        }
    setState(() {
      isLoading = false;
    });
  }

  void navigateToLogin()
  {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
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
                SvgPicture.asset('assets/ic_instagram.svg', color: primaryColor, height: 50),
                const SizedBox(height: 12 ),
                Stack(
                  children: [
                    image != null
                     ? CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(image!),
                    ): const CircleAvatar(
                      radius: 64,
                      backgroundImage: AssetImage("assets/default_dp.jpg"),
                    ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                      onPressed: selectImage,
                      icon: Icon(Icons.add_a_photo),
                    ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                //Text field input for username
                TextFieldInput(
                  hintText: 'Enter your username',
                  textInputType: TextInputType.text,
                  textEditingController: userNameController,
                ),
                const SizedBox(height: 12),
                //Text field input for email
                TextFieldInput(
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: emailController,
                ),
                const SizedBox(height: 12),
                //Text field input for password
                TextFieldInput(
                  hintText: 'Enter your password',
                  textInputType: TextInputType.text,
                  textEditingController: passwordController,
                  isPass: true,
                ),
                const SizedBox(height: 12),
                //Text field input for bio
                TextFieldInput(
                  hintText: 'Enter your bio',
                  textInputType: TextInputType.text,
                  textEditingController: bioController,
                ),
                const SizedBox(height: 6),
                //Login
                InkWell(
                  onTap: signUpUser,
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
                    ),) : const Text('Sign up'),
                  ),
                ),
                const SizedBox(height: 6),
                Flexible(flex: 2, child: Container()),
                //Transition
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8
                      ),
                      child: const Text("Already have an account?"),
                    ),
                    GestureDetector(
                      onTap: navigateToLogin,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8
                        ),
                        child: const Text("Login",
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
