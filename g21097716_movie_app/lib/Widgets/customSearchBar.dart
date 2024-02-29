import 'package:cinematic_insights/api/api.dart';
import 'package:cinematic_insights/models/movieClass.dart';
import 'package:cinematic_insights/screens/details_screen.dart';
import 'package:flutter/material.dart';

class searchBar extends StatefulWidget {

  const searchBar({super.key});
  @override

  State<searchBar> createState() => searchBarState();
}

class searchBarState extends State<searchBar> 
{
  List<Movie> searchResult = [];
  final TextEditingController searchText = TextEditingController();
  bool showList = false;
  var searchValue;

  Widget build(BuildContext Context)
  {
    final Size screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: ()
      {
        FocusManager.instance.primaryFocus?.unfocus();
        showList = !showList;

      },
      child: Column(
        children: [
          Container(
            height: 0.05 * screenSize.height,
            width: 0.5 * screenSize.width,
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.amber,
                )
              ),
              autofocus: false,
              controller: searchText,
              onSubmitted: (value){
                searchResult.clear();
                setState(() {
                  searchValue = value;
                });
              },
              onChanged: (value) {
                searchResult.clear();
                setState(() {
                  searchValue = value;
                });
              },
            )

          ),
          if (searchText.text.length > 0)
            FutureBuilder(
              future: Api().searchList(searchValue),
              builder: (context, snapshot)
              {
                if (snapshot.connectionState == ConnectionState.done)
                {
                  if (snapshot.data == null)
                  {
                    return Container(
                      margin: const EdgeInsets.only(top: 16),
                      height: screenSize.height*0.5,
                      child: const Text("No results found"),
                    );
                  }
                  else
                  {
                    searchResult = snapshot.data!;
                    return Container(
                      height: screenSize.height*0.5305,
                      child: ListView.builder(
                        itemCount: searchResult.length,
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context,index)
                        {
                          return GestureDetector(
                            onTap: ()
                            {
                              Navigator.push(context, MaterialPageRoute(builder: ((context) => DetailsScreen(movie: searchResult[index]))));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 8, bottom: 8),
                              height: 150,
                              width: screenSize.width,
                              decoration: const BoxDecoration(
                                color: Colors.black,
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
                                          'https://image.tmdb.org/t/p/w500${searchResult[index].posterPath}',
                                        ),
                                        fit: BoxFit.fill,
                                      ), 
                                    ),
                                  ),

                                  const SizedBox(width: 20) ,   

                                  Padding(
                                    padding: const EdgeInsets.all(8.0) ,
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: screenSize.width*0.4,
                                            height: 85,
                                            child : Text("${searchResult[index].overview}")
                                          ),
                                          Container(
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  const Icon( Icons.star,
                                                    color: Colors.amber,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text("${searchResult[index].voteAverage}/10")
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )

                                    )
                                  )                          
                                ],
                              )
                            ),
                          );
                        },

                      ),
                    );
                  }
                  
                }
                else
                {
                  return const Center(child: CircularProgressIndicator(color: Colors.amber),);
                }
              },
            )
        ],
      )
    );
  }

}