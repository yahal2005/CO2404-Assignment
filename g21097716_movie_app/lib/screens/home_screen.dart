
import 'package:cinematic_insights/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:cinematic_insights/Widgets/MovieSlider.dart';
import 'package:cinematic_insights/Widgets/customSearchBar.dart';
import 'package:cinematic_insights/models/movieClass.dart';
import 'package:cinematic_insights/api/api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:cinematic_insights/screens/details_screen.dart';

class HomeScreen extends StatefulWidget 
{
  HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> currentlyPlaying;
  late Future<List<Movie>> trendingYr;
  late Future<List<Movie>> highestGrossing;
  late Future<List<Movie>> childrenFriendly;
  late Future<List<Movie>> onTv;

  @override
  void initState() {
    super.initState();
    initializeData(); // Initialize the Future for watchListBox
  }

  Future<void> initializeData() async {
    currentlyPlaying = Api().getCurrentlyPlaying();
    trendingYr = Api().getPopular();
    highestGrossing = Api().getHighestGrossing();
    childrenFriendly = Api().getChildrenFriendly();
    onTv = Api().getOnTv();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Logged', true);
  }

  Future<void > loggedOut(BuildContext context) async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Logged', false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: Builder( // Wrap with Builder
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),

        drawer: Drawer(
          width: screenSize.width*0.25,
          child: Column(
            children: 
            [
              SizedBox(height: screenSize.height*0.9),

              Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  title: Text('Logout'),
                  onTap: ()
                  {
                    loggedOut(context);
                  },
                ),
              ),
            ],
          ),
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
                0,
                0.125 * screenSize.width,
                0.03 * screenSize.height,
              ),
              child: const searchBar(),
            ),
            SizedBox(
              height: screenSize.height * 0.05,
              width: screenSize.width * 1,
              child: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: "Movie"),
                  Tab(text: "TV"),
                  Tab(text: "Watch-List")
                ],
                indicator: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color.fromRGBO(253, 203, 74, 1.0),
                      width: 4.0,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      child: FutureBuilder(
                        future: currentlyPlaying,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text(snapshot.error.toString()));
                          } else if (snapshot.hasData) {
                            return MovieSlider(category: "What's on at the cinema?", snapshot: snapshot);
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      child: FutureBuilder(
                        future: trendingYr,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text(snapshot.error.toString()));
                          } else if (snapshot.hasData) {
                            return MovieSlider(category: "What are the best movies this year?", snapshot: snapshot);
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      child: FutureBuilder(
                        future: highestGrossing,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text(snapshot.error.toString()));
                          } else if (snapshot.hasData) {
                            return MovieSlider(category: "What are the highest grossing movies of all time?", snapshot: snapshot);
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      child: FutureBuilder(
                        future: childrenFriendly,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text(snapshot.error.toString()));
                          } else if (snapshot.hasData) {
                            return MovieSlider(category: "Children-friendly movies", snapshot: snapshot);
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      child: FutureBuilder(
                        future: onTv,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text(snapshot.error.toString()));
                          } else if (snapshot.hasData) {
                            return MovieSlider(category: "What's on TV tonight?", snapshot: snapshot);
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
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
                          const SizedBox(height: 20),
                          /*SizedBox(
                            height: 0.2 * screenSize.height,
                            width: double.infinity,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: watchListBox.length,
                              itemBuilder: (context, index) {
                                if (index < 10) {
                                  String movieID = watchListBox.getAt(index) as String;
                                  Movie movie = Api().getMovieDetails(movieID) as Movie;
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => DetailsScreen(movie: movie)),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: SizedBox(
                                          width: 125,
                                          child: Image.network(
                                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                            filterQuality: FilterQuality.high,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Handle button press action
                                      },
                                      child: Icon(Icons.arrow_forward, color: Colors.black, size: 35),
                                      style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(15),
                                        backgroundColor: const Color.fromRGBO(253, 203, 74, 1.0),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}