import 'package:cinematic_insights/colors.dart';
import 'package:cinematic_insights/Widgets/back_button.dart';
import 'package:cinematic_insights/models/genreClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cinematic_insights/models/movieClass.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cinematic_insights/api/api.dart';



class DetailsScreen extends StatefulWidget 
{
  const DetailsScreen({super.key, required this.movie});
  final Movie movie;
  State<DetailsScreen> createState() => _DetailsScreenState();
}


class _DetailsScreenState extends State<DetailsScreen> 
{
  late Future<List<Genre>> AvailableGenre;
  
  void initState() {
    super.initState();
    initializeData(); 
  }

  Future<void> initializeData() async {
    AvailableGenre = Api().getGenres();
  }

  Future<List<String>> GetTheGenres() async {
    final List<String> genreNames = [];
    final List<String> genreIdsInMovie = widget.movie.genreIds.map((value) => value.toString()).toList();
    
    List<Genre> genres = await AvailableGenre;
    
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

  Future addToWatchList(int Id) async
  {
    await FirebaseFirestore.instance.collection('MyList').add(
      {
        'ID': Id.toString(),
      }
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverAppBar(
                leading: BackBtn(),
                backgroundColor: Colours.scaffoldBgColor,
                pinned: true,
                floating: true,
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.fromLTRB(72, 0, 72, 72),
                    child: Column(
                      children: [
                        Align(
                          alignment:Alignment.centerLeft,
                          child: Text(
                            widget.movie.title,
                            style: GoogleFonts.belleza(
                              fontSize: 35,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(253, 203, 74, 1.0),
                            ),
                          ),
                        ),
                        //Movie Title
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
                                return CircularProgressIndicator();
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
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: screenSize.width*0.75,
                  child: ElevatedButton.icon(
                    onPressed: ()
                     {
                      addToWatchList(widget.movie.movieID);
                     },
                    icon: const Icon(
                      Icons.add,
                      color: Colours.scaffoldBgColor,
                      size: 25,
                    ),
                    label: Text(
                      'Add to watchlist',
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
                  ),
                ),
                Container(
                  height: 20, 
                  color: Colors.black,
                ),
              ],
            ),
          ),
          //Add to watchlist button
        ],
      ),
    );
  
  }
}

