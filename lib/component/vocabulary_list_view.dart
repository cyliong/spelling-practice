import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:spelling_practice/model/vocabulary.dart';

class VocabularyListView extends StatelessWidget {
  const VocabularyListView({
    Key? key,
    required this.vocabularyList,
    required this.language,
  }) : super(key: key);

  final List<Vocabulary> vocabularyList;
  final String language;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          final vocabulary = vocabularyList[index].vocabulary;

          return ListTile(
            title: Text(vocabulary),
            trailing: Ink(
              decoration: const ShapeDecoration(
                color: Colors.lightBlue,
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: const Icon(Icons.record_voice_over),
                color: Colors.white,
                onPressed: () async {
                  FlutterTts tts = FlutterTts();
                  await tts.setLanguage(language);
                  await tts.speak(vocabulary);
                },
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: vocabularyList.length);
  }
}
