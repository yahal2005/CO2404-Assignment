import 'package:cinematic_insights/Widgets/back_button.dart';
import 'package:cinematic_insights/api/api.dart';
import 'package:cinematic_insights/colors.dart';
import 'package:cinematic_insights/models/movieClass.dart';
import 'package:cinematic_insights/screens/details_screen.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryScreen extends StatefulWidget {
  final String category; // Add this parameter

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
  static const String apiKey = '?api_key=3c749db8d5e8d99a3e62389eff41fba3';

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    allMoviesDisplayed = [];
    currentPage = 1;
    UpdateMovies();
    
    
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        UpdateMovies();
      }
    });
  }

  Future<void> UpdateMovies() async {
    try {
      List<Movie> updatedMoviesList = await Api().fetchAllMoviesWithPage(currentPage, widget.category);
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
     String?  currentlySelected ;
     return Scaffold(
      appBar: AppBar(
        leading: BackBtn(), 
        backgroundColor: Colours.scaffoldBgColor,
      ),
      body: Column(
          children: [
            Image.asset(
              "assets/logo.png",
              width: screenSize.width * 0.78,
              height: screenSize.height * 0.28,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                0.125 * screenSize.width,
                0.03 * screenSize.height,
                0.125 * screenSize.width,
                0.03 * screenSize.height,
              ),
              child: Container(
                height: 0.05 * screenSize.height,
                width: 0.5 * screenSize.width,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    // Handle search input changes
                  },
                ),
              ),
            ),

            Row(
              children:[
                SizedBox(width: screenSize.width*0.02),
                Text(
                  (widget.category),
                  style: GoogleFonts.aBeeZee(
                  fontSize: 20,
                  decoration: TextDecoration.underline,
                  color:const Color.fromRGBO(253, 203, 74, 1.0),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                SizedBox (width: screenSize.width*0.02),
                Text(
                  "Sort by     ",
                  style: GoogleFonts.aBeeZee(
                  fontSize: 15,
                  color:Color.fromARGB(255, 252, 252, 252),
                  ),
                ),
                SizedBox(
                  height: 50, 
                  child: DropdownButton<String>(
                    value: currentlySelected,
                    onChanged: (String? newChoice) {
                      setState(() {
                        currentlySelected = newChoice;
                      });
                    },
                    itemHeight: 50, 
                    items: <String>['Ascending Order', 'Descending Order', 'Popularity']
                        .map<DropdownMenuItem<String>>((String choice) {
                      return DropdownMenuItem<String>(
                        value: choice,
                        child: SizedBox(
                          height: 50, 
                          child: Center(
                            child: Text(choice),
                          ),
                        ),
                      );
                    }).toList(),
                    hint: const Text("Ascending Order"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

           Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: allMoviesDisplayed.length,
                itemBuilder: (context, index) {
                  Movie movie = allMoviesDisplayed[index];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    leading: SizedBox(
                      //height: 300,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          width: screenSize.width*0.25,
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${index + 1}. ${movie.title}",
                          style: GoogleFonts.aBeeZee(
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        SizedBox(height: 5), // Add space between title and subtitle
                        Text(
                          movie.overview,
                          style: GoogleFonts.aBeeZee(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: ((context) => DetailsScreen(movie:movie ))));
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

}