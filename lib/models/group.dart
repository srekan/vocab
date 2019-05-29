import './word.dart';
import './review.dart';

class Group {
  final String id;
  final String name;
  final String globalGroupId;
  List<String> subGroupIds;
  List<Word> words = [];
  Map<String, String> reviewMap = {};
  Map<String, int> progress = {
    ReviewName.NEW: 0,
    ReviewName.LEARNING: 0,
    ReviewName.MASTERED: 0,
  };

  Group({
    this.id,
    this.name,
    this.globalGroupId,
    this.words,
    this.subGroupIds,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    String globalGroupId = json['globalGroupId'];
    if (globalGroupId == null) {
      globalGroupId = '';
    }
    List<String> subGroupIds = [];
    if (json['subGroupIds'] != null) {
      for (var item in json['subGroupIds']) {
        subGroupIds.add(item.toString());
      }
    }
    return Group(
      id: json['id'],
      name: json['displayName'],
      globalGroupId: globalGroupId,
      subGroupIds: subGroupIds,
    );
  }
  updateProgress() {
    final scores = {
      ReviewName.NEW: 0,
      ReviewName.LEARNING: 0,
      ReviewName.MASTERED: 0,
    };

    reviewMap.forEach((k, v) {
      if (v == ReviewName.NEW || v == ReviewName.MASTERED) {
        scores[v] += 1;
      } else {
        scores[ReviewName.LEARNING] += 1;
      }
    });
    progress[ReviewName.NEW] = scores[ReviewName.NEW];
    progress[ReviewName.LEARNING] = scores[ReviewName.LEARNING];
    progress[ReviewName.MASTERED] = scores[ReviewName.MASTERED];
  }
}
