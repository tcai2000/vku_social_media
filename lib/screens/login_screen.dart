import 'package:app/resources/auth_methods.dart';
import 'package:app/screens/dashboard_screen.dart';
import 'package:app/screens/signup_screen.dart';
import 'package:app/utils/colors.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widgets/text_field_input.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // login User
  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(email: _emailController.text, password: _passwordController.text);
    if(res == 'success') {
      showSnackBar(context, res);
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => DashBoardScreen(),
      ));
    }else {
      showSnackBar(context, res);
    }
    setState(() {
      _isLoading = false;
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
              Image.asset("assets/images/logo.png"),
              SizedBox(height: 18,),
              Text(
                "Sign in Now",
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
              SizedBox(height: 64,),
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
                          'Log in',
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
                onTap: loginUser,
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
                      'Dont have an account?',
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
                      ));
                    },
                    
                    child: Container(
                      child: const Text(
                        ' Signup.',
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

