import './word.dart';
import '../root_data.dart';
import './review.dart';

class Group {
  String id;
  String name;
  List<Word> words = [];
  Map<String, String> reviewMap = {};
  Map<String, int> progress = {
    ReviewName.NEW: 0,
    ReviewName.LEARNING: 0,
    ReviewName.MASTERED: 0,
  };

  Group({this.id, this.name, this.words});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
    );
  }
  updateProgress() {
    final scores = {
      ReviewName.NEW: 0,
      ReviewName.LEARNING: 0,
      ReviewName.MASTERED: 0,
    };

    for (var word in words) {
      final markName = reviewMap[rootdata.groups.getReviewId(this, word)];
      if (markName == ReviewName.NEW || markName == ReviewName.MASTERED) {
        scores[markName] += 1;
      } else {
        scores[ReviewName.LEARNING] += 1;
      }
    }

    progress[ReviewName.NEW] = scores[ReviewName.NEW];
    progress[ReviewName.LEARNING] = scores[ReviewName.LEARNING];
    progress[ReviewName.MASTERED] = scores[ReviewName.MASTERED];
  }
}
