import 'package:flutter/material.dart';
import '../models/group.dart';
import '../components/app_drawer.dart';
import '../root_data.dart';
import '../scoped_models/group_scoped_model.dart';
import 'package:scoped_model/scoped_model.dart';
import './group_list_item.dart';
import './search_words.dart';

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

  @override
  Widget build(BuildContext context) {
    return ScopedModel<GroupScopedModel>(
        model: rootdata.groups,
        child: ScopedModelDescendant<GroupScopedModel>(
            builder: (context, child, model) {
          return Scaffold(
            drawer: isGlobalGroup == true ? AppDrawer() : null,
            appBar: AppBar(
                title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(pageTitle),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.bookmark_border),
                      onPressed: () {
                        Navigator.of(context).pushNamed('bookmarks');
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        // Navigator.of(context).pushNamed('search_words');
                        showSearch(
                          context: context,
                          delegate: SearchWords(),
                          query: '',
                        );
                      },
                    ),
                  ],
                ),
              ],
            )),
            body: SingleChildScrollView(
                child: Column(
              children: groups
                  .map(
                    (group) => GroupListItem(
                          group: group,
                          setActiveGroup: setActiveGroup,
                        ),
                  )
                  .toList(),
            )),
          );
        }));
  }
}
