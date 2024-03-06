import 'package:cinematic_insights/api/api.dart';
import 'package:cinematic_insights/models/movieClass.dart';
import 'package:cinematic_insights/screens/movie_details_screen.dart';
import 'package:cinematic_insights/screens/watchlist_category_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyList extends StatefulWidget
{
  const MyList({super.key});

  @override
  State <MyList> createState() => MyListState();
  
}

Future<List<Movie>> getWatchList() async 
{
  try {
    CollectionReference watchListRef = FirebaseFirestore.instance.collection('WatchList');

    QuerySnapshot querySnapshot = await watchListRef.get();

    List<Movie> watchList = [];

    for (DocumentSnapshot doc in querySnapshot.docs) {
      int? id = int.tryParse(doc.id);
      if (id != null) 
      {
        Movie movie = await Api().getMovieDetails(id.toString());
        watchList.add(movie);
      }
    }

    return watchList;
  } catch (e) {
    return [];
  }
}



class MyListState extends State<MyList>
{
  @override
  Widget build(BuildContext context)
  {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder<List<Movie>>(
        future: getWatchList(),
        builder: (context, snapshot) 
        {
          if (snapshot.connectionState == ConnectionState.waiting) 
          {
            return Center(child: CircularProgressIndicator());

          } else if (snapshot.hasError) 
          {
            
            return Center(child: Text('Error: ${snapshot.error}'));

          } 
          else
          {
  
            List<Movie> watchList = snapshot.data ?? [];
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                          
                        Row(
                          children: [
                            SizedBox(width: screenSize.width * 0.02),
                            Text(
                              "Watch List",
                              style: GoogleFonts.aBeeZee(
                                fontSize: 20,
                                decoration: TextDecoration.underline,
                                color: const Color.fromRGBO(253, 203, 74, 1.0),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20), 

                        Row(
                          children: [
                            SizedBox(
                                height: 0.2 * screenSize.height,
                                width: screenSize.width,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: watchList.length,
                                  itemBuilder: (context, itemIndex) {
                                    if (itemIndex < 10 && itemIndex < watchList.length) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MoviesDetailsScreen(
                                                movie: watchList[itemIndex],
                                              ),
                                            ),
                                          );
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
                                            child: Container(
                                              width: 125,
                                              height: double.infinity,
                                              child: Image.network(
                                                'https://image.tmdb.org/t/p/w500${watchList[itemIndex].posterPath}',
                                                filterQuality: FilterQuality.high,
                                                fit: BoxFit.cover,
                                                height: 200,
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
                                            Navigator.push(context, MaterialPageRoute(builder: ((context) => WatchListCategoryScreen(watchList: watchList))));
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
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]
              ),
            );
          }
        },
      ),
    );
  }

}