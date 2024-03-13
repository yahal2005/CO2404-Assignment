import 'package:cinematic_insights/Widgets/customTextField.dart';
import 'package:cinematic_insights/colors.dart';
import 'package:cinematic_insights/models/authenticationClass.dart';
import 'package:cinematic_insights/models/movieClass.dart';
import 'package:cinematic_insights/screens/home_screen.dart';
import 'package:cinematic_insights/screens/LoginScreens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cinematic_insights/Network/dependency_injection.dart';

// ignore: must_be_immutable
class loginRegisterPage extends StatefulWidget
{
  loginRegisterPage({
    super.key,
    required this.currentlyPlaying,
    required this.trendingYr,
    required this.highestGrossing,
    required this.childrenFriendly,
    required this.onTv,
  });

  Future<List<Movie>> currentlyPlaying;
  Future<List<Movie>> trendingYr;
  Future<List<Movie>> highestGrossing;
  Future<List<Movie>> childrenFriendly;
  Future<List<Movie>> onTv;

  @override
  State<loginRegisterPage> createState() => loginRegisterState();
}

class loginRegisterState extends State<loginRegisterPage>
{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmedPasswordController = TextEditingController();

  void initState() {
    super.initState(); 
    DependencyInjection.init();
  }

  void SignUserUp(BuildContext context) async
  {
    showDialog(
      context: context,
      builder: (context)
      {
        return const Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.amber)),
        );
        //Until email and password are validated
      }
    );
    try{
      if (passwordController.text == confirmedPasswordController.text)
      {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, 
          password: passwordController.text,
        );
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen(
            currentlyPlaying: widget.currentlyPlaying,
            trendingYr: widget.trendingYr,
            highestGrossing: widget.highestGrossing,
            childrenFriendly: widget.childrenFriendly,
            onTv: widget.onTv,

          )),
        );
        //If passwords match 
      }
      else
      {
        errorMessage(context, "Passwords don't match!");
      }
      
    } 
    on FirebaseAuthException catch(error)
    {
      Navigator.pop(context);
      if(error.message == 'The supplied auth credential is incorrect, malformed or has expired.')
      {
        errorMessage(context,"Incorrect Email or Password");
      }
      else if(error.message == 'A non-empty password must be provided')
      {
        errorMessage(context,"Please enter the password");
      }
      else if(error.message == "The email address is badly formatted.")
      {
        errorMessage(context,"Please enter a valid email address");
      }
    }
    // If passwords do not match
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
  //Error message when invalid email or password is entered

  @override
  Widget build(BuildContext context)
  {
    final Size screenSize = MediaQuery.of(context).size;  
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colours.scaffoldBgColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(height:screenSize.height*0.05),

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
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )
                ),
      
                const SizedBox(height: 20),
      
                const Text(
                  "Let's create an account for you",
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
                //Text Field to enter the email
      
                const SizedBox(height: 10),
      
                CustomTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
                //Text Field to enter the password

                const SizedBox(height: 10),
      
                CustomTextField(
                  controller: confirmedPasswordController,
                  hintText: "Confirm Password",
                  obscureText: true,
                ),
                //Text Field to confirm the password
      
                const SizedBox(height: 20),
      
                GestureDetector(
                  onTap: () => SignUserUp(context),
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
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                    )
                  ),
                ),
                //Sign Up button
      
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
                    GestureDetector(
                      onTap: () => AuthService().signInWithGoogle(),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[200],
                        ),
                        child: Image.asset("assets/googleIcon.jpg", height: 40), 
                      ),
                    ),
                    //Google Sign In button
                  ] 
                ),

                SizedBox(height: screenSize.height*0.05),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width:4),
                    GestureDetector(
                      onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: ((context) => LoginScreen(currentlyPlaying: widget.currentlyPlaying,trendingYr: widget.trendingYr,highestGrossing: widget.highestGrossing,childrenFriendly: widget.childrenFriendly,onTv: widget.onTv))));
                      },
                      child: const Text(
                        'Login now',
                        style : TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    )
                  ],
                  //Back to login page
                )
              ],),
          ),
        ),
      )
    );
  }
}