import 'package:cinematic_insights/Widgets/back_button.dart';
import 'package:cinematic_insights/api/api.dart';
import 'package:cinematic_insights/colors.dart';
import 'package:cinematic_insights/models/movieClass.dart';
import 'package:cinematic_insights/screens/movie_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cinematic_insights/Network/dependency_injection.dart';

class CategoryScreen extends StatefulWidget {
  final String category; 
  CategoryScreen({required this.category});
  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> 
{
  late ScrollController scrollController;
  late List<Movie> allMoviesDisplayed;
  late int currentPage;
  late TextEditingController searchController;
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
    scrollController = ScrollController();
    allMoviesDisplayed = [];
    currentPage = 1;
    UpdateMovies();
    DependencyInjection.init();
    
    
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        UpdateMovies();
      }
    });
  }

  Future<void> UpdateMovies() async
  {
    try {
      List<Movie> updatedMoviesList = await Api().fetchAllMoviesWithPage(currentPage, widget.category, dropdownValue);
      allMoviesDisplayed.addAll(updatedMoviesList);
      currentPage++;

      setState(() {});
    } catch (e) {
      // Handle error fetching more movies
    }
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
                  (widget.category),
                  style: GoogleFonts.aBeeZee(
                  fontSize: 20,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  color:const Color.fromRGBO(253, 203, 74, 1.0),
                  ),
                ),
              ],
            ),

            Divider (thickness: 0.5,color: Colors.white ),

            if (widget.category == " Children-friendly movies")
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
                      allMoviesDisplayed = [];
                      currentPage = 1;
                      UpdateMovies();

                    },
                    value: dropdownValue,
                  )
                ],
              ),

            const SizedBox(height: 15),

            Expanded(
              child: Row(
                children: [
                  SizedBox(width: screenSize.width * 0.1),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: allMoviesDisplayed.length,
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        Movie movie = allMoviesDisplayed[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MoviesDetailsScreen(movie: movie),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 8, bottom: 8, right: screenSize.width*0.1),
                            height: 150,
                            width: screenSize.width * 0.8,
                            decoration: const BoxDecoration(
                              color: const Color.fromRGBO(253, 203, 74, 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
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
                                            style: const TextStyle(color: Colors.black,decoration: TextDecoration.underline, fontWeight: FontWeight.bold,fontSize: 14),
                                          ),
                                        ),
                                        Container(
                                          width: screenSize.width * 0.45,
                                          height: 80,
                                          child: Text(
                                            "${croppedOverview(movie.overview)}",
                                            style: TextStyle(color: Colors.black, fontSize: 14),
                                          ),
                                        ),
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
                                      ],
                                    ),
                                  ),
                                )
                              ],
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