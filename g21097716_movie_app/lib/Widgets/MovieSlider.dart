import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cinematic_insights/screens/details_screen.dart';

class MovieSlider extends StatelessWidget
{
  const MovieSlider({super.key, required this.category, required this.snapshot});

  final String category;
  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context)
  {
    final Size screenSize = MediaQuery.of(context).size;

    print("Width: ${screenSize.width}");
    print("Height: ${screenSize.height}");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Row(
          children:[
            SizedBox(width: screenSize.width*0.02),
            Text(
              (category),
              style: GoogleFonts.aBeeZee(
              fontSize: 20,
              decoration: TextDecoration.underline,
              color: Color.fromRGBO(253, 203, 74, 1.0),
              ),
            ),
            
          ],
        ),

        const SizedBox(height: 20),
        SizedBox(
          height: 0.2*screenSize.height, 
          width: double.infinity,
          child:ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: 10,
            itemBuilder:(context, itemIndex){
              return GestureDetector(
                onTap:()
                {
                  Navigator.push(context, MaterialPageRoute(builder: ((context) => DetailsScreen(movie: snapshot.data[itemIndex]))));
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    30,
                    0,
                    30,
                    0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 125,
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${snapshot.data[itemIndex].posterPath}',
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ]
    );
    
  }
}