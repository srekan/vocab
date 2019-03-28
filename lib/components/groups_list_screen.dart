import 'package:flutter/material.dart';
import '../models/group.dart';
import '../models/word.dart';
import '../models/review.dart';
import '../components/progress_chart.dart';
import '../components/app_drawer.dart';

class GroupsListScreen extends StatelessWidget {
  final String pageTitle;
  final List<Group> groups;
  final Function setActiveGroup;
  final Function resetGroup;
  final bool isGlobalGroup;
  GroupsListScreen({
    this.isGlobalGroup,
    @required this.groups,
    @required this.pageTitle,
    @required this.setActiveGroup,
    @required this.resetGroup,
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
    if (group.globalGroupId == '') {
      final count = group.reviewMap.entries.length / 2;
      return Text(count.toInt().toString() + ' Words');
    }
    int masterWordsCount = 0;
    int otherWordsCount = 0;
    int allWordsCount = 0;
    group.reviewMap.forEach((k, v) {
      if (v == ReviewName.MASTERED) {
        masterWordsCount++;
      } else {
        otherWordsCount++;
      }
      allWordsCount++;
    });

    if (masterWordsCount == allWordsCount) {
      return Text(
        'Mastered all ' + allWordsCount.toString() + ' words',
        style: TextStyle(
          color: ReviewColors.mastered,
        ),
      );
    }

    if (masterWordsCount == 0) {
      return Text(
        allWordsCount.toString() + ' words to be mastered',
      );
    }
    return Text(
      otherWordsCount.toString() +
          ' of ' +
          allWordsCount.toString() +
          ' words to be mastered',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: isGlobalGroup == true ? AppDrawer() : null,
      appBar: AppBar(
        title: Text('Groups'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: groups
            .map(
              (group) => Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Container(
                            child: ProgressChart.fromGroup(
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
                            setActiveGroup(group, context);
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
