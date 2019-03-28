import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped_models/group_scoped_model.dart';
import '../root_data.dart';
import '../components/groups_list_screen.dart';
import '../models/group.dart';

class DashBoardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<GroupScoppedModel>(
      model: rootdata.groups,
      child: ScopedModelDescendant<GroupScoppedModel>(
          builder: (context, child, model) {
        return GroupsListScreen(
          isGlobalGroup: true,
          pageTitle: 'Dash board',
          groups: model.globalGroups,
          resetGroup: model.resetGroup,
          setActiveGroup: (Group globalGroup, BuildContext context) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  final List<Group> subGroups = [];
                  for (var gId in globalGroup.subGroupIds) {
                    subGroups.add(rootdata.groups.groupsMap[gId]);
                  }
                  return GroupsListScreen(
                    pageTitle: globalGroup.name,
                    groups: subGroups,
                    isGlobalGroup: false,
                    resetGroup: model.resetGroup,
                    setActiveGroup: (Group group, BuildContext context) {
                      model.setActiveGroup(group, context);
                    },
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}
