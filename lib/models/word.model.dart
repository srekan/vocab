enum WordType {
  NOUN,
  VERB,
}
enum Language {
  TELUGU,
  TAMIL,
  HINDI,
}
class Definition {
  WordType type;
  String definitionText;
  List<String> examples = [];
  List<String> synonyms = [];
  Map<Language, String> otherLanguages;
}
class Word {
  String wordText;
  List<Definition> definitions = [];
  List<String> tags = [];
}