import 'dart:typed_data';
import 'package:app/resources/auth_methods.dart';
import 'package:app/screens/dashboard_screen.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/utils/colors.dart';
import 'package:app/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({ Key? key }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }


  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex: 2,),
              Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900
                ),
              ),
              SizedBox(height: 18,),
              Text(
                "Please enter your information below in order to login to your account",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 18,),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                          backgroundColor: Colors.red,
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://i.stack.imgur.com/l60Hf.png'),
                          backgroundColor: Colors.red,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: () {
                        print("Ok");
                        selectImage();
                      },
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              
              SizedBox(height: 32,),
              Row(
                children: [
                  Text(
                    "Username"
                  ),
                ],
              ),
              SizedBox(height: 18,),
              TextFieldInput(
                hintText: 'Enter your username',
                textInputType: TextInputType.emailAddress,
                textEditingController: _usernameController,
              ),
              SizedBox(height: 18,),
              Row(
                children: [
                  Text(
                    "Email address"
                  ),
                ],
              ),
              SizedBox(height: 18,),
              TextFieldInput(
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Text(
                    "Password"
                  ),
                ],
              ),
              SizedBox(height: 18,),
              TextFieldInput(
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                isPass: true,
              ),
              SizedBox(height: 24,),
              InkWell(
                child: Container(
                  child: !_isLoading
                      ? const Text(
                          'Sign up',
                          style: TextStyle(
                            color: mobileBackgroundColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      : const CircularProgressIndicator(
                          color: mobileBackgroundColor,
                        ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: blueColor,
                  ),
                ),
                onTap: () async{
                  String res = await AuthMethods().signUpUser(
                    email: _emailController.text, 
                    password: _passwordController.text, 
                    username: _usernameController.text, 
                    file: _image!
                  );
                  if(res == 'success') {
                     Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LoginScreen()
                      )
                    );
                  }else {
                    showSnackBar(context, res);
                  }
                }
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text(
                      'You have an account?',
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                    },
                    
                    child: Container(
                      child: const Text(
                        ' Signin.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: blueColor
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18,)
            ],
          ),
        ),
      ),
    );
  }
}