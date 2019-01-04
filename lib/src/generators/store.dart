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
            (classElement) =>
            storeTypeChecker.isAssignableFrom(classElement))) {
      var generatedValue =
      generateForClassElement(library, classElement, buildStep);
      await for (var value in normalizeGeneratorOutput(generatedValue)) {
        assert(value == null || (value.length == value
            .trim()
            .length));
        values.add(value);
      }
    }
    return values.join('\n\n');
  }

  Iterable<String> generateForClassElement(LibraryReader library,
      ClassElement element,
      BuildStep buildStep,) sync* {
    final actions = library.classElements.where(
            (classElement) => actionTypeChecker.isAssignableFrom(classElement));
    final initializeLines = <String>[];
    actions.forEach((action) {
      final resolvers = sortResolversByPriorities(action);
      if (resolvers.isNotEmpty) {
        initializeLines.add('signals[${action.name}] = <ActionResolver>[');
        initializeLines.addAll(resolvers.map<String>((resolver) {
          return '(action, state) => (action as ${action.name}).${resolver.name}(state),';
        }));
        initializeLines.add('];');
      }
    });
    final stateName = element.supertype.typeArguments.first.displayName;
    yield '''mixin _${element.name}Mixin on CerebralStore<$stateName> {
      @override
      void initialize(Map<Type, List<ActionResolver>> signals) {
        ${initializeLines.join('\n')}
      }
    }''';
  }

  List<MethodElement> sortResolversByPriorities(ClassElement action) {
    final resolvers = action.methods
        .where((method) => resolverTypeChecker.hasAnnotationOfExact(method))
        .where((method) =>
        storeTypeChecker.isAssignableFromType(
            resolverTypeChecker
                .firstAnnotationOfExact(method)
                .getField('store')
                .toTypeValue()))
        .toList();
    final getPriority = (MethodElement method) =>
        resolverTypeChecker
            .firstAnnotationOfExact(method)
            .getField('priority')
            .toIntValue();
    resolvers.sort((a, b) {
      final sortKey = getPriority(a) - getPriority(b);
      if (sortKey == 0) {
        throw ArgumentError.value(
            'Priority cannot be the same. Check `${a.name}` and `${b
                .name}` in class `${action.name}`');
      }
      return sortKey;
    });
    return resolvers;
  }
}
