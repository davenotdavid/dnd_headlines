import 'package:dnd_headlines/utils/helper_functions.dart';
import 'package:test/test.dart';

void main() {
  group('Time difference logic', () {
    test('difference has days ago', () {
      final timeDiff = HelperFunctions.getTimeDifference('2020-01-01T00:00:00+00:00');
      
      expect(timeDiff.contains('days ago'), true);
    });

    test('difference does not have hours ago', () {
      final timeDiff = HelperFunctions.getTimeDifference('2020-01-01T00:00:00+00:00');
      
      expect(timeDiff.contains('hours ago'), false);
    });
  });
}
