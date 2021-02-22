import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:spelling_practice/component/spelling_view.dart';
import 'package:spelling_practice/component/vocabulary_list_view.dart';
import 'package:spelling_practice/model/spelling.dart';
import 'package:spelling_practice/model/vocabulary.dart';
import 'package:spelling_practice/repository/settings_repository.dart';

class PlayPage extends StatefulWidget {
  PlayPage({@required this.spelling});

  final Spelling spelling;

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  Future<List<Vocabulary>> _vocabularyList;

  int _vocabularyIndex = 0;
  bool _spellingDone = false;

  @override
  void initState() {
    super.initState();
    _loadVocabularyList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_spellingDone ? 'Review' : 'Play'} Spelling'),
      ),
      body: Center(
        child: FutureBuilder<List<Vocabulary>>(
          future: _vocabularyList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  Card(
                    child: SpellingView(
                      spelling: widget.spelling,
                    ),
                  ),
                  Expanded(
                    child: _spellingDone
                        ? VocabularyListView(
                            vocabularyList: snapshot.data,
                            language: widget.spelling.language,
                          )
                        : _buildPlayer(snapshot.data),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget _buildPlayer(List<Vocabulary> vocabularyList) {
    if (vocabularyList.length == 0) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Nothing to play',
              style: TextStyle(fontSize: 30, color: Colors.grey),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Please add vocabulary to this spelling.',
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      );
    }

    Vocabulary vocabulary = vocabularyList[_vocabularyIndex];

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SizedBox(
                height: 200,
                width: 200,
                child: CircularProgressIndicator(
                  strokeWidth: 20,
                  value: (_vocabularyIndex + 1) / vocabularyList.length,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  backgroundColor: Colors.black26,
                ),
              ),
              SizedBox(
                height: 130,
                width: 130,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 12,
                    shape: CircleBorder(),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.record_voice_over,
                        size: 80,
                      ),
                      Text(
                        'Play',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  onPressed: () async {
                    FlutterTts tts = FlutterTts();
                    await tts.setLanguage(widget.spelling.language);
                    await tts.speak(vocabulary.vocabulary);
                  },
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Text(
              '${_vocabularyIndex + 1} of ${vocabularyList.length}',
              style: TextStyle(fontSize: 30),
            ),
          ),
          _buildNextButton(_vocabularyIndex == vocabularyList.length - 1),
        ],
      ),
    );
  }

  ElevatedButton _buildNextButton(bool isLastIndex) {
    return ElevatedButton(
      child: Text(
        isLastIndex ? 'Review' : 'Next',
      ),
      onPressed: () {
        setState(() {
          if (isLastIndex) {
            _spellingDone = true;
          } else {
            _vocabularyIndex++;
          }
        });
      },
    );
  }

  void _loadVocabularyList() async {
    final randomized = await SettingsRepository().isPlayOrderRandomized();
    setState(() {
      _vocabularyList = Vocabulary.findAll(
        spellingId: widget.spelling.id,
        random: randomized,
      );
    });
  }
}
