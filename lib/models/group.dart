import './word.dart';

class Group {
  String id;
  String name;
  List<Word> words = [];

  Group({this.id, this.name, this.words});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
    );
  }
}
