import 'package:cinematic_insights/models/movieClass.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cinematic_insights/screens/movie_details_screen.dart'; // Import your movie details screen class

void main() {
   setUpAll(() async {
    // Initialize Firebase before running any tests
    await Firebase.initializeApp();
  });
  group('MoviesDetailsScreen', () {
    testWidgets('Add to Watchlist', (WidgetTester tester) async {
      // Build the widget tree with MoviesDetailsScreen
      await tester.pumpWidget(MaterialApp(
        home: MoviesDetailsScreen(
          movie: Movie(
            movieID: 1011985,
            title: '"Kung Fu Panda 4"',
            overview: "Po is gearing up to become the spiritual leader of his Valley of Peace, but also needs someone to take his place as Dragon Warrior. As such, he will train a new kung fu practitioner for the spot and will encounter a villain called the Chameleon who conjures villains from the past.",
            voteAverage: 6.929,
            releaseDate: '2022-01-01',
            posterPath: "/gJL5kp5FMopB2sN4WZYnNT5uO0u.jpg",
            genreIds: [28,12,16,35,10751], 
            backDropPath: "/gJL5kp5FMopB2sN4WZYnNT5uO0u.jpg", 
            originalTitle: "Kung Fu Panda 4", 
            mediaType: 'movie',
          ),
          type: 'movie',
        ),
      ));

      
      final addToWatchlistButton = find.byType(ElevatedButton);
      
      await tester.tap(addToWatchlistButton);
     
      await tester.pumpAndSettle();

      expect(find.text('Remove from watchlist'), findsOneWidget);

  
      await tester.tap(addToWatchlistButton);
     
      await tester.pumpAndSettle();

      expect(find.text('Add to watchlist'), findsOneWidget);
    });
  });
}