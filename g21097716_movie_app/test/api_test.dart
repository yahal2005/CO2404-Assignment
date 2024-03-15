import 'package:cinematic_insights/api/api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('getHighestGrossing should return a non-null value', () {

    final result =  Api().getHighestGrossing();

    expect(result, completes); // makes sure result receives a value
    expect(result.then((result) => result != null), completion(isTrue));
  });

}