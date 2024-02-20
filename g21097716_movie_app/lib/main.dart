import 'package:cinematic_insights/api/api.dart';
import 'package:cinematic_insights/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:cinematic_insights/colors.dart';
import 'package:hive_flutter/hive_flutter.dart';



void main() async{
  await Hive.initFlutter();
  var genreBox = await Hive.openBox('GenreBox');
  print(genreBox.keys.toList());


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