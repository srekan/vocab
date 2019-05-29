import 'package:flutter/material.dart';
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

class GroupScopedModel extends Model {
  SharedPreferences _prefs;
  String dataVersion;
  List<Group> _groups = [];
  Map<String, Group> groupsMap = {};
  List<Group> _globalGroups = [];
  Group _activeGroup;
  Word _activeWord;
  bool _isShowingWordDefinition = false;
  String _preferredLanguage = 'telugu'; // TODO: derive it from local storage
  Map<String, String> reviewMap = {};
  Map<String, bool> bookMarkMap = {};
  List<String> bookMarks = [];
  final dataUrl = 'https://srekan.github.io/vocab/vocab-data.json';
  final cacheManager = DefaultCacheManager();

  SharedPreferences get prefs => _prefs;
  List<Group> get globalGroups => _globalGroups;
  List<Group> get groups => _groups;
  Group get activeGroup => _activeGroup;
  Word get activeWord => _activeWord;
  bool get isShowingWordDefinition => _isShowingWordDefinition;
  String get preferredLanguage => _preferredLanguage;

  GroupScopedModel() {
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

    getDataFromNetwork();
    _getBookMarksFromCache();
    // getDataFromDocs(); // For development only
  }

  getDataFromNetwork() async {
    var file = await cacheManager.downloadFile(dataUrl);
    final contents = file.file.readAsStringSync();
    Map<String, dynamic> dmap = jsonDecode(contents);
    if (dmap['version'] != dataVersion) {
      _prepareData(dmap);
    } else {
      // print('No change in the version.' + dmap['version'] + dataVersion);
    }
  }

  getDataFromDocs() async {
    // Products
    Map<String, dynamic> dmap =
        await parseJsonFromAssets('docs/vocab-data.json');
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

    // Create words
    for (var item in dmap['words']) {
      var word = Word.fromJson(item);
      _words.add(word);
    }

    // Create groups
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
      groupsMap[group.id] = group;
      __groups.add(group);
    }
    _groups = __groups;

    // Create global groups
    List<Group> __globalGroups = [];
    for (var item in dmap['globalGroups']) {
      var group = Group.fromJson(item);
      group.reviewMap = {};
      for (var id in group.subGroupIds) {
        group.reviewMap.addAll(groupsMap[id].reviewMap);
      }
      group.updateProgress();
      groupsMap[group.id] = group;
      __globalGroups.add(group);
    }
    _globalGroups = __globalGroups;
    notifyListeners();
  }

  setActiveGroup(group, context) {
    _activeGroup = group;
    setActiveWord(_activeGroup.words[0]);
    Navigator.of(context).pushNamed('group_detail');
  }

  setActiveWord(Word word) {
    _activeWord = word;
    _isShowingWordDefinition = false;
    notifyListeners();
  }

  resetGroup(Group group) {
    group.reviewMap.forEach((k, v) {
      final newVal = Review.reviewNames[0];
      reviewMap[k] = newVal;
      group.reviewMap[k] = newVal;
      _prefs.setString(k, newVal);
    });

    group.updateProgress();
    if (group.globalGroupId == '') {
      for (var gId in group.subGroupIds) {
        resetGroup(groupsMap[gId]);
      }
    }
    notifyListeners();
  }

  markWordAs(ReviewMark markAs) {
    String mapId = getReviewId(_activeGroup, _activeWord);
    final nextReview = _getNextReview(markAs, reviewMap[mapId]);
    reviewMap[mapId] = nextReview;
    _activeGroup.reviewMap[mapId] = nextReview;
    _activeGroup.reviewMap[mapId] = nextReview;
    groupsMap[_activeGroup.globalGroupId].reviewMap[mapId] = nextReview;

    _activeGroup.updateProgress();
    groupsMap[_activeGroup.globalGroupId].updateProgress();

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
    return group.globalGroupId + group.id + word.wordText;
  }

  toggleBookMark(Word word) {
    if (bookMarkMap[word.bookMarkId] == true) {
      bookMarkMap[word.bookMarkId] = null;
      bookMarks.remove(word.bookMarkId);
      _prefs.setStringList('BOOKMARKS', bookMarks);
    } else {
      bookMarkMap[word.bookMarkId] = true;
      bookMarks.add(word.bookMarkId);
      _prefs.setStringList('BOOKMARKS', bookMarks);
    }
    print(bookMarkMap);
    notifyListeners();
  }

  _getBookMarksFromCache() {
    bookMarks = _prefs.getStringList('BOOKMARKS');

    if (bookMarks == null) {
      bookMarks = [];
    }
    bookMarkMap = {};
    bookMarks.forEach((bookMarkId) {
      bookMarkMap[bookMarkId] = true;
    });
  }
}
