import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocab/models/review.dart';
import '../components/bookmark_list_item.dart';
import '../theme/constants.dart';
import '../root_data.dart';
import '../models/word.dart';

class SearchWordsScreen extends StatefulWidget {
  @override
  _ListViewState createState() => new _ListViewState();
}

class _ListViewState extends State<SearchWordsScreen> {
  List<Word> words = [];
  String query = '';
  TextEditingController searchTextInputController = TextEditingController();
  @override
  void initState() {
    super.initState();
    var reviewMap = rootdata.groups.reviewMap;
    print(reviewMap);
    rootdata.groups.groups.forEach((group) {
      group.words.forEach((word) {
        if (ReviewName.MASTERED ==
            reviewMap[rootdata.groups.getReviewId(group, word)]) {
          words.add(word);
        }
      });
    });
    searchTextInputController.addListener(() {
      setState(() {
        query = searchTextInputController.text;
        _updateWords();
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    searchTextInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var bookMarkMap = rootdata.groups.bookMarkMap;

    return Scaffold(
        appBar: AppBar(
          title: ListTile(
            title: Container(
              child: TextField(
                controller: searchTextInputController,
                decoration: InputDecoration(hintText: 'Search'),
              ),
            ),
            trailing: Container(
              width: 50,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(CupertinoIcons.clear_thick),
                    onPressed: () {
                      setState(() {
                        searchTextInputController.text = '';
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: words
                  .map<Widget>((Word word) => ListTile(
                        title: Text(word.wordText),
                        leading: IconButton(
                          icon: bookMarkMap[word.id] == null
                              ? Icon(
                                  Icons.bookmark_border,
                                  color: ThemeConstants.bookMarkIconColor,
                                )
                              : Icon(
                                  Icons.bookmark,
                                  color: ThemeConstants.bookMarkIconColor,
                                ),
                          onPressed: () {
                            rootdata.groups
                                .toggleBookMark(word, context, false);
                            setState(() {});
                          },
                        ),
                        trailing: Text(word.tags[0]),
                        onTap: () {
                          _createWordDetailDialog(context, word);
                        },
                      ))
                  .toList(),
            )));
  }

  _updateWords() {
    words = rootdata.groups.words;
    if (query != '') {
      words = rootdata.groups.words.where((Word word) {
        return word.wordText.contains(query);
      }).toList();
    }
  }

  Future<String> _createWordDetailDialog(BuildContext context, Word word) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(12),
            // title: Text('Title'),
            content: BookMarkListItem(
              word: word,
              bookmarkChangeSnackBarDisabled: true,
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 8.0,
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop('CANCEL');
                },
              )
            ],
          );
        });
  }
}
