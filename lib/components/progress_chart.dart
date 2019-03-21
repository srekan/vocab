import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import '../models/word.dart';
import '../models/group.dart';
import '../models/review.dart';

class ProgressChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final Function getReviewId;
  final Group group;
  final Map<String, String> reviewMap;
  final bool animate;
  final double height;
  final double width;
  final bool disableDiscriptions;

  ProgressChart(
    this.seriesList, {
    this.animate,
    @required this.height,
    @required this.width,
    this.disableDiscriptions,
    @required this.reviewMap,
    @required this.group,
    @required this.getReviewId,
  });

  factory ProgressChart.withWordsData({
    List<Word> words,
    double height,
    double width,
    bool disableDiscriptions,
    @required reviewMap,
    @required group,
    @required getReviewId,
  }) {
    final scores = {
      ReviewName.NEW: 0,
      ReviewName.LEARNING: 0,
      ReviewName.MASTERED: 0,
    };

    for (var word in words) {
      final markName = reviewMap[getReviewId(group, word)];
      if (markName == ReviewName.NEW || markName == ReviewName.MASTERED) {
        scores[markName] += 1;
      } else {
        scores[ReviewName.LEARNING] += 1;
      }
    }

    final data = [
      LinearProgress(0, scores[ReviewName.NEW]),
      LinearProgress(1, scores[ReviewName.LEARNING]),
      LinearProgress(2, scores[ReviewName.MASTERED]),
    ];

    var _labelAccessorFn = (LinearProgress row, _) =>
        '${LinearProgress.reviewDisplayNames[row.index]}: ${row.score}';
    if (disableDiscriptions == true) {
      _labelAccessorFn = (LinearProgress row, _) => '';
    }
    final seriesList = [
      charts.Series<LinearProgress, int>(
        id: 'Progress',
        domainFn: (LinearProgress score, _) => score.index,
        measureFn: (LinearProgress score, _) => score.score,
        colorFn: (LinearProgress score, _) =>
            LinearProgress.colors[score.index],
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: _labelAccessorFn,
      )
    ];

    return ProgressChart(
      seriesList,
      animate: true,
      height: height,
      width: width,
      disableDiscriptions: disableDiscriptions,
      reviewMap: reviewMap,
      group: group,
      getReviewId: getReviewId,
    );
  }

  @override
  Widget build(BuildContext context) {
    var chart = charts.PieChart(seriesList,
        animate: animate,
        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
        //
        // [ArcLabelDecorator] will automatically position the label inside the
        // arc if the label will fit. If the label will not fit, it will draw
        // outside of the arc with a leader line. Labels can always display
        // inside or outside using [LabelPosition].
        //
        // Text style for inside / outside can be controlled independently by
        // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
        //
        // Example configuring different styles for inside/outside:
        //       charts.ArcLabelDecorator(
        //          insideLabelStyleSpec: charts.TextStyleSpec(...),
        //          outsideLabelStyleSpec: charts.TextStyleSpec(...)),
        defaultRenderer: charts.ArcRendererConfig(
            arcWidth: 60, arcRendererDecorators: [charts.ArcLabelDecorator()]));

    if (width == 0) {
      return SizedBox(
        height: height,
        child: chart,
      );
    } else {
      return SizedBox(
        height: height,
        width: width,
        child: chart,
      );
    }
  }
}

class LinearProgress {
  final int index;
  final int score;
  static final reviewDisplayNames = [
    'New',
    'Learning',
    'Mastered',
  ];

  static final colors = [
    charts.ColorUtil.fromDartColor(ReviewColors.newWord),
    charts.ColorUtil.fromDartColor(ReviewColors.learning),
    charts.ColorUtil.fromDartColor(ReviewColors.mastered),
  ];
  LinearProgress(this.index, this.score);
}
