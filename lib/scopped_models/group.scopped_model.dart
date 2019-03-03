import 'package:scoped_model/scoped_model.dart';
import '../models/group.model.dart';
import '../models/word.model.dart';
import '../models/review.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
  return rootBundle
      .loadString(assetsPath)
      .then((jsonStr) => jsonDecode(jsonStr));
}

class GroupScoppedModel extends Model {
  SharedPreferences _prefs;
  List<Group> _groups = [];
  Group _activeGroup;
  Word _activeWord;
  bool _isShowingWordDefinition = false;
  String _preferredLanguage = 'telugu'; // TODO: derive it from local storage

  SharedPreferences get prefs => _prefs;
  List<Group> get groups => _groups;
  Group get activeGroup => _activeGroup;
  Word get activeWord => _activeWord;
  bool get isShowingWordDefinition => _isShowingWordDefinition;
  String get preferredLanguage => _preferredLanguage;

  GroupScoppedModel() {
    getData();
  }

  getData() async {
    _prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> dmap =
        await parseJsonFromAssets('assets/vocab-data.json');
    List<Group> __groups = [];
    List<Word> _words = [];
    for (var item in dmap['words']) {
      item['learningState'] =
          await _getLearningReviewFromLocalStorage(item['id']);
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

  resetGroup(Group group) {
    for (var item in group.words) {
      item.learingReview.resetReview();
    }
    notifyListeners();
  }

  markWordAs(ReviewMark markAs) {
    Word word = _activeWord;
    word.learingReview.updateReview(markAs);
    _isShowingWordDefinition = true;
    _prefs.setString(_activeWord.id, word.learingReview.toString());
    notifyListeners();
  }

  gotoNextWord() {
    List<Word> words = [];
    List<Word> masteredWords = [];

    for (var item in _activeGroup.words) {
      if (item.learingReview.markName != ReviewName.MASTERED) {
        words.add(item);
      } else {
        masteredWords.add(item);
      }
    }

    if (words.length == 0) {
      words = masteredWords;
    } else if (words.length < 3) {
      masteredWords.shuffle();
      words.add(masteredWords[0]);
      if (words.length < 3) {
        words.add(masteredWords[1]);
      }
    }

    words.shuffle();
    while (words[0] == _activeWord) {
      words.shuffle();
    }

    setActiveWord(words[0]);
  }

  String _getLearningReviewFromLocalStorage(String id) {
    var reviewName = _prefs.getString(id);
    switch (reviewName) {
      case 'NEW':
      case 'LEARNING4':
      case 'LEARNING3':
      case 'LEARNING2':
      case 'LEARNING1':
      case 'MASTERED':
        return reviewName;
      default:
        reviewName = 'NEW';
        return reviewName;
    }
  }
}
