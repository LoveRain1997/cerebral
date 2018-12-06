library cerebral.builder;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'cerebral_state.dart';

TypeChecker _stateTypeChecker = const TypeChecker.fromRuntime(State);
TypeChecker _stateFieldTypeChecker = const TypeChecker.fromRuntime(StateField);

class CerebralGenerator extends GeneratorForAnnotation<State> {
  @override
  Iterable<String> generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    final codeLines = <String>[];
    codeLines.add('class _${element.name}CerebralMixin {');
    if (_stateTypeChecker.firstAnnotationOfExact(element).getField('copyWith').toBoolValue()) {
      codeLines.addAll(this.generateCopyWith(element, annotation, buildStep));
    }
    codeLines.add('}');
    return codeLines;
  }

  Iterable<String> generateCopyWith(Element element, ConstantReader annotation, BuildStep buildStep) {
    final codeLines = <String>[];
    codeLines.add('  factory ${element.name}.copyWith() {return ${element.name}();}');
    if (element is ClassElement) {
      final classElement = element;
      classElement.fields.forEach((fieldElement) {
        final hasAnnotation = _stateFieldTypeChecker.hasAnnotationOfExact(fieldElement);
        if (hasAnnotation) {

        }
        codeLines.add('// $hasAnnotation');
      });
    }
    return codeLines;
  }
}

Builder cerebralBuilder(BuilderOptions options) {
  return SharedPartBuilder([
    CerebralGenerator(),
  ], 'cerebral');
}