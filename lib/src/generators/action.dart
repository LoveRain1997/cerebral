import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:cerebral/src/action.dart' as Cerebral;
import 'package:cerebral/src/generators/helper.dart';
import 'package:source_gen/source_gen.dart';

class ActionGenerator extends Generator {
  static TypeChecker resolverTypeChecker =
      TypeChecker.fromRuntime(Cerebral.Resolver);
  static TypeChecker actionTypeChecker =
      TypeChecker.fromRuntime(Cerebral.Action);

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    var values = Set<String>();

    for (var classElement in library.classElements.where(
        (classElement) => actionTypeChecker.isAssignableFrom(classElement))) {
      var generatedValue = generateForClassElement(classElement, buildStep);
      await for (var value in normalizeGeneratorOutput(generatedValue)) {
        assert(value == null || (value.length == value.trim().length));
        values.add(value);
      }
    }
    return values.join('\n\n');
  }

  Iterable<String> generateForClassElement(
    ClassElement element,
    BuildStep buildStep,
  ) sync* {
    yield '''class _${element.name}Mixin {
    }''';
  }
}

