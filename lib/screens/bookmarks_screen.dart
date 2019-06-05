import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped_models/group_scoped_model.dart';
import '../root_data.dart';
import '../models/word.dart';
import '../components/bookmark_list_item.dart';

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
