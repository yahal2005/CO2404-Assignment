import 'package:cinematic_insights/colors.dart';
import 'package:cinematic_insights/Widgets/back_button.dart';
import 'package:flutter/material.dart';
import 'package:cinematic_insights/models/movieClass.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:cinematic_insights/api/api.dart';

class DetailsScreen extends StatelessWidget
{
  const DetailsScreen({super.key, required this.movie});
  final Movie movie;
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
                    padding: const EdgeInsets.fromLTRB(72, 0, 0, 72),
                    child: Column(
                      children: [
                        Align(
                          alignment:Alignment.centerLeft,
                          child: Text(
                            movie.title,
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
                              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                              filterQuality: FilterQuality.high,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        //Poster
                        const SizedBox(height: 20),
                        Align(
                          alignment:Alignment.centerLeft,
                          child: Text(
                            movie.overview,
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
                              '  ${movie.voteAverage.toStringAsFixed(1)}/10',
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
                            'Release date:  ${movie.releaseDate}',
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 72),
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(
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
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 16.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 40, 
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



/*FutureBuilder <List<String>>(
                future: Api().getGenres(movie.movieID.toString()),
                builder: (context, snapshot)
                {
                  List<String> MovieGenres = snapshot.data ?? [];
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(12) ,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: MovieGenres.length,
                        itemBuilder: (context, index)
                        {
                          return Container(
                            margin: EdgeInsets.only(right:10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(25, 25, 25, 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(MovieGenres[index])
                          );
                        }

                      )
                    ),
                  );
                }
              ),*/
