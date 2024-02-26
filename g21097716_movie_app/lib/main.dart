import 'package:cinematic_insights/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:cinematic_insights/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';




void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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