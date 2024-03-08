import 'package:cinematic_insights/Widgets/back_button.dart';
import 'package:cinematic_insights/colors.dart';
import 'package:cinematic_insights/models/movieClass.dart';
import 'package:cinematic_insights/screens/movie_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cinematic_insights/Network/dependency_injection.dart';

class WatchListCategoryScreen extends StatefulWidget {
  final List<Movie> watchList;
  WatchListCategoryScreen({required this.watchList});
  @override
  WatchListCategoryScreenState createState() => WatchListCategoryScreenState();
}

class WatchListCategoryScreenState extends State<WatchListCategoryScreen> 
{
  String dropdownValue = "Asc";

  String croppedOverview(String Overview)
  {
    List<String> Words = Overview.split(' ');
    if (Words.length <= 20)
    {
      return Overview;
    }
    else
    {
      List<String> croppedList = Words.sublist(0, 20);
      return '${croppedList.join(' ')}.....';
    }
  }

  @override
  void initState() {
    super.initState();
    DependencyInjection.init();
  }

  @override
  Widget build(BuildContext context) 
  {
     final Size screenSize = MediaQuery.of(context).size;
     return Scaffold(
      appBar: AppBar(
        leading: BackBtn(), 
        backgroundColor: Colours.scaffoldBgColor,
      ),
      body: Column(
          children: [
            Image.asset(
              "assets/logo.png",
              width: screenSize.width * 0.65,
              height: screenSize.height * 0.2,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
            Divider (thickness: 0.5,color: Colors.white ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Text(
                  ("Watch List"),
                  style: GoogleFonts.aBeeZee(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color:const Color.fromRGBO(253, 203, 74, 1.0),
                  ),
                ),
              ],
            ),

            Divider (thickness: 0.5,color: Colors.white ),

            Row(
              children: [
                SizedBox (width: screenSize.width*0.1),
                Text(
                  "Sort by     ",
                  style: GoogleFonts.aBeeZee(
                  fontSize: 15,
                  color:Color.fromARGB(255, 252, 252, 252),
                  ),
                ),
                DropdownButton(
                  items: const[
                    DropdownMenuItem(child: Text("Alphabetical Order"), value: "Asc"),
                    DropdownMenuItem(child: Text("Popularity Ascending"), value: "PopAsc"),
                    DropdownMenuItem(child: Text("Popularity Descending"), value: "PopDesc")
                  ],
                  onChanged: (String? newValue){
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  value: dropdownValue,
                )
              ],
            ),

            const SizedBox(height: 15),

            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.watchList.length,
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        Movie movie = widget.watchList[index];
                        return GestureDetector(
                          onTap: () {
                            String type = "movie";
                            Navigator.push(context, MaterialPageRoute(builder: ((context) => MoviesDetailsScreen(movie: movie, type: type,))));
                          },
                          //Navigates to selected movie's detail screen

                          child: FractionallySizedBox(
                            widthFactor: 0.85,
                            child: Container(
                              margin: const EdgeInsets.only(top: 8, bottom: 8),
                              height: 190,
                              width: screenSize.width * 0.75,
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(253, 203, 74, 1.0),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              //Box with Yellow background
                          
                              child: Row(
                                children: [
                                  Container(
                                    width: 125,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  //Movie Poster
                          
                                  const SizedBox(width: 20),
                          
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Column(
                                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 32,
                                            width: screenSize.width*0.45,
                                            child: Text(
                                              "${index+1}. ${movie.title}",
                                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          // Movie title and Search result number
                          
                                          Container(
                                            width: screenSize.width * 0.45,
                                            height: 110,
                                            child: Text(
                                              "${croppedOverview(movie.overview)}",
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          ),
                                          //Overview
                          
                                          Container(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.black,
                                                  size: 20,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  "${movie.voteAverage.toStringAsFixed(1)}/10",
                                                  style: TextStyle(color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                          //Rating
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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