import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:spelling_practice/constants.dart';
import 'package:spelling_practice/model/spelling.dart';

class SpellingView extends StatelessWidget {
  SpellingView({@required this.spelling});

  final Spelling spelling;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${spelling.title}'),
      subtitle: Text(DateFormat(kDateFormat).format(spelling.date)),
      trailing: Container(
        padding: EdgeInsets.all(3.5),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          spelling.language == kLanguageEnglish ? 'English' : '中文',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
