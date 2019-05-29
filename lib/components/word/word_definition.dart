import 'package:flutter/material.dart';
import '../../models/word.dart';
// import '../../models/review.dart';

class WordDefinition extends StatelessWidget {
  final Word word;
  final String preferredLanguage;
  WordDefinition({
    @required this.word,
    @required this.preferredLanguage,
  });

  Widget _buildSynonyms(List<String> synonyms) {
    if (synonyms.length == 0) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Synonyms:',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.blueGrey,
          ),
        ),
        Text(synonyms.join(', '))
      ],
    );
  }

  Widget _buildExamples(List<String> examples) {
    if (examples.length == 0) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Examples:',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.blueGrey,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: examples.map((sy) {
            return Text('- ' + sy);
          }).toList(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: word.definitions.map((def) {
        return Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      def.otherLanguages[preferredLanguage],
                      style: Theme.of(context).textTheme.subhead.merge(
                            TextStyle(
                              color: Colors.indigo,
                            ),
                          ),
                    ),
                  ),
                ],
              ),
              Text(
                def.type.toLowerCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(def.definitionText),
              Container(height: 10.0),
              _buildExamples(def.examples),
              Container(height: 10.0),
              _buildSynonyms(def.synonyms),
            ],
          ),
        );
      }).toList(),
    );
  }
}
