import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget 
{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            "assets/logo.png",
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "What's on at the Cinema?",
                      style: GoogleFonts.aBeeZee(fontSize: 25),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: CarouselSlider.builder(
                        itemCount: 10,
                        options: CarouselOptions(
                          height: 300,
                          autoPlay: true,
                          viewportFraction: 0.55,
                          enlargeCenterPage: true,
                          pageSnapping: true,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          autoPlayAnimationDuration: const Duration(seconds: 1),
                        ),
                        itemBuilder: (context, itemIndex, pageViewIndex) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 300,
                              width: 200,
                              color: Colors.amber,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}