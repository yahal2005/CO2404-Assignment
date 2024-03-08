import 'package:cinematic_insights/models/movieClass.dart';
import 'package:flutter/material.dart';
import 'package:cinematic_insights/api/api.dart';
import 'package:cinematic_insights/screens/movie_details_screen.dart';

class CustomSearchBar extends StatefulWidget 
{
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => CustomSearchBarState();
}

class CustomSearchBarState extends State<CustomSearchBar> 
{
  List<Movie> searchResult = [];
  final TextEditingController searchText = TextEditingController();
  var searchValue;
  bool isVisible = false;
  String dropdownValue = "Movie";
  //String filterDropdownValue = "None";

  Future<void> getSearchResult(String searchValue) async {
    List<Movie> result;
    if (dropdownValue == "Movie")
    {
      result = await Api().searchListMovies(searchValue);
      //if the search is based on movie title
    }
    else
    {
      result = await Api().searchListPerson(searchValue);
      // if search is based on actor name
    }
    
    setState(() 
    {
      searchResult = result;
    });
  }
  // returns appropriate result based on the search

  String croppedOverview(String Overview)
  {
    List<String> words = Overview.split(' ');
    if (words.length <= 20)
    {
      return Overview;
    }
    else
    {
      List<String> croppedList = words.sublist(0, 20);
      return '${croppedList.join(' ')}.....';
    }
  }
  //Reducing the overview to 20 words


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: ()
      {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Column(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: screenSize.width*0.08),
                    child: Container(
                      height: 0.051 * screenSize.height,
                      width: 0.45 * screenSize.width,
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search...',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.amber,
                          ),
                        ),
                        //Displays Search
                        autofocus: false,
                        controller: searchText,
                        onChanged: (value) 
                        {
                          setState(()
                          {
                            searchValue = value;
                          });
                          if (searchValue.length == 0)
                          {
                            setState(() 
                            {
                              searchResult = [];
                            });
                          } else if (searchValue.length > 2)
                          {
                            getSearchResult(searchValue);
                          }
                        },
                        onSubmitted: (value) {
                          setState(() 
                          {
                            searchValue = value;
                          });
                          if (searchValue.length > 2) 
                          {
                            getSearchResult(searchValue);
                          }
                        },
                      ),
                    ),
                  ),

                  Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton(
                        items: const[
                          DropdownMenuItem(child: Text("Movie Name"), value: "Movie"),
                          DropdownMenuItem(child: Text("Actor Name"), value: "Actor"),
                        ],
                        onChanged: (String? newValue){
                          setState(() {
                            dropdownValue = newValue!;
                          });
                          if (searchValue != null && searchValue.length == 0)
                          {
                            setState(() 
                            {
                              searchResult = [];
                            });
                          } 
                          else if (searchValue != null && searchValue.length > 2)
                          {
                            getSearchResult(searchValue);
                          }
                        },
                        value: dropdownValue,
                      )
                    ),
                  ),
                  //Dropdown to search based on actor name or movie title


                  /*IconButton(
                    icon:  Icon(Icons.arrow_downward),
                    onPressed: (){
                      setState(()
                      {
                        isVisible = !isVisible;
                      });
                    },
                  ),*/
                ],
              ),
              /*if (isVisible)
                Container(
                  padding: EdgeInsets.all(16.0),
                  child : Row(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text("Search by: "),
                            const SizedBox(width: 5),
                            DropdownButton(
                              items: const[
                                DropdownMenuItem(child: Text("Movie Name"), value: "Movie"),
                                DropdownMenuItem(child: Text("Actor Name"), value: "Actor"),
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
                      ),
                      SizedBox(width: screenSize.width*0.1),
                      Container(
                        child: Row(
                          children: [
                            Text("Filter by: "),
                            const SizedBox(width: 5),
                            DropdownButton(
                              items: const[
                                DropdownMenuItem(child: Text("None"), value: "None"),
                                DropdownMenuItem(child: Text("Popularity Ascending"), value: "PopAsc"),
                                DropdownMenuItem(child: Text("Popularity Descending"), value: "PopDesc")
                              ],
                              onChanged: (String? newValue){
                                setState(() {
                                  filterDropdownValue = newValue!;
                                });
                              },
                              value: filterDropdownValue,
                            )
                          ],
                        ),
                      ),

                    ],
                    )
                )*/
            ],
          ),
          if (searchResult.isNotEmpty)
            Container(
              height: screenSize.height,
              child: ListView.builder(
                itemCount: searchResult.length,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) 
                {
                  return GestureDetector(
                    onTap: () 
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MoviesDetailsScreen(movie: searchResult[index],type: "movie",),
                        ),
                      );
                      //Navigates to the specific movie's detail screen
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      height: 190,
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                image: NetworkImage(
                                  "https://image.tmdb.org/t/p/w500${searchResult[index].posterPath}",
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          //Movie Poster

                          SizedBox(width: screenSize.width*0.05),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: screenSize.width*0.4,
                                    height: 20,
                                    child: Text(
                                      searchResult[index].title
                                    ),
                                  ),
                                  //Title

                                  const SizedBox(height: 5,),

                                  Container(
                                    width: screenSize.width * 0.4,
                                    height: 110,
                                    child: Text(
                                      croppedOverview(searchResult[index].overview),
                                    ),
                                  ),
                                  //Overview

                                  Container(
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 20,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "${searchResult[index].voteAverage.toString()} / 10",
                                          ),
                                        ],
                                      ),
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
                    //Specifications for an individual movie
                  );
                },
              ),
            ),
            // Shows all the search results

          if (searchResult.isEmpty && searchValue != null && searchValue.length > 2)
            Container(
              margin: const EdgeInsets.only(top: 16),
              height: screenSize.height * 0.5,
              child: const Text("No results found"),
            ),
        ],
      ),
    );
  }
}