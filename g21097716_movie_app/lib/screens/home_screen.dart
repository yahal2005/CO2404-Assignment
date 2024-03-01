import 'package:flutter/material.dart';
import 'package:cinematic_insights/Widgets/customSearchBar.dart';
import 'package:cinematic_insights/screens/Section%20Screens/MoviesAndTVShows.dart';
import 'package:cinematic_insights/screens/Section%20Screens/MyList.dart';
import 'package:cinematic_insights/models/movieClass.dart';
import 'package:cinematic_insights/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cinematic_insights/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late Future<List<Movie>> currentlyPlaying;
  late Future<List<Movie>> trendingYr;
  late Future<List<Movie>> highestGrossing;
  late Future<List<Movie>> childrenFriendly;
  late Future<List<Movie>> onTv;

  @override
  void initState()
  {
    super.initState();
    initializeData(); 
  }

  Future<void> initializeData() async 
  {
    currentlyPlaying = Api().getCurrentlyPlaying();
    trendingYr = Api().getPopular();
    highestGrossing = Api().getHighestGrossing();
    childrenFriendly = Api().getChildrenFriendly();
    onTv = Api().getOnTv();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Logged', true);
  }

  Future<void> loggedOut(BuildContext context) async 
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Logged', false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

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
      ),
      drawer: Drawer(
        width: screenSize.width * 0.25,
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.9),
            Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                title: Text(
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
          Padding(
            padding: EdgeInsets.fromLTRB(
              0.125 * screenSize.width,
              0,
              0.125 * screenSize.width,
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
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromRGBO(253, 203, 74, 1.0),
                    width: 4.0,
                  ),
                ),
              ),
              controller: tabController,
              tabs: [
                Tab(child: Text("Movies & TV shows")),
                Tab(child: Text("My-List")),
              ],
            ),
          ),
          SizedBox(
            height: screenSize.height * 0.5,
            width: screenSize.width,
            child: TabBarView(
              controller: tabController,
              children: [
                MoviesAndTvShows(
                  currentlyPlaying: currentlyPlaying,
                  trendingYr: trendingYr,
                  highestGrossing: highestGrossing,
                  childrenFriendly: childrenFriendly,
                  onTv: onTv,
                ),
                MyList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

