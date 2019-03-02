import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:fluttery/layout.dart';
import '../scopped_models/group.scopped_model.dart';
import '../models/word.model.dart';
import '../models/learning_review.dart';
import '../components/progress_chart.dart';

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
        model: groupScoppedModelInstance,
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
          model: groupScoppedModelInstance,
          child: ScopedModelDescendant<GroupScoppedModel>(
            builder: (context, child, model) {
              return ProgressChart.withWordsData(model.activeGroup.words);
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
                model: groupScoppedModelInstance,
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

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        RaisedButton(
          child: Text('I know this word'),
          onPressed: () {
            model.markWordAs(WordReviewMark.KNOWN);
          },
        ),
        RaisedButton(
          child: Text('I Do not know this word'),
          onPressed: () {
            model.markWordAs(WordReviewMark.UNKNOWN);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final model =
        ScopedModel.of<GroupScoppedModel>(context, rebuildOnChange: true);
    final activeWord = model.activeWord;
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
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "${activeWord.syllable}",
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: 20.0,
                ),
              ),
            ),
            model.isShowingWordDefinition
                ? WordDefinition(word: activeWord)
                : Container(),
            Container(
              child: Text(
                'This is a new word in this set',
                style: TextStyle(
                  color: Colors.deepOrange,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: _buildButtonsRow(model),
            ),
          ],
        ),
      ],
    );
  }
}

class WordDefinition extends StatelessWidget {
  final Word word;
  WordDefinition({
    @required this.word,
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
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: synonyms.map((sy) {
            return Text('-- ' + sy);
          }).toList(),
        )
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
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: examples.map((sy) {
            return Text('-- ' + sy);
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
