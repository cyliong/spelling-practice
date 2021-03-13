// @dart=2.9

import 'package:flutter/material.dart';
import 'package:spelling_practice/component/spelling_view.dart';
import 'package:spelling_practice/component/vocabulary_list_view.dart';
import 'package:spelling_practice/model/spelling.dart';
import 'package:spelling_practice/model/vocabulary.dart';

class ViewPage extends StatefulWidget {
  ViewPage({@required this.spelling});

  final Spelling spelling;

  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  Spelling _spelling;

  Future<List<Vocabulary>> _vocabularyList;

  @override
  void initState() {
    super.initState();

    _spelling = widget.spelling;
    _vocabularyList = Vocabulary.findAll(
      spellingId: _spelling.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Spelling'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: SpellingView(
              spelling: _spelling,
            ),
          ),
          Expanded(
            child: Center(
              child: FutureBuilder<List<Vocabulary>>(
                future: _vocabularyList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return VocabularyListView(
                      vocabularyList: snapshot.data,
                      language: _spelling.language,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
