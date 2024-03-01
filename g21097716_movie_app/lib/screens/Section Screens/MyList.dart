import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyList extends StatefulWidget
{
  const MyList({super.key});

  @override
  State <MyList> createState() => MyListState();
  
}

class MyListState extends State<MyList>
{
  @override
  Widget build(BuildContext context)
  {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column (
       children: [
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        SizedBox(width: screenSize.width * 0.02),
                        Text(
                          ("Watch List"),
                          style: GoogleFonts.aBeeZee(
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                            color: const Color.fromRGBO(253, 203, 74, 1.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
       ],
      ),  
    );
  }

}