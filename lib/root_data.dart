import 'dart:async';
import 'package:flutter/material.dart';
import './scoped_models/group_scoped_model.dart';
import './models/group.dart';

class _RootData {
  final String title = 'Vocabulary App';
  bool isAppInitialized = false;
  BuildContext _context;
  GroupScopedModel groups = GroupScopedModel();

  initApp(BuildContext context) async {
    _context = context;
    isAppInitialized = true;
    Timer(const Duration(milliseconds: 1000), () {
      Navigator.of(_context).pushReplacementNamed('dash_board');
    });
  }

  resetGroup(Group group) {
    groups.resetGroup(group);
  }
}

final rootdata = _RootData();
