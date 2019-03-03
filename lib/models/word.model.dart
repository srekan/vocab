import './learning_review.dart';

enum Language {
  TELUGU,
  TAMIL,
  HINDI,
  MALAYALAM,
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
  String type;
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
      type: d['type'],
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
  LearningReview learingReview;

  Word({
    this.id,
    this.wordText,
    this.definitions,
    this.tags,
    this.phoneticScript,
    this.syllable,
    this.learingReview,
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
        learingReview: LearningReview.fromString(d['learningState']));
  }
}
