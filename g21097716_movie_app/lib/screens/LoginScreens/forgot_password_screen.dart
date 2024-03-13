import "package:cinematic_insights/Widgets/back_button.dart";
import "package:cinematic_insights/Widgets/customTextField.dart";
import "package:cinematic_insights/colors.dart";
import "package:cinematic_insights/models/movieClass.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

// ignore: must_be_immutable
class ForgotPasswordScreen extends StatefulWidget
{
  ForgotPasswordScreen({
    required this.currentlyPlaying,
    required this.trendingYr,
    required this.highestGrossing,
    required this.childrenFriendly,
    required this.onTv,
    super.key
  });

  Future<List<Movie>> currentlyPlaying;
  Future<List<Movie>> trendingYr;
  Future<List<Movie>> highestGrossing;
  Future<List<Movie>> childrenFriendly;
  Future<List<Movie>> onTv;



  @override

  State<ForgotPasswordScreen> createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPasswordScreen> 
{
  final emailController = TextEditingController(); 

  void dispose()
  {
    emailController.dispose();
    super.dispose();
  }

  Future PasswordReset() async
  {
    try
    {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      // ignore: use_build_context_synchronously
      showDialog(context: context, builder: (context)
      {
        return const AlertDialog(
          content: Text("Password reset link sent! Check your email"),
        );
      });

    }on FirebaseAuthException catch(error)
    {
      // ignore: use_build_context_synchronously
      showDialog(context: context, builder: (context)
      {
        return AlertDialog(
          content: Text(error.message.toString()),
        );
      });
    }
    
  }

  @override
  Widget build(BuildContext)
  {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(

      resizeToAvoidBottomInset: false,
      backgroundColor: Colours.scaffoldBgColor,
      appBar: AppBar(
        leading: const BackBtn(), 
        backgroundColor: Colours.scaffoldBgColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child:Column(
            children: [
              Image.asset(
                "assets/logo.png",
                width: screenSize.width * 0.78,
                height: screenSize.height * 0.28,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
              //logo
        
              SizedBox(height: screenSize.height*0.1),
      
              const Text(
                'Enter Your Email and we will send you a password reset link',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              //Text
      
              SizedBox(height: screenSize.height*0.1),
      
              CustomTextField(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
              ),
              //Email 
      
              SizedBox(height: screenSize.height*0.15),
      
              MaterialButton(
                onPressed: ()
                {
                  PasswordReset();
                },
                // ignore: sort_child_properties_last
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text("Reset Password", style: TextStyle(color: Colors.black,fontSize:20,fontWeight: FontWeight.bold,)),
                ),
                color: const Color.fromRGBO(253, 203, 74, 1.0),
              ),
              //Reset password
            ]
          )
        ),
      )
    );
  }
}