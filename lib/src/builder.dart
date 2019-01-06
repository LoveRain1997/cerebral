library cerebral.builder;

import 'package:build/build.dart';
import 'package:cerebral/src/generators/store.dart';
import 'package:source_gen/source_gen.dart';

Builder cerebralBuilder(BuilderOptions options) {
  return SharedPartBuilder([
    StoreGenerator(),
  ], 'cerebral');
}
