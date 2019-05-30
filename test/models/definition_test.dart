import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'dart:io';
import '../../lib/models/definition.dart';

void main() {
  test('Word should have been created from a json', () async {
    final file = new File('test/models/sample_word.json');
    final dmap = jsonDecode(await file.readAsString());
    final definition = WordDefinition.fromJson(dmap['definitions'][0]);

    expect(definition.type, 'VERB');
    expect(definition.definitionText, 'Make more beautiful or attractive.');
    expect(definition.examples, ["pictures and prints adorned his walls"]);
    expect(definition.synonyms, ["add ornament to", "decorate", "embellish"]);
    expect(definition.otherLanguages, {
      "telugu": "అలంకరించు,సజ్జీకరించు.",
      "tamil": "",
      "hindi": " सजाना, की शोभा बढ़ाना",
      "malayalam": ""
    });
  });
}
