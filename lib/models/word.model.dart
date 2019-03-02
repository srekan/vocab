enum WordType {
  NOUN,
  VERB,
}
enum Language {
  TELUGU,
  TAMIL,
  HINDI,
  MALAYALAM,
}
WordType getWordTypeByString(String type) {
  switch (type) {
    case 'NOUN':
      return WordType.NOUN;
    case 'VERB':
      return WordType.VERB;
    default:
      return WordType.NOUN;
  }
}

Language getLanguageByString(String lang) {
  switch (lang.toUpperCase()) {
    case 'TELUGU':
      return Language.TELUGU;
    case 'TAMIL':
      return Language.TAMIL;
    case 'HINDI':
      return Language.HINDI;
    case 'MALAYALAM':
      return Language.MALAYALAM;
    default:
      return Language.TELUGU;
  }
}

class Definition {
  WordType type;
  String definitionText;
  List<String> examples = [];
  List<String> synonyms = [];
  Map<String, dynamic> otherLanguages;

  Definition({
    this.type,
    this.definitionText,
    this.examples,
    this.synonyms,
    this.otherLanguages,
  });

  factory Definition.fromJson(Map<String, dynamic> d) {
    List<String> _examples = [];
    for (var item in d['examples']) {
      _examples.add(item);
    }

    List<String> _synonyms = [];
    for (var item in d['synonyms']) {
      _synonyms.add(item);
    }

    return Definition(
      type: getWordTypeByString(d['type']),
      definitionText: d['definitionText'],
      examples: _examples,
      synonyms: _synonyms,
      otherLanguages: d['otherLanguages'],
    );
  }
}

class Word {
  String id;
  String wordText;
  String phoneticScript;
  String syllable;
  List<Definition> definitions = [];
  List<String> tags = [];

  Word({
    this.id,
    this.wordText,
    this.definitions,
    this.tags,
    this.phoneticScript,
    this.syllable,
  });
  factory Word.fromJson(Map<String, dynamic> d) {
    List<Definition> _definitions = [];
    for (var item in d['definitions']) {
      _definitions.add(Definition.fromJson(item));
    }
    List<String> _tags = [];
    for (var item in d['tags']) {
      _tags.add(item);
    }
    return Word(
      id: d['id'],
      wordText: d['wordText'],
      phoneticScript: d['phoneticScript'],
      syllable: d['syllable'],
      definitions: _definitions,
      tags: _tags,
    );
  }
}
