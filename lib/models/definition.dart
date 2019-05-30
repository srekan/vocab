class WordDefinition {
  String type;
  String definitionText;
  List<String> examples = [];
  List<String> synonyms = [];
  Map<String, dynamic> otherLanguages;

  WordDefinition({
    this.type,
    this.definitionText,
    this.examples,
    this.synonyms,
    this.otherLanguages,
  });

  factory WordDefinition.fromJson(Map<String, dynamic> d) {
    List<String> _examples = [];
    for (var item in d['examples']) {
      _examples.add(item);
    }

    List<String> _synonyms = [];
    for (var item in d['synonyms']) {
      _synonyms.add(item);
    }

    return WordDefinition(
      type: d['type'],
      definitionText: d['definitionText'],
      examples: _examples,
      synonyms: _synonyms,
      otherLanguages: d['otherLanguages'],
    );
  }
}
