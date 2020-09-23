import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:spelling_practice/constants.dart';
import 'package:spelling_practice/model/language.dart';
import 'package:spelling_practice/model/spelling.dart';
import 'package:spelling_practice/model/vocabulary.dart';

class EditPage extends StatefulWidget {
  EditPage({this.title, this.spelling});

  final String title;
  final Spelling spelling;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _titleController = TextEditingController();
  final _vocabularyControllers = List<TextEditingController>();

  int _vocabularyCount = 0;

  Future<List<Vocabulary>> _vocabularyList;
  bool _vocabularyListInitialized = false;

  bool _isNew = true;

  bool _saveButtonEnabled = false;

  DateTime _date;
  String _language;

  @override
  void initState() {
    super.initState();

    _isNew = widget.spelling == null;

    _titleController.addListener(() {
      setState(() {
        _saveButtonEnabled = _titleController.text?.trim()?.isNotEmpty ?? false;
      });
    });

    if (_isNew) {
      _date = DateTime.now();
      _language = Languages.English.code;
    } else {
      _titleController.text = widget.spelling.title;

      _date = widget.spelling.date;
      _language = widget.spelling.language;

      _vocabularyList = Vocabulary.findAll(
        spellingId: widget.spelling.id,
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _vocabularyControllers.forEach((controller) {
      controller.dispose();
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 5,
            ),
            child: FlatButton(
              child: Text('SAVE'),
              textColor: Colors.white,
              onPressed: _saveButtonEnabled
                  ? () async {
                      final spelling = Spelling(
                        title: _titleController.text,
                        date: _date,
                        language: _language,
                      );

                      if (_isNew) {
                        final spellingId = await spelling.insert();
                        if (spellingId > 0) {
                          await _insertVocabularyList(spellingId);
                        }
                      } else {
                        spelling.id = widget.spelling.id;
                        await spelling.update();
                        await Vocabulary.deleteAll(spellingId: spelling.id);
                        await _insertVocabularyList(spelling.id);
                      }

                      Navigator.pop(context, spelling);
                    }
                  : null,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _titleController,
                      autofocus: true,
                      decoration: InputDecoration(hintText: 'Title'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 100,
                          child: const Text('Spelling Date'),
                        ),
                        RaisedButton(
                          child: Text(DateFormat(kDateFormat).format(_date)),
                          onPressed: () async {
                            final DateTime selectedDate = await showDatePicker(
                              context: context,
                              initialDate: _date,
                              firstDate: DateTime(2018),
                              lastDate: DateTime(2030),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                _date = selectedDate;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 100,
                          child: const Text('Language'),
                        ),
                        DropdownButton<String>(
                          value: _language,
                          items: [
                            DropdownMenuItem<String>(
                              value: Languages.English.code,
                              child: Text(Languages.English.name),
                            ),
                            DropdownMenuItem<String>(
                              value: Languages.Chinese.code,
                              child: Text(Languages.Chinese.name),
                            ),
                          ],
                          onChanged: (newValue) =>
                              setState(() => _language = newValue),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _isNew
                ? _buildVocabularyListWidget()
                : FutureBuilder<List<Vocabulary>>(
                    future: _vocabularyList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return _buildVocabularyListWidget(snapshot.data);
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return CircularProgressIndicator();
                    },
                  ),
            FlatButton.icon(
              padding: EdgeInsets.all(15),
              onPressed: () {
                setState(() {
                  _vocabularyCount++;
                });
              },
              icon: Icon(
                Icons.add_circle,
                color: Colors.blue,
              ),
              label: Text('Add vocabulary'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _insertVocabularyList(int spellingId) async {
    _vocabularyControllers.forEach((controller) async {
      final text = controller.text;
      if (text?.trim()?.isNotEmpty ?? false) {
        await Vocabulary(
          vocabulary: text,
          spellingId: spellingId,
        ).insert();
      }
    });
  }

  Widget _buildVocabularyListWidget([List<Vocabulary> vocabularyList]) {
    if (vocabularyList != null && !_vocabularyListInitialized) {
      _vocabularyCount = vocabularyList.length;
      vocabularyList.forEach((vocabulary) {
        _vocabularyControllers
            .add(TextEditingController(text: vocabulary.vocabulary));
      });

      _vocabularyListInitialized = true;
    }

    if (_vocabularyControllers.length < _vocabularyCount) {
      for (int i = _vocabularyControllers.length; i < _vocabularyCount; i++) {
        _vocabularyControllers.add(TextEditingController());
      }
    }

    return Column(
      children: _vocabularyControllers
          .map<Widget>((TextEditingController controller) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: controller,
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _vocabularyCount--;
                    _vocabularyControllers.remove(controller);
                  });
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
