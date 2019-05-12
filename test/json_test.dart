import 'package:test/test.dart';

import 'json/list_test.dart';
import 'json/multi_depth_test.dart';
import 'json/multi_depth_with_inner_list_test.dart';
import 'json/simple_test.dart';

void main() {
  test('Parses simple object', testSimple);
  test('Parses object in list', testList);
  test('Parses object with inner objects', testMultiDepth);
  test(
      'Parses object with it\'s inner objects within a list that\'s assigned to a field.',
      testMultiDepthWithInnerList);
}
