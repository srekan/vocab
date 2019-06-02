import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/review.dart';

void main() {
  group('Review', () {
    group('isLearningReview()', () {
      test('${ReviewName.NEW} is not a Learning Review', () {
        expect(Review.isLearningReview(ReviewName.NEW), false);
      });
      test('${ReviewName.MASTERED} is not a Learning Review', () {
        expect(Review.isLearningReview(ReviewName.MASTERED), false);
      });
      test('${ReviewName.LEARNING1} is a Learning Review', () {
        expect(Review.isLearningReview(ReviewName.LEARNING1), true);
      });
      test('${ReviewName.LEARNING2} is a Learning Review', () {
        expect(Review.isLearningReview(ReviewName.LEARNING2), true);
      });
      test('${ReviewName.LEARNING3} is a Learning Review', () {
        expect(Review.isLearningReview(ReviewName.LEARNING3), true);
      });
      test('${ReviewName.LEARNING4} is a Learning Review', () {
        expect(Review.isLearningReview(ReviewName.LEARNING4), true);
      });
    });
  });
}
