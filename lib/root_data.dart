import 'dart:async';
import 'package:flutter/material.dart';
import './scoped_models/group_scoped_model.dart';

class _RootData {
  final String title = 'Vocabulary App';
  bool isAppInitialized = false;
  BuildContext _context;
  GroupScoppedModel groups = GroupScoppedModel();

  initApp(BuildContext context) {
    _context = context;
    isAppInitialized = true;
    Timer(const Duration(milliseconds: 1000), () {
      Navigator.of(_context).pushNamed('dash_board');
    });
  }
}

final rootdata = _RootData();
