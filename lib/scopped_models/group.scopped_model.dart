import 'package:scoped_model/scoped_model.dart';
import '../models/group.model.dart';
import '../models/word.model.dart';
import '../models/learning_review.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
  print('--- Parse json from: $assetsPath');
  return rootBundle
      .loadString(assetsPath)
      .then((jsonStr) => jsonDecode(jsonStr));
}

class GroupScoppedModel extends Model {
  List<Group> _groups = [];
  Group _activeGroup;
  Word _activeWord;
  bool _isShowingWordDefinition = false;

  List<Group> get groups => _groups;
  Group get activeGroup => _activeGroup;
  Word get activeWord => _activeWord;
  bool get isShowingWordDefinition => _isShowingWordDefinition;

  GroupScoppedModel() {
    getData();
  }

  getData() async {
    Map<String, dynamic> dmap =
        await parseJsonFromAssets('assets/vocab-data.json');
    List<Group> __groups = [];
    List<Word> _words = [];
    for (var item in dmap['words']) {
      var word = Word.fromJson(item);
      _words.add(word);
    }
    for (var item in dmap['groups']) {
      var group = Group.fromJson(item);

      List<Word> _wordsInGroup = [];
      for (var cId in item['children']) {
        _wordsInGroup.add(_words.firstWhere((e) => e.id == cId));
      }
      group.words = _wordsInGroup;
      __groups.add(group);
    }
    _groups = __groups;
    print(_groups);
    notifyListeners();
  }

  setActiveGroup(group) {
    _activeGroup = group;
    setActiveWord(_activeGroup.words[0]);
  }

  setActiveWord(Word word) {
    _activeWord = word;
    _isShowingWordDefinition = false;
    notifyListeners();
  }

  markWordAs(WordReviewMark markAs) {
    Word word = _activeWord;
    word.learingReview.updateReview(markAs);
    print('Marking the word as ' +
        markAs.toString() +
        word.learingReview.markName);
    print("..............................");
    _isShowingWordDefinition = true;
    notifyListeners();
  }

  gotoNextWord() {
    List<Word> words = [];

    for (var item in _activeGroup.words) {
      if (item.learingReview.markName != 'MASTERED') {
        words.add(item);
      }
    }
    for (var item in words) {
      print(item.wordText);
    }
    // TODO: if there is only one word to master, pick a word from mastered list
    // TODO: consider all words when all words are mastered
    words.shuffle();
    for (var item in words) {
      print(item.wordText);
    }

    while (words[0] == _activeWord) {
      words.shuffle();
    }

    setActiveWord(words[0]);
  }
}

GroupScoppedModel groupScoppedModelInstance = GroupScoppedModel();
