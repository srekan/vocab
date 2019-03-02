enum WordReviewMark { KNOWN, UNKNOWN }

class LearningReview {
  static final List<String> reviewOrders = [
    'NEW',
    'LEARNING1',
    'LEARNING2',
    'LEARNING3',
    'MASTERED',
  ];
  int _maxIndex = reviewOrders.length - 1;
  int _markIndex = 0;
  String get markName => reviewOrders[_markIndex];

  updateReview(WordReviewMark markAs) {
    if (markAs == WordReviewMark.KNOWN) {
      if (_markIndex == 0) {
        _markIndex = _maxIndex;
      } else {
        _markIndex++;
        if (_markIndex > _maxIndex) {
          _markIndex = _maxIndex;
        }
      }
    } else {
      _markIndex = 1;
    }
  }
}
