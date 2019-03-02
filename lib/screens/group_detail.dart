import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:fluttery/layout.dart';
import '../scopped_models/group.scopped_model.dart';
import '../models/group.model.dart';
import '../models/word.model.dart';

class GroupDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<GroupScoppedModel>(
      model: groupScoppedModelInstance,
      child: _GroupDetailScreenContents(),
    );
  }
}

class _GroupDetailScreenContents extends StatelessWidget {
  Widget _buildCardStack(
      Group activeGroup, int activeWordIndex, Function markWordAs) {
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
            padding: EdgeInsets.all(16.0),
            child: WordProfileCard(
              activeGroup: activeGroup,
              activeWordIndex: activeWordIndex,
              markWordAs: markWordAs,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final model =
        ScopedModel.of<GroupScoppedModel>(context, rebuildOnChange: true);
    final Group activeGroup = model.activeGroup;
    final Function markWordAs = model.markWordAs;
    final int activeWordIndex = model.activeWordIndex;
    return Scaffold(
      appBar: AppBar(
        title: Text(activeGroup.name),
      ),
      body: _buildCardStack(activeGroup, activeWordIndex, markWordAs),
    );
  }
}

class WordProfileCard extends StatelessWidget {
  final Group activeGroup;
  final int activeWordIndex;
  final Function markWordAs;
  WordProfileCard({
    @required this.activeGroup,
    @required this.activeWordIndex,
    @required this.markWordAs,
  });

  Widget _buildProfileSynopsis() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.blueGrey.withOpacity(0.8),
            ],
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Text('Descriptions..'),
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
              _WordBrowser(
                words: activeGroup.words,
                markWordAs: markWordAs,
                activeWordIndex: activeWordIndex,
              ),
              // _buildProfileSynopsis(),
            ],
          ),
        ),
      ),
    );
  }
}

class _WordBrowser extends StatelessWidget {
  final List<Word> words;
  final int activeWordIndex;
  final Function markWordAs;
  _WordBrowser({
    @required this.words,
    @required this.activeWordIndex,
    @required this.markWordAs,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // Word Heading
        Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 40.0, 0, 0),
              child: Text(
                words[activeWordIndex].wordText,
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: 40.0,
                ),
              ),
            ),
            /*
            Container(
              child: Text(
                "${words[activeWordIndex].phoneticScript}",
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: 20.0,
                ),
              ),
            ),
            */
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 40.0),
              child: Text(
                "${words[activeWordIndex].syllable}",
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: 20.0,
                ),
              ),
            ),
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
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    child: Text('I know this word'),
                    onPressed: () {
                      markWordAs(MarkWord.KNOWN);
                    },
                  ),
                  RaisedButton(
                    child: Text('I Do not know this word'),
                    onPressed: () {
                      markWordAs(MarkWord.UNKNOWN);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
