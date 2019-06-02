import 'package:flutter/material.dart';
import '../models/group.dart';
import '../models/word.dart';
import '../models/review.dart';
import '../components/progress_chart.dart';
import '../theme/constants.dart';
import '../root_data.dart';

class GroupListItem extends StatelessWidget {
  final Group group;
  final Function setActiveGroup;
  GroupListItem({
    @required this.group,
    @required this.setActiveGroup,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: () {
              setActiveGroup(group, context);
            },
            splashColor: ThemeConstants.backgroundColor2,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: Row(
                children: <Widget>[
                  ProgressChart.fromGroup(
                    width: 100,
                    height: 100,
                    disableDiscriptions: true,
                    group: group,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        group.name,
                        style: Theme.of(context).textTheme.headline,
                      ),
                      _buildSubtitle(group, group.words)
                    ],
                  )
                ],
              ),
            ),
          ),
          ButtonTheme.bar(
            // make buttons use the appropriate styles for cards
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('Reset'),
                  onPressed: () {
                    _createResetGroupAlertDialog(context, group.name)
                        .then((value) {
                      if (value == 'RESET') {
                        rootdata.resetGroup(group);
                        /*
                          SnackBar snackBar = SnackBar(
                            content: Text('Group got reset.'),
                          );
                          
                        Scaffold.of(context)
                          .showSnackBar(snackBar);
                        */
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  Future<String> _createResetGroupAlertDialog(
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
}
