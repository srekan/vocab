import 'package:flutter/material.dart';

enum ReviewMark { KNOWN, UNKNOWN }
enum ReviewName {
  NEW,
  LEARNING,
  LEARNING4,
  LEARNING3,
  LEARNING2,
  LEARNING1,
  MASTERED,
}

class ReviewColors {
  static final newWord = Colors.amber[200];
  static final newWordDark = Colors.amber[700];
  static final learning = Colors.lightGreen[300];
  static final learningDescriptionText = Colors.blue[300];
  static final mastered = Colors.lightGreen[600];
}

class Review {
  static final list = [
    ReviewName.NEW,
    ReviewName.LEARNING4,
    ReviewName.LEARNING3,
    ReviewName.LEARNING2,
    ReviewName.LEARNING1,
    ReviewName.MASTERED,
  ];

  static bool isLearningReview(ReviewName name) {
    switch (name) {
      case ReviewName.LEARNING:
      case ReviewName.LEARNING1:
      case ReviewName.LEARNING2:
      case ReviewName.LEARNING3:
      case ReviewName.LEARNING4:
        return true;
      default:
        return false;
    }
  }
}
