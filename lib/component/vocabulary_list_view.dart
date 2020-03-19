import 'package:flutter/material.dart';
import 'package:spelling_practice/model/vocabulary.dart';

class VocabularyListView extends StatelessWidget {
  VocabularyListView({@required this.vocabularyList});

  final List<Vocabulary> vocabularyList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 18),
              child: Text('${vocabularyList[index].vocabulary}'));
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: vocabularyList.length);
  }
}
