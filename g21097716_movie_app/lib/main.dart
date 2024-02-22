import 'package:cinematic_insights/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:cinematic_insights/colors.dart';




void main() async
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cinematic Insights',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colours.scaffoldBgColor,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}