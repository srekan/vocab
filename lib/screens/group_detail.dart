import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped_models/group_scoped_model.dart';
import '../models/word.dart';
import '../models/group.dart';
import '../components/progress_chart.dart';
import '../models/review.dart';
import '../root_data.dart';

class GroupDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<GroupScoppedModel>(
      model: rootdata.groups,
      child: ScopedModelDescendant<GroupScoppedModel>(
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
                  child: ProgressChart.withWordsData(
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

  Widget _buildWordLearningDescription(BuildContext context, String markName) {
    var desc = 'This is a new word in this set';
    var color = ReviewColors.newWordDark;
    if (markName == ReviewName.MASTERED) {
      desc = 'You have mastered this word';
      color = ReviewColors.mastered;
    }

    if (Review.isLearningReview(markName) == true) {
      var name = markName.toString();
      var lastChar = name[name.length - 1];
      desc = "You have to review this word $lastChar more time(s)";
      color = ReviewColors.learningDescriptionText;
    }
    return Container(
      child: Text(
        desc,
        style: Theme.of(context).textTheme.subtitle.merge(TextStyle(
              color: color,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var color;
    final reviewId = getReviewId(activeGroup, activeWord);
    final reviewName = activeGroup.reviewMap[reviewId];
    if (reviewName == ReviewName.MASTERED) {
      color = ReviewColors.mastered;
    } else {
      color = Theme.of(context).textTheme.display2.color;
    }
    return Column(
      children: <Widget>[
        SizedBox(height: 8.0),
        Text(
          activeWord.wordText,
          style: Theme.of(context)
              .textTheme
              .display2
              .merge(TextStyle(color: color)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.volume_up,
              color: Colors.brown[100],
            ),
            Text(
              activeWord.syllable,
              style: Theme.of(context).textTheme.subhead,
            )
          ],
        ),
        isShowingWordDefinition == true
            ? WordDefinition(
                word: activeWord,
                preferredLanguage: preferredLanguage,
              )
            : Container(),
        SizedBox(height: 30.0),
        isShowingWordDefinition == true
            ? Container()
            : _buildWordLearningDescription(
                context, reviewMap[getReviewId(activeGroup, activeWord)]),
        SizedBox(height: 8.0),
        _buildButtonsRow(context),
      ],
    );
  }
}

class WordDefinition extends StatelessWidget {
  final Word word;
  final String preferredLanguage;
  WordDefinition({
    @required this.word,
    @required this.preferredLanguage,
  });

  Widget _buildSynonyms(List<String> synonyms) {
    if (synonyms.length == 0) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Synonyms:',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.blueGrey,
          ),
        ),
        Text(synonyms.join(', '))
      ],
    );
  }

  Widget _buildExamples(List<String> examples) {
    if (examples.length == 0) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Examples:',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.blueGrey,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: examples.map((sy) {
            return Text('- ' + sy);
          }).toList(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: word.definitions.map((def) {
        return Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      def.otherLanguages[preferredLanguage],
                      style: Theme.of(context).textTheme.subhead.merge(
                            TextStyle(
                              color: Colors.indigo,
                            ),
                          ),
                    ),
                  ),
                ],
              ),
              Text(
                def.type.toLowerCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(def.definitionText),
              Container(height: 10.0),
              _buildExamples(def.examples),
              Container(height: 10.0),
              _buildSynonyms(def.synonyms),
            ],
          ),
        );
      }).toList(),
    );
  }
}
