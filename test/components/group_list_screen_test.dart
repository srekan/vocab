import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'dart:io';
import '../../lib/components/groups_list_screen.dart';
import '../../lib/components/group_list_item.dart';
import '../../lib/models/group.dart';

void main() {
  group('Group List Screen', () {
    var dmap;
    Finder groupsFinder;
    setUp(() async {
      final file = new File('test/models/sample_data.json');
      dmap = jsonDecode(await file.readAsString());
    });
    testWidgets('Should render grouplist screen', (WidgetTester tester) async {
      var groups = [
        Group.fromJson(dmap['groups'][0]),
        Group.fromJson(dmap['groups'][1]),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: GroupsListScreen(
            pageTitle: 'PageTitle',
            groups: groups,
            setActiveGroup: () {},
          ),
        ),
      );
      final titleFinder = find.text('PageTitle');
      expect(titleFinder, findsOneWidget);

      groupsFinder = find.byType(GroupListItem);
      expect(groupsFinder, findsNWidgets(2));
    });
  });
}
