import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import '../models/word.model.dart';

class ProgressChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  ProgressChart(this.seriesList, {this.animate});

  factory ProgressChart.withWordsData(List<Word> words) {
    final scores = {
      'NEW': 0,
      'LEARNING': 0,
      'MASTERED': 0,
    };

    for (var item in words) {
      final markName = item.learingReview.markName;
      if (markName == 'NEW' || markName == 'MASTERED') {
        scores[item.learingReview.markName] += 1;
      } else {
        scores['LEARNING'] += 1;
      }
    }

    final data = [
      LinearProgress(0, scores['NEW']),
      LinearProgress(1, scores['LEARNING']),
      LinearProgress(2, scores['MASTERED']),
    ];

    final seriesList = [
      charts.Series<LinearProgress, int>(
        id: 'Progress',
        domainFn: (LinearProgress score, _) => score.index,
        measureFn: (LinearProgress score, _) => score.score,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (LinearProgress row, _) =>
            '${LinearProgress.reviewNames[row.index]}: ${row.score}',
      )
    ];

    return ProgressChart(
      seriesList,
      animate: true,
    );
  }

  /// Creates a [PieChart] with sample data and no transition.
  factory ProgressChart.withSampleData() {
    return ProgressChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
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

    return SizedBox(
      height: 200.0,
      child: chart,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearProgress, int>> _createSampleData() {
    final data = [
      LinearProgress(0, 10),
      LinearProgress(1, 5),
      LinearProgress(2, 5),
    ];

    return [
      charts.Series<LinearProgress, int>(
        id: 'Progress',
        domainFn: (LinearProgress score, _) => score.index,
        measureFn: (LinearProgress score, _) => score.score,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (LinearProgress row, _) =>
            '${LinearProgress.reviewNames[row.index]}: ${row.score}',
      )
    ];
  }
}

/// Sample linear data type.
class LinearProgress {
  final int index;
  final int score;
  static final reviewNames = [
    'New',
    'Learning',
    'Mastered',
  ];

  LinearProgress(this.index, this.score);
}
