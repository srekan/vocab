import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped_models/group_scoped_model.dart';
import '../models/group.dart';
import '../models/word.dart';
import '../models/review.dart';
import '../components/progress_chart.dart';
import '../components/app_drawer.dart';
import '../root_data.dart';

class DashBoardListViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<GroupScoppedModel>(
      model: rootdata.groups,
      child: ScopedModelDescendant<GroupScoppedModel>(
          builder: (context, child, model) {
        return _GroupsListContents(
          groups: model.groups,
          setActiveGroup: model.setActiveGroup,
          resetGroup: model.resetGroup,
          reviewMap: model.reviewMap,
          getReviewId: model.getReviewId,
        );
      }),
    );
  }
}

class _GroupsListContents extends StatelessWidget {
  final List<Group> groups;
  final Map<String, String> reviewMap;
  final Function setActiveGroup;
  final Function resetGroup;
  final Function getReviewId;
  _GroupsListContents({
    @required this.groups,
    @required this.setActiveGroup,
    @required this.resetGroup,
    @required this.reviewMap,
    @required this.getReviewId,
  });

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

  Widget _buildSubtitle(Group group, List<Word> words) {
    final masterWords = [];
    final otherWords = [];
    for (var word in words) {
      if (reviewMap[getReviewId(group, word)] == ReviewName.MASTERED) {
        masterWords.add(word);
      } else {
        otherWords.add(word);
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
                              height: 100.0,
                              width: 100.0,
                              disableDiscriptions: true,
                              group: group,
                            ),
                          ),
                          title: Text(
                            group.name,
                            style: Theme.of(context).textTheme.headline,
                          ),
                          subtitle: _buildSubtitle(group, group.words),
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
                                      resetGroup(group);
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
