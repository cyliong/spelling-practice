import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:spelling_practice/constants.dart';
import 'package:spelling_practice/model/language.dart';
import 'package:spelling_practice/model/spelling.dart';

class SpellingView extends StatelessWidget {
  const SpellingView({Key? key, required this.spelling}) : super(key: key);

  final Spelling spelling;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${spelling.title}'),
      subtitle: Text(DateFormat(kDateFormat).format(spelling.date)),
      trailing: Container(
        padding: const EdgeInsets.all(3.5),
        decoration: const BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Text(
          spelling.language == Languages.English.code ? 'English' : '中文',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
