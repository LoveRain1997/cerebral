import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:cerebral/src/action.dart' as Cerebral;
import 'package:cerebral/src/base.dart';
import 'package:cerebral/src/generators/helper.dart';
import 'package:source_gen/source_gen.dart';

class StoreGenerator extends Generator {
  static TypeChecker storeTypeChecker = TypeChecker.fromRuntime(StoreBase);
  static TypeChecker resolverTypeChecker =
      TypeChecker.fromRuntime(Cerebral.Resolver);
  static TypeChecker actionTypeChecker =
      TypeChecker.fromRuntime(Cerebral.Action);

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    var values = Set<String>();

    for (var classElement in library.classElements.where(
        (classElement) => storeTypeChecker.isAssignableFrom(classElement))) {
      var generatedValue =
          generateForClassElement(library, classElement, buildStep);
      await for (var value in normalizeGeneratorOutput(generatedValue)) {
        assert(value == null || (value.length == value.trim().length));
        values.add(value);
      }
    }
    return values.join('\n\n');
  }

  Iterable<String> generateForClassElement(
    LibraryReader library,
    ClassElement element,
    BuildStep buildStep,
  ) sync* {
    final actions = library.classElements.where(
        (classElement) => actionTypeChecker.isAssignableFrom(classElement));
    actions.any((action));
    yield '''class _${element.name}Mixin {
      void _initialize(Map<Action, List<Signal>> signals) {
      //${actions.map<String>((action) => '${action.name}').join(' ')}
      }
    }''';
  }

  bool checkActionWithSamePriority(ClassElement action) {
    final priorities
    action.methods
  }
}
