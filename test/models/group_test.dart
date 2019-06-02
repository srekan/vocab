import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/review.dart';
import 'dart:convert';
import 'dart:io';

import '../../lib/models/group.dart';

void main() {
  group('Group', () {
    final file = new File('test/models/sample_data.json');
    var dmap;
    var weekDayGroupDmap;
    var globalGroupDmap;
    Group dayGroup;
    setUp(() async {
      dmap = jsonDecode(await file.readAsString());
      weekDayGroupDmap = dmap['groups'][0];
      globalGroupDmap = dmap['globalGroups'][0];
    });

    group('Day Group', () {
      test('Group should have been created from json', () {
        dayGroup = Group.fromJson(weekDayGroupDmap);
        expect(dayGroup.id, 'WEEK1-DAY1');
        expect(dayGroup.name, 'WEEK1-DAY1');
        expect(dayGroup.globalGroupId, 'WEEK1-GLOBAL');
        expect(dayGroup.subGroupIds, []);
        expect(dayGroup.words, []);
        expect(dayGroup.reviewMap, {});
      });
      test('Progress should be updated by reviewMap', () {
        dayGroup.reviewMap['word1'] = ReviewName.NEW;
        dayGroup.reviewMap['word2'] = ReviewName.NEW;
        dayGroup.reviewMap['word3'] = ReviewName.LEARNING1;
        dayGroup.reviewMap['word4'] = ReviewName.LEARNING1;
        dayGroup.reviewMap['word5'] = ReviewName.LEARNING1;
        dayGroup.reviewMap['word6'] = ReviewName.LEARNING2;
        dayGroup.reviewMap['word7'] = ReviewName.LEARNING2;
        dayGroup.reviewMap['word8'] = ReviewName.LEARNING3;
        dayGroup.reviewMap['word9'] = ReviewName.MASTERED;
        dayGroup.reviewMap['word10'] = ReviewName.MASTERED;
        dayGroup.reviewMap['word11'] = ReviewName.MASTERED;
        dayGroup.updateProgress();
        expect(dayGroup.progress[ReviewName.NEW], 2);
        expect(dayGroup.progress[ReviewName.LEARNING], 6);
        expect(dayGroup.progress[ReviewName.MASTERED], 3);
      });
    });
    group('Global Group', () {
      test('Group should have been created from json', () {
        Group group = Group.fromJson(globalGroupDmap);
        expect(group.id, 'WEEK1-GLOBAL');
        expect(group.name, 'Week1');
        expect(group.globalGroupId, '');
        expect(group.subGroupIds, [
          "WEEK1-DAY1",
          "WEEK1-DAY2",
          "WEEK1-DAY3",
          "WEEK1-DAY4",
          "WEEK1-DAY5",
          "WEEK1"
        ]);
        expect(group.words, []);
        expect(group.reviewMap, {});
      });
    });
  });
}
