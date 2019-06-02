import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vocab/components/word/bookmark_button.dart';
import 'package:vocab/theme/vocab.dart';
import '../scoped_models/group_scoped_model.dart';
import '../root_data.dart';
import '../models/word.dart';
import '../components/word/word_definition.dart';

class BookmarksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<GroupScopedModel>(
      model: rootdata.groups,
      child: ScopedModelDescendant<GroupScopedModel>(
        builder: (context, child, model) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Bookmarks'),
            ),
            body: BookMarkedWordList(
              words: model.bookMarkedWords,
            ),
          );
        },
      ),
    );
  }
}

class BookMarkedWordList extends StatelessWidget {
  final List<Word> words;
  BookMarkedWordList({
    @required this.words,
  });
  @override
  Widget build(BuildContext context) {
    if (words.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 24),
        child: Text(
          'No Words Bookmarked Yet',
          textAlign: TextAlign.center,
        ),
      );
    }
    return SingleChildScrollView(
        child: Column(
      children: words.map((Word word) {
        return BookMarkListItem(word: word);
      }).toList(),
    ));
  }
}

class BookMarkListItem extends StatelessWidget {
  final Word word;
  BookMarkListItem({
    @required this.word,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    word.wordText,
                    style: themeVocab.textTheme.display1,
                  ),
                  FlatButton.icon(
                    icon: Icon(
                      Icons.remove_circle,
                      color: Colors.redAccent,
                    ),
                    label: Text(
                      'Remove',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    onPressed: () {
                      rootdata.groups.toggleBookMark(word, context);
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      word.definitions[0]
                          .otherLanguages[rootdata.groups.preferredLanguage],
                      style: Theme.of(context).textTheme.subhead.merge(
                            TextStyle(
                              color: Colors.indigo,
                            ),
                          ),
                    ),
                  ),
                ],
              ),
              WordDefinition(
                word: word,
                preferredLanguage: rootdata.groups.preferredLanguage,
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Divider(
          color: Colors.blue,
        ),
      ],
    );
  }
}
