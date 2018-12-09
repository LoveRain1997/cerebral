library cerebral.builder;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'cerebral_state.dart';

TypeChecker _stateTypeChecker = const TypeChecker.fromRuntime(State);
TypeChecker _stateFieldTypeChecker = const TypeChecker.fromRuntime(StateField);

class CerebralGenerator extends GeneratorForAnnotation<State> {
  @override
  Iterable<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) sync* {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
          'Generator cannot target `${element.name}`.',
          todo: 'Remove the State annotation from `${element.name}`.',
          element: element);
    }
    if (!element.name.startsWith('_')) {
      throw InvalidGenerationSourceError(
          'Class `${element.name}` is not private, prefer to leave it as private and use the generated one.',
          todo: 'Make class `${element.name}` private.',
          element: element);
    }
    final className = element.name.substring(1);
    yield 'class $className {';
    yield* generateConstructor(element, className);
    yield* generateFields(element as ClassElement);
    yield '}';
  }

  Iterable<String> generateConstructor(
      ClassElement element, String className) sync* {
    yield '$className({';
    for (FieldElement value
        in element.fields.where((field) => field.isPublic)) {
      yield '${value.type} ${value.name},';
    }
    yield '}) : ${element.fields.where((field) => field.isPublic).map<String>((field) => 'this._${field.name} = ${field.name}').join(',')};';
  }

  // TODO add for list and map operator
  Iterable<String> generateFields(ClassElement element) sync* {
    for (FieldElement value
        in element.fields.where((field) => field.isPublic)) {
      yield '${value.type} _${value.name};';
    }
    for (FieldElement value
        in element.fields.where((field) => field.isPublic)) {
      yield '${value.type} get ${value.name} => this.${value.name};';
    }
    for (FieldElement value
        in element.fields.where((field) => field.isPublic)) {
      yield 'set ${value.name}(${value.type} _${value.name}) => this.${value.name} = _${value.name};';
    }
  }
}

Builder cerebralBuilder(BuilderOptions options) {
  return SharedPartBuilder([
    CerebralGenerator(),
  ], 'cerebral');
}
