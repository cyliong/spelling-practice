import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:spelling_practice/model/vocabulary.dart';

class VocabularyListView extends StatelessWidget {
  VocabularyListView({@required this.vocabularyList});

  final List<Vocabulary> vocabularyList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          final vocabulary = vocabularyList[index].vocabulary;

          return ListTile(
            title: Text(vocabulary),
            trailing: IconButton(
              icon: Icon(Icons.record_voice_over),
              onPressed: () async {
                FlutterTts tts = FlutterTts();
                await tts.speak(vocabulary);
              },
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: vocabularyList.length);
  }
}
