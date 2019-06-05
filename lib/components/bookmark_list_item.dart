import 'package:flutter/material.dart';
import 'package:vocab/root_data.dart';
import 'package:vocab/theme/constants.dart';
import '../models/word.dart';
import '../theme/vocab.dart';
import './word/word_definition.dart';

class BookMarkListItem extends StatelessWidget {
  final Word word;
  final bool bookmarkChangeSnackBarDisabled;
  BookMarkListItem({
    @required this.word,
    this.bookmarkChangeSnackBarDisabled,
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
                  IconButton(
                    icon: Icon(
                      Icons.bookmark,
                      color: ThemeConstants.bookMarkIconColor,
                    ),
                    onPressed: () {
                      rootdata.groups.toggleBookMark(word, context,
                          bookmarkChangeSnackBarDisabled != true);
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
