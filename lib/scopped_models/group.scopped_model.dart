import 'package:scoped_model/scoped_model.dart';
import '../models/group.model.dart';
import '../models/word.model.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
  print('--- Parse json from: $assetsPath');
  return rootBundle
      .loadString(assetsPath)
      .then((jsonStr) => jsonDecode(jsonStr));
}

enum MarkWord { KNOWN, UNKNOWN }

class GroupScoppedModel extends Model {
  List<Group> groups = [];
  String screenName = "GroupsScreen";
  Group activeGroup;
  int activeWordIndex = -1;
  GroupScoppedModel() {
    getData();
  }

  getData() async {
    Map<String, dynamic> dmap =
        await parseJsonFromAssets('assets/vocab-data.json');
    List<Group> _groups = [];
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
      _groups.add(group);
    }
    groups = _groups;
    print(_groups);
    notifyListeners();
  }

  setActiveGroup(group) {
    activeGroup = group;
    setActiveWordIndex(0);
  }

  setActiveWordIndex(int index) {
    activeWordIndex = index;
    notifyListeners();
  }

  markWordAs(MarkWord markAs) {
    // TODO: use markAs to determine the state of the word - NEW / LEARNT / LEARNING3 / LEARNING2 / LEARNING1
    // For now, we will change the index

    int _newWordIndex = -1;
    if (activeWordIndex + 1 == activeGroup.words.length) {
      _newWordIndex = 0;
    } else {
      _newWordIndex = activeWordIndex + 1;
    }

    setActiveWordIndex(_newWordIndex);
  }
}

GroupScoppedModel groupScoppedModelInstance = GroupScoppedModel();
