import 'package:flutter_test/flutter_test.dart';
import 'package:vocab/models/definition.dart';
import 'dart:convert';
import 'dart:io';
import '../../lib/models/word.dart';

void main() {
  test('Word should have been created from a json', () async {
    final file = new File('test/models/sample_word.json');
    final dmap = jsonDecode(await file.readAsString());
    final word = Word.fromJson(dmap);
    final definition = WordDefinition.fromJson(dmap['definitions'][0]);

    expect(word.wordText, 'adorn');
    expect(word.id, 'adorn');
    expect(word.syllable, 'uh-dawrn');
    expect(word.phoneticScript, '/əˈdɔrn/');
    expect(word.tags, ["WEEK1", "WEEK1-DAY1"]);
    expect(word.definitions.length, 1);

    expect(word.definitions[0].type, definition.type);
    expect(word.definitions[0].definitionText, definition.definitionText);
    expect(word.definitions[0].examples, definition.examples);
    expect(word.definitions[0].synonyms, definition.synonyms);
    expect(word.definitions[0].otherLanguages, definition.otherLanguages);
  });
}
