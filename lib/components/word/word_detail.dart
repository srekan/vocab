import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vocab/components/word/bookmark_button.dart';
import 'package:vocab/root_data.dart';
import '../../models/word.dart';
import './word_definition.dart';
import '../../models/group.dart';
import '../../models/review.dart';
import '../../scoped_models/group_scoped_model.dart';
import './language_text.dart';

class WordDetail extends StatelessWidget {
  final Word activeWord;
  final Group activeGroup;
  final String preferredLanguage;
  final bool isShowingWordDefinition;
  final Function gotoNextWord;
  final Function markWordAs;
  final Function getReviewId;
  final Map<String, String> reviewMap;
  WordDetail({
    @required this.activeWord,
    @required this.activeGroup,
    @required this.preferredLanguage,
    @required this.isShowingWordDefinition,
    @required this.gotoNextWord,
    @required this.markWordAs,
    @required this.getReviewId,
    @required this.reviewMap,
  });

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
    final bookMarkMap =
        ScopedModel.of<GroupScopedModel>(context, rebuildOnChange: true)
            .bookMarkMap;
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
        Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Text(
                  activeWord.wordText,
                  style: Theme.of(context)
                      .textTheme
                      .display2
                      .merge(TextStyle(color: color)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: BookmarkButton(
                word: activeWord,
                bookMarkMap: rootdata.groups.bookMarkMap,
                toggleBookMark: rootdata.groups.toggleBookMark,
              ),
            ),
          ],
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
            ? LanguageText(
                text:
                    activeWord.definitions[0].otherLanguages[preferredLanguage])
            : Container(),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: isShowingWordDefinition == true
              ? WordDefinition(
                  word: activeWord,
                  preferredLanguage: preferredLanguage,
                )
              : Container(),
        ),
        SizedBox(height: 30.0),
        isShowingWordDefinition == true
            ? Container()
            : _buildWordLearningDescription(
                context, reviewMap[getReviewId(activeGroup, activeWord)]),
        SizedBox(height: 8.0),
      ],
    );
  }
}
