import 'package:flutter/material.dart';

enum ReviewMark { KNOWN, UNKNOWN }

abstract class ReviewName {
  static final NEW = 'NEW';
  static final LEARNING = 'LEARNING';
  static final LEARNING4 = 'LEARNING4';
  static final LEARNING3 = 'LEARNING3';
  static final LEARNING2 = 'LEARNING2';
  static final LEARNING1 = 'LEARNING1';
  static final MASTERED = 'MASTERED';
}

class ReviewColors {
  static final newWord = Colors.amber[200];
  static final newWordDark = Colors.amber[700];
  static final learning = Colors.lightGreen[300];
  static final learningDescriptionText = Colors.blue[300];
  static final mastered = Colors.lightGreen[600];
}

class Review {
  static final reviewNames = [
    ReviewName.NEW,
    ReviewName.LEARNING4,
    ReviewName.LEARNING3,
    ReviewName.LEARNING2,
    ReviewName.LEARNING1,
    ReviewName.MASTERED,
  ];
  static int maxIndex = Review.reviewNames.length - 1;
  static bool isLearningReview(String name) {
    switch (name) {
      case 'LEARNING':
      case 'LEARNING1':
      case 'LEARNING2':
      case 'LEARNING3':
      case 'LEARNING4':
        return true;
      default:
        return false;
    }
  }
}
