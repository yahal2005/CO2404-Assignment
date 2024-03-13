import 'package:cinematic_insights/colors.dart';
import 'package:cinematic_insights/Widgets/back_button.dart';
import 'package:cinematic_insights/models/genreClass.dart';
import 'package:cinematic_insights/models/personClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cinematic_insights/models/movieClass.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cinematic_insights/api/api.dart';
import 'package:cinematic_insights/Network/dependency_injection.dart';



class MoviesDetailsScreen extends StatefulWidget 
{
  const MoviesDetailsScreen({super.key, required this.movie, required this.type});
  final Movie movie;
  final String type;
  @override
  State<MoviesDetailsScreen> createState() => DetailsScreenState();
}


class DetailsScreenState extends State<MoviesDetailsScreen> 
{
  late Future<List<Genre>> availableGenre;
  late Future<List<Person>> crew;
  late User user;
  String email = '';
  @override
  void initState() {
    super.initState();
    initializeData(); 
    user = FirebaseAuth.instance.currentUser!;
    email = user.email ?? '';
    DependencyInjection.init();
  }


  Future<void> initializeData() async {
    availableGenre = Api().getGenres();
    crew = Api().getMovieCast((widget.movie.movieID).toString());
  }
  //gets all the genres
   
  Future<List<int>> getWatchList() async 
  {
    try {
      CollectionReference watchListRef = FirebaseFirestore.instance.collection('WatchList${email}');

      QuerySnapshot querySnapshot = await watchListRef.get();

      List<int> watchList = [];

      for (DocumentSnapshot doc in querySnapshot.docs) {
        int? id = int.tryParse(doc.id);
        if (id != null) 
        {
          watchList.add(id);
        }
      }

      return watchList;
    } catch (e) {
      return [];
    }
  }
  //Gets the movies in the watchlist from firebase

  Future<bool> checkWatchList(int Id) async
  {
    List<int> WatchList = await getWatchList();
    bool found = false;
    int x = 0;
    while(x < WatchList.length && found == false)
    {
      if (WatchList[x] == Id)
      {
        found = true;
      }
      x++;
    }
    return found;
  }
  //Checks if selected movie is already in the watchlist

  Future<List<String>> GetTheGenres() async {
    final List<String> genreNames = [];
    final List<String> genreIdsInMovie = widget.movie.genreIds.map((value) => value.toString()).toList();
    
    List<Genre> genres = await availableGenre;
    
    for (int count = 0; count < genreIdsInMovie.length; count++) {
      bool found = false;
      int index = 0;
      while (!found && index < genres.length) {
        if (genreIdsInMovie[count] == genres[index].id.toString()) {
          genreNames.add(genres[index].name);
          found = true;
        }
        index++;
      }
    }
    
    return genreNames;
  }
  //Get the movie specific genres

  Future addToWatchList(int Id) async
  {
    await FirebaseFirestore.instance.collection('WatchList${email}').doc(Id.toString()).set({
      'ID': Id,
    });
  }
  //Add to the watchlist in the firebase

  Future removeFromWatchList(int Id) async
  {
    await FirebaseFirestore.instance.collection('WatchList${email}').doc(Id.toString()).delete();
  }
  //Remove from watchlist in the firebase

  Widget TopCastSlider() {
    return FutureBuilder<List<Person>>(
      future: crew,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(253, 203, 74, 1.0))); // Show a loading indicator while data is being fetched
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<Person> topCast = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: topCast.length > 15 ? 15 : topCast.length,
            itemBuilder: (context, index) {
              Person person = topCast[index];
              return Row(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Color.fromRGBO(253, 203, 74, 1.0),
                        backgroundImage: person.profilePath.isNotEmpty
                         ?NetworkImage("https://image.tmdb.org/t/p/w500${person.profilePath}")
                         : NetworkImage("https://media.istockphoto.com/id/1208175274/vector/avatar-vector-icon-simple-element-illustrationavatar-vector-icon-material-concept-vector.jpg?s=612x612&w=0&k=20&c=t4aK_TKnYaGQcPAC5Zyh46qqAtuoPcb-mjtQax3_9Xc="),
                        radius: 65,
                      ),
                      SizedBox(height: 8),
                      Text(
                        person.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(width:40),
                ],
              );
            },
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }
  //Actors

  @override
  Widget build(BuildContext context) 
  {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: BackBtn(),
                backgroundColor: Colours.scaffoldBgColor,
                pinned: true,
                floating: true,
                title: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.movie.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.belleza(
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(253, 203, 74, 1.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.fromLTRB(72, 0, 72, 72),
                    child: Column(
                      children: [

                        const SizedBox(height: 30),

                        SizedBox(
                          height: screenSize.height * 0.4,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(24),
                              bottomRight: Radius.circular(24),
                            ),
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                              filterQuality: FilterQuality.high,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        //Poster
                        const SizedBox(height: 20),
                        
                        SizedBox(
                          child: FutureBuilder<List<String>>(
                            future: GetTheGenres(),
                            builder: (context, snapshot) {
                              if (snapshot.data == null)
                              {
                                return CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(253, 203, 74, 1.0)));
                              }
                              else
                              {
                                List<Widget> containers = snapshot.data!.map((text) {
                                  return Container(
                                    margin: EdgeInsets.all(4),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Text(
                                      text,
                                      style: TextStyle(fontSize: 15,  color: Colors.white),
                                    ),
                                  );
                                }).toList();

                                return Wrap(
                                  alignment: WrapAlignment.start,
                                  children: containers,
                                );
                              }
                            },
                          ),
                        ),
                        //Displays the genres of the movie

                        const SizedBox(height:20),

                        Align(
                          alignment:Alignment.centerLeft,
                          child: Text(
                            widget.movie.overview,
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        //Overview
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colours.ratingColor,
                            ),
                            Text(
                              '  ${widget.movie.voteAverage.toStringAsFixed(1)}/10',
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        //Rating
                        const SizedBox(height: 20),

                        Align(
                          alignment:Alignment.centerLeft, 
                          child: Text(
                            'Release date:  ${widget.movie.releaseDate}',
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        //Release date

                        const SizedBox(height: 20),

                        if (widget.type == "movie")

                          Align(
                            alignment:Alignment.centerLeft, 
                            child: Text(
                              'Top Cast',
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                        if (widget.type == "movie")

                          Container(
                            height: 200,
                            child: TopCastSlider(),
                          )
                          //Calling Actors

                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                if (widget.type == "movie")
                  FutureBuilder(
                    future: checkWatchList(widget.movie.movieID), 
                    builder: (context,snapshot)
                    {
                      if (snapshot.connectionState == ConnectionState.waiting)
                      {
                        return Container();
                      }
                      else if (snapshot.hasError)
                      {
                        return Text("${snapshot.error}");
                      }
                      else
                      {
                        bool isOnWatchList = snapshot.data ?? false;
                        return SizedBox(
                          width: screenSize.width*0.75,
                          child: ElevatedButton.icon(
                            icon: Icon(
                              isOnWatchList ? Icons.remove : Icons.add,
                              color: Colours.scaffoldBgColor,
                              size: 25,
                            ),
                            label: Text(
                              isOnWatchList ? 'Remove from watchlist' : 'Add to watchlist',
                              style: GoogleFonts.roboto(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromRGBO(253, 203, 74, 1.0),
                              ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            onPressed: ()
                            {
                              if (isOnWatchList == false)
                              {
                                addToWatchList(widget.movie.movieID);
                              }
                              else
                              {
                                removeFromWatchList(widget.movie.movieID);
                              }
                              setState(() {
                                isOnWatchList = !isOnWatchList;
                              });
                            },
                          ),
                        );
                      }
                    }
                  ),
                  
                  Container(
                    height: 20, 
                    color: Colors.black,
                  ),
              ],
            ),
          ),
          //Add to watchlist button if not added to watchList
          // Remove from watchlist button if already added to watchlist
        ],
      ),
    );
  
  }
}

