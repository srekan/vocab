import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped_models/group_scoped_model.dart';
import '../models/word.dart';
import '../models/group.dart';
import '../components/progress_chart.dart';
import '../models/review.dart';
import '../root_data.dart';
import '../components/word/word_detail.dart';

class GroupDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<GroupScopedModel>(
      model: rootdata.groups,
      child: ScopedModelDescendant<GroupScopedModel>(
        builder: (context, child, model) {
          return Scaffold(
            appBar: AppBar(
              title: Text(model.activeGroup.name),
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _WordBrowser(
                  activeWord: model.activeWord,
                  activeGroup: model.activeGroup,
                  preferredLanguage: model.preferredLanguage,
                  isShowingWordDefinition: model.isShowingWordDefinition,
                  gotoNextWord: model.gotoNextWord,
                  markWordAs: model.markWordAs,
                  reviewMap: model.reviewMap,
                  getReviewId: model.getReviewId,
                ),
                Align(
                  child: ProgressChart.fromGroup(
                    // height: model.isShowingWordDefinition ? 150 : 200,
                    height: 200,
                    group: model.activeGroup,
                    animate: true,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _WordBrowser extends StatelessWidget {
  final Word activeWord;
  final Group activeGroup;
  final String preferredLanguage;
  final bool isShowingWordDefinition;
  final Function gotoNextWord;
  final Function markWordAs;
  final Function getReviewId;
  final Map<String, String> reviewMap;
  _WordBrowser({
    @required this.activeWord,
    @required this.activeGroup,
    @required this.preferredLanguage,
    @required this.isShowingWordDefinition,
    @required this.gotoNextWord,
    @required this.markWordAs,
    @required this.getReviewId,
    @required this.reviewMap,
  });
  Widget _buildButtonsRow(BuildContext context) {
    if (isShowingWordDefinition == true) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          RaisedButton(
            textTheme: Theme.of(context).buttonTheme.textTheme,
            child: Text('Next Word'),
            onPressed: () {
              gotoNextWord();
            },
          )
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          RaisedButton(
            child: Text('I know this word'),
            onPressed: () {
              markWordAs(ReviewMark.KNOWN);
            },
          ),
          RaisedButton(
            child: Text('I Do not know this word'),
            onPressed: () {
              markWordAs(ReviewMark.UNKNOWN);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        WordDetail(
          activeWord: activeWord,
          activeGroup: activeGroup,
          preferredLanguage: preferredLanguage,
          isShowingWordDefinition: isShowingWordDefinition,
          gotoNextWord: gotoNextWord,
          markWordAs: markWordAs,
          reviewMap: reviewMap,
          getReviewId: getReviewId,
        ),
        SizedBox(height: 8.0),
        _buildButtonsRow(context),
      ],
    );
  }
}
