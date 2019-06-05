import 'package:flutter/material.dart';
import 'package:vocab/theme/constants.dart';
import '../../models/word.dart';
import '../../theme/vocab.dart';

class BookmarkButton extends StatelessWidget {
  final Word word;
  final Map<String, bool> bookMarkMap;
  final Function toggleBookMark;
  final bool shouldShowSnackbar;
  BookmarkButton({
    @required this.word,
    @required this.bookMarkMap,
    @required this.toggleBookMark,
    this.shouldShowSnackbar,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Column(children: <Widget>[
        Text(
          bookMarkMap[word.id] == true ? 'Bookmarked' : 'Bookmark',
          style: themeVocab.textTheme.caption,
        ),
        bookMarkMap[word.id] == true
            ? Icon(
                Icons.bookmark,
                color: ThemeConstants.bookMarkIconColor,
                size: themeVocab.textTheme.display1.fontSize,
              )
            : Icon(
                Icons.bookmark_border,
                color: ThemeConstants.bookMarkIconColor,
                size: 40,
              ),
      ]),
      onPressed: () {
        toggleBookMark(word, context, shouldShowSnackbar);
      },
    );
  }
}
