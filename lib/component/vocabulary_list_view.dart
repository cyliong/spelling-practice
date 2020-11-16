import 'package:flutter/material.dart';
import 'package:spelling_practice/model/vocabulary.dart';

class VocabularyListView extends StatelessWidget {
  VocabularyListView({@required this.vocabularyList});

  final List<Vocabulary> vocabularyList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${vocabularyList[index].vocabulary}'),
            trailing: IconButton(
              icon: Icon(Icons.record_voice_over),
              onPressed: () {},
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: vocabularyList.length);
  }
}
