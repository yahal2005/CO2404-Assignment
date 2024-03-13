import 'package:cinematic_insights/Network/dependency_injection.dart';
import 'package:cinematic_insights/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:cinematic_insights/Widgets/customSearchBar.dart';
import 'package:cinematic_insights/screens/Section%20Screens/MoviesAndTVShows.dart';
import 'package:cinematic_insights/screens/Section%20Screens/MyList.dart';
import 'package:cinematic_insights/models/movieClass.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cinematic_insights/screens/LoginScreens/login_screen.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeScreen({
    super.key, 
    required this.currentlyPlaying,
    required this.trendingYr,
    required this.highestGrossing,
    required this.childrenFriendly,
    required this.onTv,
  });

  Future<List<Movie>> currentlyPlaying;
  Future<List<Movie>> trendingYr;
  Future<List<Movie>> highestGrossing;
  Future<List<Movie>> childrenFriendly;
  Future<List<Movie>> onTv;
  

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {

  @override
  void initState()
  {
    super.initState();
    initializeData();
    DependencyInjection.init(); //Checks for network connectivity
  }

  Future<void> initializeData() async 
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Logged', true);
  }
  // Updates the local bool variable for login

  Future<void> loggedOut(BuildContext context) async 
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Logged', false);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen(
        currentlyPlaying: widget.currentlyPlaying,
        trendingYr: widget.trendingYr,
        highestGrossing: widget.highestGrossing,
        childrenFriendly: widget.childrenFriendly,
        onTv: widget.onTv,
      )),
    );
  } 
  // To Logout

  @override
  Widget build(BuildContext context) 
  {
    final Size screenSize = MediaQuery.of(context).size;
    TabController tabController = TabController(length: 2, vsync: this);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () 
            {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0,8,8,0),
            child: IconButton(
              onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: ((context) => ProfileScreen())));
              }, 
              icon: Icon(Icons.account_circle, size: 42,)),
          ),
        ],
      ),
      drawer: Drawer(
        width: screenSize.width * 0.25,
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.9),
            Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                title: const Text(
                  'Logout',
                  textAlign: TextAlign.center,
                ),
                onTap: () 
                {
                  loggedOut(context);
                },
              ),
            ),
          ],
        ),
      ), 
      //Menu which directs to the Logout

      body: ListView(
        children: [
          SizedBox(
            height: screenSize.height * 0.28,
            width: screenSize.width * 0.78,
            child: Image.asset(
              "assets/logo.png",
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
          // Logo

          Padding(
            padding: EdgeInsets.fromLTRB(
              0.125 * screenSize.width,
              0,
              0,
              0.03 * screenSize.height,
            ),
            child: const CustomSearchBar(),
          ),

          SizedBox(
            height: screenSize.height * 0.05,
            width: screenSize.width * 1,
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicator: const  BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromRGBO(253, 203, 74, 1.0),
                    width: 4.0,
                  ),
                ),
                // Border to show the currently selected option
              ),
              controller: tabController,
              tabs: [
                Tab(child: Text("Movies & TV shows")),
                Tab(child: Text("My-List")),
              ],
            ),
          ),
          // TapBar with Options ("Movies & Tv shows", "My-List")

          SizedBox(
            height: screenSize.height * 0.5,
            width: screenSize.width,
            child: TabBarView(
              controller: tabController,
              children: [
                MoviesAndTvShows(
                  currentlyPlaying: widget.currentlyPlaying,
                  trendingYr: widget.trendingYr,
                  highestGrossing: widget.highestGrossing,
                  childrenFriendly: widget.childrenFriendly,
                  onTv: widget.onTv,
                ),
                // Contains the categorised movies and tv shows

                MyList(),
                //Contains the Watch-List
              ],
            ),
          ),
        ],
      ),
    );
  }
}

