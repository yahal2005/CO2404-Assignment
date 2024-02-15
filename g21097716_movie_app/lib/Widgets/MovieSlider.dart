import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        const SizedBox(height: 32),
        Row(
          children:[
            SizedBox(width: screenSize.width*0.02),
            Text(
              (category),
              style: GoogleFonts.aBeeZee(
              fontSize: 20,
              ),
            ),
            
          ],
        ),

        const SizedBox(height: 32),
        SizedBox(
          height: 0.25*screenSize.height, 
          width: double.infinity,
          child:ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: 10,
            itemBuilder:(context, index){
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  30,
                  15,
                  30,
                  15,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 125,
                    child: Image.network(
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover,
                      'https://image.tmdb.org/t/p/w500${snapshot.data[index].posterPath}'
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