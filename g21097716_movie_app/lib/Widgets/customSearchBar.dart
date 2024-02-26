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
                  searchResult = snapshot.data!;
                  if (snapshot.data == null)
                  {
                    return Container(
                      height: screenSize.height*0.5,
                      child:Text("No results found"),
                    );
                  }
                  else
                  {
                    return Container(
                      height: screenSize.height*0.5,
                      child: ListView.builder(
                        itemCount: searchResult.length,
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context,index)
                        {
                          return GestureDetector(
                            onTap: ()
                            {
                              Navigator.push(context, MaterialPageRoute(builder: ((context) => DetailsScreen(movie: searchResult[index]))));
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 4, bottom: 4),
                              height: 100,
                              width: screenSize.width,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.all(Radius.circular(10)),

                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: screenSize.width * 0.4,

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

                                  SizedBox(width: 20) ,   

                                  Padding(
                                    padding: const EdgeInsets.all(8.0) ,
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(),
                                          Container(),
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
                  return Center(child: CircularProgressIndicator(color: Colors.amber),);
                }
              },
            )
        ],
      )
    );
  }

}