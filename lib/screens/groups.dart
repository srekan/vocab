import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scopped_models/group.scopped_model.dart';
import '../models/group.model.dart';
import '../models/word.model.dart';
import '../models/review.dart';
import '../components/progress_chart.dart';
import '../components/app_drawer.dart';
import '../root_data.dart';

class GroupsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<GroupScoppedModel>(
      model: RootData.groups,
      child: _GroupsScreenContents(),
    );
  }
}

class _GroupsScreenContents extends StatelessWidget {
  Future<String> createResetGroupAlertDialog(
      BuildContext context, String groupName) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Resetting Group "$groupName"'),
            content: Text(
                'Your progress on this group will be deleted. Are you sure you want to reset?'),
            actions: <Widget>[
              MaterialButton(
                elevation: 8.0,
                child: Text('Yes Reset Group'),
                onPressed: () {
                  Navigator.of(context).pop('RESET');
                },
              ),
              MaterialButton(
                elevation: 8.0,
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop('CANCEL');
                },
              )
            ],
          );
        });
  }

  Widget _buildSubtitle(List<Word> words) {
    final masterWords = [];
    final otherWords = [];
    for (var item in words) {
      if (item.learingReview.markName == ReviewName.MASTERED) {
        masterWords.add(item);
      } else {
        otherWords.add(item);
      }
    }

    if (masterWords.length == words.length) {
      return Text(
        'Mastered all ${words.length} words',
        style: TextStyle(
          color: ReviewColors.mastered,
        ),
      );
    }

    if (masterWords.length == 0) {
      return Text(
        '${words.length} words to be mastered',
      );
    }
    return Text(
      '${otherWords.length} of ${words.length} words to be mastered',
    );
  }

  @override
  Widget build(BuildContext context) {
    final model =
        ScopedModel.of<GroupScoppedModel>(context, rebuildOnChange: true);
    final List<Group> groups = model.groups;
    final Function setActiveGroup = model.setActiveGroup;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Groups'),
      ),
      body: Center(
          child: ListView(
        children: groups
            .map(
              (group) => Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Container(
                            child: ProgressChart.withWordsData(
                              words: group.words,
                              height: 100.0,
                              width: 100.0,
                              disableDiscriptions: true,
                            ),
                          ),
                          title: Text(
                            group.name,
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          subtitle: _buildSubtitle(group.words),
                          onTap: () {
                            setActiveGroup(group);
                            Navigator.of(context).pushNamed('group_detail');
                          },
                        ),
                        ButtonTheme.bar(
                          // make buttons use the appropriate styles for cards
                          child: ButtonBar(
                            children: <Widget>[
                              FlatButton(
                                child: Text('Reset'),
                                onPressed: () {
                                  createResetGroupAlertDialog(
                                          context, group.name)
                                      .then((value) {
                                    if (value == 'RESET') {
                                      model.resetGroup(group);
                                      SnackBar snackBar = SnackBar(
                                        content: Text('Group got reset.'),
                                      );
                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
            )
            .toList(),
      )),
    );
  }
}
