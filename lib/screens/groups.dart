import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scopped_models/group.scopped_model.dart';
import '../models/group.model.dart';

class GroupsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<GroupScoppedModel>(
      model: groupScoppedModelInstance,
      child: _GroupsScreenContents(),
    );
  }
}

class _GroupsScreenContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Group> groups =
        ScopedModel.of<GroupScoppedModel>(context, rebuildOnChange: true)
            .groups;
    final Function setActiveGroup =
        ScopedModel.of<GroupScoppedModel>(context, rebuildOnChange: true)
            .setActiveGroup;
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
      ),
      body: Center(
          child: ListView(
        children: groups
            .map((el) => Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.folder),
                        title: Text(el.name),
                        subtitle: Text('${el.words.length} words to master'),
                        onTap: () {
                          setActiveGroup(el);
                          Navigator.of(context).pushNamed('group_detail');
                        },
                      ),
                      ButtonTheme.bar(
                        // make buttons use the appropriate styles for cards
                        child: ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: Text('Reset'),
                              onPressed: () {},
                            ),
                            FlatButton(
                              child: const Text('Complete'),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      )),
    );
  }
}
