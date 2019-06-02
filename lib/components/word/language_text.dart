import 'package:flutter/material.dart';

class LanguageText extends StatelessWidget {
  final String text;
  LanguageText({
    @required this.text,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Text(
            text,
            style: Theme.of(context).textTheme.subhead.merge(
                  TextStyle(
                    color: Colors.indigo,
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
