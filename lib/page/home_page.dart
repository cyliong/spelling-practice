import 'package:flutter/material.dart';
import 'package:spelling_practice/component/spelling_view.dart';
import 'package:spelling_practice/model/spelling.dart';
import 'package:spelling_practice/model/vocabulary.dart';
import 'package:spelling_practice/page/edit_page.dart';
import 'package:spelling_practice/page/play_page.dart';
import 'package:spelling_practice/page/settings_page.dart';
import 'package:spelling_practice/page/view_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Spelling>> _spellingList;

  @override
  void initState() {
    super.initState();

    _spellingList = Spelling.findAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
          ),
          IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add Spelling',
              onPressed: () async {
                final Spelling? spelling = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPage(
                      title: 'New Spelling',
                    ),
                  ),
                );

                if (spelling != null) {
                  setState(() {
                    _spellingList = Spelling.findAll();
                  });
                }
              }),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Spelling>>(
          future: _spellingList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final spellingList = snapshot.data!;
              return spellingList.isEmpty
                  ? Text('No Spellings',
                      style: TextStyle(fontSize: 30, color: Colors.grey))
                  : _buildListView(spellingList);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  ListView _buildListView(List<Spelling> spellingList) {
    return ListView.builder(
      itemCount: spellingList.length,
      itemBuilder: (context, index) {
        final Spelling spelling = spellingList[index];

        return Dismissible(
          key: Key('spelling_dismissible_${spelling.id}'),
          confirmDismiss: (direction) async {
            return await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Delete this spelling?'),
                    content: Text('${spelling.title}'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('No'),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      TextButton(
                        child: Text('Yes'),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ],
                  );
                });
          },
          onDismissed: (direction) async {
            await Spelling.delete(spelling.id!);
            await Vocabulary.deleteAll(spellingId: spelling.id);
            setState(() {
              spellingList.removeAt(index);
            });
          },
          child: Card(
            child: Column(
              children: <Widget>[
                SpellingView(
                  spelling: spelling,
                ),
                ButtonBar(
                  children: <Widget>[
                    TextButton(
                      child: const Text('EDIT'),
                      onPressed: () async {
                        final Spelling? updatedSpelling = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPage(
                              title: 'Edit Spelling',
                              spelling: spelling,
                            ),
                          ),
                        );

                        if (updatedSpelling != null) {
                          setState(() {
                            _spellingList = Spelling.findAll();
                          });
                        }
                      },
                    ),
                    TextButton(
                      child: const Text('VIEW'),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewPage(spelling: spelling),
                          ),
                        );
                      },
                    ),
                    TextButton(
                      child: const Text('PLAY'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayPage(
                              spelling: spelling,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
