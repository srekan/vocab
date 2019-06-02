import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import '../models/group.dart';
import '../models/review.dart';

class ProgressChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final Group group;
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
    @required this.group,
  });

  factory ProgressChart.fromGroup({
    double height,
    double width,
    bool disableDiscriptions,
    @required Group group,
    animate,
  }) {
    var data = [
      LinearProgress(0, group.progress[ReviewName.NEW], ReviewName.NEW),
      LinearProgress(
          1, group.progress[ReviewName.LEARNING], ReviewName.LEARNING),
      LinearProgress(
          2, group.progress[ReviewName.MASTERED], ReviewName.MASTERED),
    ];
    if (group.globalGroupId == '') {
      data = [
        LinearProgress(0, group.progress[ReviewName.NEW], ReviewName.NEW),
        LinearProgress(
          1,
          group.progress[ReviewName.LEARNING] +
              group.progress[ReviewName.MASTERED],
          ReviewName.MASTERED,
        ),
      ];
    }
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
            LinearProgress.colors[score.reviewName],
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: _labelAccessorFn,
      )
    ];
    return ProgressChart(
      seriesList,
      animate: animate == true,
      height: height,
      width: width,
      disableDiscriptions: disableDiscriptions,
      group: group,
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
          arcWidth: 60,
          arcRendererDecorators: [
            charts.ArcLabelDecorator(),
          ],
        ));

    if (width == 0) {
      return SizedBox(
        height: height,
        child: chart,
      );
    } else {
      return SizedBox(
          height: height,
          width: width,
          child: Stack(
            children: <Widget>[
              chart,
              Container(
                color: Colors.transparent,
                width: width,
                height: height,
              ),
            ],
          ));
    }
  }
}

class LinearProgress {
  final int index;
  final int score;
  final String reviewName;
  static final reviewDisplayNames = [
    ReviewName.NEW,
    ReviewName.LEARNING,
    ReviewName.MASTERED,
  ];

  static final Map<String, charts.Color> colors = {
    ReviewName.NEW: charts.ColorUtil.fromDartColor(ReviewColors.newWord),
    ReviewName.LEARNING: charts.ColorUtil.fromDartColor(ReviewColors.learning),
    ReviewName.MASTERED: charts.ColorUtil.fromDartColor(ReviewColors.mastered),
  };
  LinearProgress(this.index, this.score, this.reviewName);
}
