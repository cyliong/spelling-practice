import 'package:flutter/material.dart';
import 'package:spelling_practice/repository/settings_repository.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _randomized = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Randomize playing order'),
            value: _randomized,
            onChanged: (bool value) {
              setState(() {
                _randomized = value;
              });
            },
            secondary: const Icon(Icons.playlist_play),
          ),
        ],
      ),
    );
  }

  void _loadSettings() async {
    final randomized = await SettingsRepository().isPlayOrderRandomized();
    setState(() {
      _randomized = randomized;
    });
  }
}
