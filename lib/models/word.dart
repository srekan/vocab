import './definition.dart';

class Word {
  String id;
  String bookMarkId;

  //  id is the lower case of the wordText.
  //  While storing the review state to shared preferences,
  //  we prepare an id relative to the group : groupId + id
  //  The word will be in two places : A day group and the week assesment group

  //  BookMarkId:
  //  We need a unique id for this use case.
  //  However, we cannot use existing id (wordText lowercase)
  //  Because the same word might be there in a different group.
  //  We cannot change the id value in the data for the id associations are already in production
  //  We are forming the unique bookMarkId : Week${num}-Day${num}+${wordText.toLowercase()}
  //  eg: Week8-Day2-bash

  //  Going forward, We will use this bookMarkId as the unique id for the word

  String wordText;
  String phoneticScript;
  String syllable;
  List<WordDefinition> definitions = [];
  List<String> tags = [];

  Word({
    this.id,
    this.bookMarkId,
    this.wordText,
    this.definitions,
    this.tags,
    this.phoneticScript,
    this.syllable,
  });
  factory Word.fromJson(Map<String, dynamic> d) {
    List<WordDefinition> _definitions = [];
    for (var item in d['definitions']) {
      _definitions.add(WordDefinition.fromJson(item));
    }
    List<String> _tags = [];
    for (var item in d['tags']) {
      _tags.add(item);
    }

    return Word(
      id: d['id'],
      bookMarkId: d['bookMarkId'],
      wordText: d['wordText'],
      phoneticScript: d['phoneticScript'],
      syllable: d['syllable'],
      definitions: _definitions,
      tags: _tags,
    );
  }
}
