import 'package:flutter/material.dart';
import 'package:cinematic_insights/Widgets/MovieSlider.dart';
import 'package:cinematic_insights/models/movieClass.dart';
import 'package:cinematic_insights/api/api.dart';

class HomeScreen extends StatefulWidget 
{
  const HomeScreen({super.key});

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
  void initState()
  {
    super.initState();
    currentlyPlaying = Api().getCurrentlyPlaying();//calling the movies that are currently playing in the cinema
    trendingYr = Api().getPopular();
    highestGrossing = Api().getHighestGrossing();
    childrenFriendly = Api().getChildrenFriendly();
    onTv = Api().getOnTv();
  }

  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
        children: [
          Image.asset(
            "assets/logo.png",
            width: screenSize.width *0.78,
            height: screenSize.height*0.28,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
          //Logo
          Padding(
              padding: EdgeInsets.fromLTRB(
                0.125* screenSize.width,
                0.03* screenSize.height,
                0.125* screenSize.width,
                0.03* screenSize.height
              ),
              child: Container(
                height: 0.05*screenSize.height,
                width : 0.5*screenSize.width,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                  // Handle search input changes
                  },
                ),
              ),
            ),
          //Search Bar
          SizedBox(
            height : screenSize.height*0.05,
            width : screenSize.width *1,
            child: const TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
          
              tabs:[
                Tab(text: "Movie"),
                Tab(text: "TV"),
                Tab(text: "Watch-List")
              ],
          
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromRGBO(253, 203, 74, 1.0),
                    width: 4.0,
                  )
                )
              ),
            ),
          ),           
          //The Tab Bar
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    child: FutureBuilder(
                      future: currentlyPlaying,
                      builder: (context, snapshot)
                      {
                        if (snapshot.hasError)
                        {
                          return Center(child: Text(snapshot.error.toString()));
                        }
                        else if(snapshot.hasData)
                        {
                          return MovieSlider(category: "What's on at the cinema?",snapshot: snapshot,);
                        }
                        else
                        {
                          return const Center(child: CircularProgressIndicator(),);
                        }
                      }
                    ),
                  ),
                  //What's on Cinema?
                  SizedBox(
                    child: FutureBuilder(
                      future: trendingYr,
                      builder: (context, snapshot)
                      {
                        if (snapshot.hasError)
                        {
                          return Center(child: Text(snapshot.error.toString()));
                        }
                        else if(snapshot.hasData)
                        {
                          return MovieSlider(category: "What are the best movies this year?",snapshot: snapshot,);
                        }
                        else
                        {
                          return const Center(child: CircularProgressIndicator(),);
                        }
                      }
                    ),
                  ),
                  // What are the best movies this year?
                  SizedBox(
                    child: FutureBuilder(
                      future: highestGrossing,
                      builder: (context, snapshot)
                      {
                        if (snapshot.hasError)
                        {
                          return Center(child: Text(snapshot.error.toString()));
                        }
                        else if(snapshot.hasData)
                        {
                          return MovieSlider(category: "What are the highest grossing movies of all time?",snapshot: snapshot,);
                        }
                        else
                        {
                          return const Center(child: CircularProgressIndicator(),);
                        }
                      }
                    ),
                  ),
                  //  What are the highest grossing movies of all time?
                  SizedBox(
                    child: FutureBuilder(
                      future: childrenFriendly,
                      builder: (context, snapshot)
                      {
                        if (snapshot.hasError)
                        {
                          return Center(child: Text(snapshot.error.toString()));
                        }
                        else if(snapshot.hasData)
                        {
                          return MovieSlider(category: "Children-friendly movies",snapshot: snapshot,);
                        }
                        else
                        {
                          return const Center(child: CircularProgressIndicator(),);
                        }
                      }
                    ),
                  ),
                  // Children-friendly movies
                  SizedBox(
                    child: FutureBuilder(
                      future: onTv,
                      builder: (context, snapshot)
                      {
                        if (snapshot.hasError)
                        {
                          return Center(child: Text(snapshot.error.toString()));
                        }
                        else if(snapshot.hasData)
                        {
                          return MovieSlider(category: "What's on TV tonight?",snapshot: snapshot,);
                        }
                        else
                        {
                          return const Center(child: CircularProgressIndicator(),);
                        }
                      }
                    ),
                  ),
                  // What's on TV tonight?


                  //MovieSlider(category: "Watch-List"),
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