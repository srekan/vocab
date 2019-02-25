import 'package:scoped_model/scoped_model.dart';
import '../models/group.model.dart';
import '../models/word.model.dart';
class GroupScoppedModel extends Model {
  List<Group> groups = [];

  GroupScoppedModel(){
    var group1 = Group();
    group1.name = 'basic';

    var group2 =Group();
    group2.name = 'common';

    groups.add(group1);
    groups.add(group2);
  }
}