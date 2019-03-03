import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:fluttery/layout.dart';
import '../scopped_models/group.scopped_model.dart';
import '../models/word.model.dart';
import '../components/progress_chart.dart';
import '../models/review.dart';
import '../root_data.dart';

class GroupDetailScreen extends StatelessWidget {
  Widget _buildCardStack() {
    return AnchoredOverlay(
      showOverlay: true,
      child: Center(),
      overlayBuilder:
          (BuildContext buildContext, Rect anchorBounds, Offset anchor) {
        return CenterAbout(
          position: anchor,
          child: Container(
            width: anchorBounds.width,
            height: anchorBounds.height,
            padding: EdgeInsets.all(10.0),
            child: WordProfileCard(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: ScopedModel<GroupScoppedModel>(
        model: RootData.groups,
        child: ScopedModelDescendant<GroupScoppedModel>(
          builder: (context, child, model) {
            return Text(model.activeGroup.name);
          },
        ),
      )),
      body: _buildCardStack(),
    );
  }
}

class WordProfileCard extends StatelessWidget {
  Widget _buildProfileSynopsis() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Container(
        padding: EdgeInsets.only(bottom: 20.0),
        child: ScopedModel<GroupScoppedModel>(
          model: RootData.groups,
          child: ScopedModelDescendant<GroupScoppedModel>(
            builder: (context, child, model) {
              return ProgressChart.withWordsData(
                words: model.activeGroup.words,
                height: 200.0,
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10.0), boxShadow: [
        BoxShadow(
          color: Color(0x11000000),
          blurRadius: 5.0,
          spreadRadius: 2.0,
        ),
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Material(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              ScopedModel<GroupScoppedModel>(
                model: RootData.groups,
                child: _WordBrowser(),
              ),
              _buildProfileSynopsis(),
            ],
          ),
        ),
      ),
    );
  }
}

class _WordBrowser extends StatelessWidget {
  Widget _buildButtonsRow(model) {
    if (model.isShowingWordDefinition) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          RaisedButton(
            child: Text('Next Word'),
            onPressed: () {
              model.gotoNextWord();
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
              model.markWordAs(ReviewMark.KNOWN);
            },
          ),
          RaisedButton(
            child: Text('I Do not know this word'),
            onPressed: () {
              model.markWordAs(ReviewMark.UNKNOWN);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWordLearningDescription(ReviewName markName) {
    var desc = 'This is a new word in this set';
    var color = ReviewColors.newWordDark;
    if (markName == ReviewName.MASTERED) {
      desc = 'You have mastered this word';
      color = ReviewColors.mastered;
    }

    if (Review.isLearningReview(markName)) {
      var name = markName.toString();
      var lastChar = name[name.length - 1];
      desc = "You have to review this word $lastChar more time(s)";
      color = ReviewColors.learningDescriptionText;
    }
    return Container(
      child: Text(
        desc,
        style: TextStyle(
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model =
        ScopedModel.of<GroupScoppedModel>(context, rebuildOnChange: true);
    final activeWord = model.activeWord;
    final preferredLanguage = model.preferredLanguage;
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // Word Heading
        Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text(
                activeWord.wordText,
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: 40.0,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.volume_up,
                  color: Colors.brown[100],
                ),
                Text(
                  "${activeWord.syllable}",
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 15.0,
                  ),
                )
              ],
            ),
            model.isShowingWordDefinition
                ? WordDefinition(
                    word: activeWord,
                    preferredLanguage: preferredLanguage,
                  )
                : Container(),
            SizedBox(height: 30.0),
            model.isShowingWordDefinition
                ? Container()
                : _buildWordLearningDescription(
                    activeWord.learingReview.markName),
            _buildButtonsRow(model),
          ],
        ),
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
                  Text(
                    def.otherLanguages[preferredLanguage],
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 15.0,
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
