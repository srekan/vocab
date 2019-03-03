import './review.dart';

class LearningReview {
  int _maxIndex = Review.list.length - 1;
  int markIndex = 0;
  ReviewName get markName => Review.list[markIndex];
  LearningReview({this.markIndex});

  static final reviewNames = [
    'NEW',
    'LEARNING4',
    'LEARNING3',
    'LEARNING2',
    'LEARNING1',
    'MASTERED',
  ];
  factory LearningReview.fromString(String s) {
    final instance = LearningReview();
    switch (s) {
      case 'NEW':
        instance.markIndex = 0;
        break;
      case 'LEARNING4':
        instance.markIndex = 1;
        break;
      case 'LEARNING3':
        instance.markIndex = 2;
        break;
      case 'LEARNING2':
        instance.markIndex = 3;
        break;
      case 'LEARNING1':
        instance.markIndex = 4;
        break;
      case 'MASTERED':
        instance.markIndex = 5;
        break;
    }
    return instance;
  }
  updateReview(ReviewMark markAs) {
    if (markAs == ReviewMark.KNOWN) {
      if (markIndex == 0) {
        markIndex = _maxIndex;
      } else {
        markIndex++;
        if (markIndex > _maxIndex) {
          markIndex = _maxIndex;
        }
      }
    } else {
      markIndex = 1;
    }
  }

  resetReview() {
    markIndex = 0;
  }

  @override
  String toString() {
    return LearningReview.reviewNames[markIndex];
  }
}
