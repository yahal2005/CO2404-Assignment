/*import 'package:flutter_test/flutter_test.dart';
import 'package:cinematic_insights/Widgets/customSearchBar.dart';

void main() {
  test('Cropped overview returns original string if length is 20 or less', () {
    // Test case when the length of the overview is less than or equal to 20 words
    String overview = "This is a short overview.";
    expect(CustomSearchBar().croppedOverview(overview), equals(overview));
  });

  test('Cropped overview returns first 20 words followed by "....." if length is greater than 20', () {
    // Test case when the length of the overview is greater than 20 words
    String overview = "This is a longer overview with more than 20 words. We need to crop it to fit.";
    String cropped = "This is a longer overview with more than 20 words. We need to crop it to fit.....";
    expect(croppedOverview(overview), equals(cropped));
  });
}*/