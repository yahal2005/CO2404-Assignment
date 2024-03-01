import 'package:cinematic_insights/Widgets/customTextField.dart';
import 'package:cinematic_insights/colors.dart';
import 'package:cinematic_insights/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget
{
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void SignUserIn(BuildContext context) async
  {
    showDialog(
      context: context,
      builder: (context)
      {
        return const Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.amber)),
        );
      }
    );
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text,
      );
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } 
    on FirebaseAuthException catch(error)
    {
      Navigator.pop(context);
      if(error.code == 'user-not-found')
      {
        errorMessage(context,"Incorrect Email");
      }
      else if(error.code == 'wrong-password')
      {
        errorMessage(context,"Incorrect Password");
      }
    }
  }

  void errorMessage (BuildContext context, String errorText)
  {
    showDialog(
      context: context, 
      builder: (context)
      {
        return AlertDialog(
          title: Text(errorText),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context)
  {
    final Size screenSize = MediaQuery.of(context).size;  
    return  Scaffold(
      backgroundColor: Colours.scaffoldBgColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/logo.png",
                width: screenSize.width * 0.78,
                height: screenSize.height * 0.28,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
              //logo

              const SizedBox(height: 25),

              const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )
              ),

              const SizedBox(height: 20),

              const Text(
                'Sign in to continue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
                )
              ),

              const SizedBox(height: 20),

              CustomTextField(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
              ),
              //Text Field to enter the username

              const SizedBox(height: 10),

              CustomTextField(
                controller: passwordController,
                hintText: "Password",
                obscureText: true,
              ),
              //Text Field to enter the password

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => SignUserIn(context),
                child: Container(
                  height: 40,
                  width: 250,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                  color:const Color.fromRGBO(253, 203, 74, 1.0),
                  borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                  )
                ),
              ),
              //Sign In button

              SizedBox(height: screenSize.height*0.05),

              const Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.white,
                    )
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text("Or continue with", style: TextStyle(color: Colors.white),),
                  ),

                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.white,
                    )
                  )
                ],
              ),

              SizedBox(height: screenSize.height*0.05),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey[200],
                    ),
                    child: Image.asset("assets/googleIcon.jpg", height: 40), 
                  ),
                  //Google Sign In button
                ] 
              )

            ],),
        ),
      )
    );
  }
}