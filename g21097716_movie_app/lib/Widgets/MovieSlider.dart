import 'package:cinematic_insights/screens/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cinematic_insights/screens/movie_details_screen.dart';

class MovieSlider extends StatelessWidget
{
  const MovieSlider({super.key, required this.category, required this.snapshot});

  final String category;
  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context)
  {
    final Size screenSize = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        
        
        Padding(
          padding: EdgeInsets.only(left:screenSize.width*0.02),
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Text(
              (category),
              style: GoogleFonts.aBeeZee(
                fontWeight: FontWeight.bold,
                color:const Color.fromRGBO(253, 203, 74, 1.0),
              ),
            ),
          ),
        ),
        //Displays the Category Title

        const SizedBox(height: 20),
        SizedBox(
          height: 0.2*screenSize.height, 
          width: double.infinity,
          child:ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: 11,
            itemBuilder:(context, itemIndex){
              if(itemIndex < 10) // Displays 10 movie posters and an arrow at the end which will lead to a screen containing all the movies of the relevant category
              {
                return GestureDetector(
                  onTap:()
                  {
                    String type = "movie";
                    if (category == "What's on TV tonight?")
                    {
                      type = "TvShow";
                    }
                    //TvShows are not allowed to be added to the watchlist
                    Navigator.push(context, MaterialPageRoute(builder: ((context) => MoviesDetailsScreen(movie: snapshot.data[itemIndex], type: type,))));
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
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
                    // Movie poster
                  ),
                );
              }
              else
              {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context) => CategoryScreen(category: category,)));
                    },
                    child: Icon(Icons.arrow_forward, color:  Colors.black,size: 35),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(15),
                      backgroundColor: const Color.fromRGBO(253, 203, 74, 1.0),
                    ),
                  ),
                );
                //Arrow Button
              }
              
            },
          ),
        ),
          
      ],
    );
  }
}
