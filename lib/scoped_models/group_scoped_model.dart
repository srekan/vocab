import 'package:scoped_model/scoped_model.dart';
import '../models/group.dart';
import '../models/word.dart';
import '../models/review.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
  return rootBundle
      .loadString(assetsPath)
      .then((jsonStr) => jsonDecode(jsonStr));
}

class GroupScoppedModel extends Model {
  SharedPreferences _prefs;
  String dataVersion;
  List<Group> _groups = [];
  Group _activeGroup;
  Word _activeWord;
  bool _isShowingWordDefinition = false;
  String _preferredLanguage = 'telugu'; // TODO: derive it from local storage
  Map<String, String> reviewMap = {};
  final dataUrl = 'https://srekan.github.io/vocab/vocab-data.json';
  final cacheManager = DefaultCacheManager();

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

    var file = await cacheManager.getFileFromCache(dataUrl);
    if (file != null) {
      final contents = file.file.readAsStringSync();
      Map<String, dynamic> dmap = jsonDecode(contents);
      _prepareData(dmap);
    }

    _getDataFromNetwork();
  }

  _getDataFromNetwork() async {
    var file = await cacheManager.downloadFile(dataUrl);
    final contents = file.file.readAsStringSync();
    Map<String, dynamic> dmap = jsonDecode(contents);
    if (dmap['version'] != dataVersion) {
      _prepareData(dmap);
    } else {
      // print('No change in the version.' + dmap['version'] + dataVersion);
    }
  }

  _prepareData(Map<String, dynamic> dmap) {
    List<Group> __groups = [];
    List<Word> _words = [];
    dataVersion = dmap['version'];
    for (var item in dmap['words']) {
      var word = Word.fromJson(item);
      _words.add(word);
    }

    for (var item in dmap['groups']) {
      var group = Group.fromJson(item);
      List<Word> _wordsInGroup = [];
      for (var cId in item['children']) {
        Word word = _words.firstWhere((e) => e.id == cId);
        _wordsInGroup.add(word);
        String mapId = getReviewId(group, word);
        reviewMap[mapId] = _getLearningReviewFromLocalStorage(mapId);
        group.reviewMap[mapId] = reviewMap[mapId];
      }
      group.words = _wordsInGroup;
      group.updateProgress();
      __groups.add(group);
    }
    _groups = __groups;
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
    for (var word in group.words) {
      String mapId = getReviewId(group, word);
      reviewMap[mapId] = Review.reviewNames[0];
      group.reviewMap[mapId] = reviewMap[mapId];
      _prefs.setString(mapId, reviewMap[mapId]);
    }
    group.updateProgress();
    notifyListeners();
  }

  markWordAs(ReviewMark markAs) {
    String mapId = getReviewId(_activeGroup, _activeWord);
    reviewMap[mapId] = _getNextReview(markAs, reviewMap[mapId]);
    _activeGroup.reviewMap[mapId] = reviewMap[mapId];
    _activeGroup.updateProgress();
    _isShowingWordDefinition = true;
    _prefs.setString(mapId, reviewMap[mapId]);
    notifyListeners();
  }

  gotoNextWord() {
    List<Word> words = [];
    List<Word> masteredWords = [];

    for (var word in _activeGroup.words) {
      String mapId = getReviewId(_activeGroup, word);
      if (reviewMap[mapId] != 'MASTERED') {
        words.add(word);
      } else {
        masteredWords.add(word);
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

  String _getNextReview(ReviewMark markAs, String currentReview) {
    int markIndex = Review.reviewNames.indexWhere((e) => e == currentReview);
    if (markAs == ReviewMark.KNOWN) {
      if (markIndex == 0) {
        markIndex = Review.maxIndex;
      } else {
        markIndex++;
        if (markIndex > Review.maxIndex) {
          markIndex = Review.maxIndex;
        }
      }
    } else {
      markIndex = 1;
    }
    return Review.reviewNames[markIndex];
  }

  String getReviewId(Group group, Word word) {
    return group.name + '-' + word.wordText;
  }
}
