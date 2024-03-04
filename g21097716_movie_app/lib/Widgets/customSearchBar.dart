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
  String dropdownValue = "Movie";

  Future<void> getSearchResult(String searchValue) async {
    List<Movie> result;
    if (dropdownValue == "Movie")
    {
      result = await Api().searchListMovies(searchValue);
    }
    else
    {
      result = await Api().searchListPerson(searchValue);
    }
    
    setState(() 
    {
      searchResult = result;
    });
  }



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
                          builder: (context) => MoviesDetailsScreen(movie: searchResult[index]),
                        ),
                      );
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
                          const SizedBox(width: 20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: screenSize.width * 0.4,
                                    height: 85,
                                    child: Text(
                                      searchResult[index].overview,
                                    ),
                                  ),
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