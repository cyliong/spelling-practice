import 'package:spelling_practice/model/active_record.dart';

class Spelling extends ActiveRecord {
  Spelling({
    int? id,
    required this.title,
    required this.date,
    required this.language,
  }) : super(id: id);

  String title;
  DateTime date;
  String language;

  static const _tableName = 'spelling';
  static const _titleColumn = "title";
  static const _dateColumn = 'date';
  static const _languageColumn = 'language';

  @override
  String get tableName => _tableName;

  Spelling.fromMap(Map<String, Object?> map)
      : title = map[_titleColumn] as String,
        date = DateTime.fromMillisecondsSinceEpoch(map[_dateColumn] as int),
        language = map[_languageColumn] as String,
        super.fromMap(map);

  Map<String, Object?> toMap() {
    final map = super.toMap();
    map[_titleColumn] = title;
    map[_dateColumn] = date.millisecondsSinceEpoch;
    map[_languageColumn] = language;
    return map;
  }

  static Future<int> delete(int id) => ActiveRecord.delete(_tableName, id);

  static Future<int> deleteAll() => ActiveRecord.deleteAll(_tableName);

  static Future<Spelling?> find(int id) =>
      ActiveRecord.find(_tableName, id, (map) => Spelling.fromMap(map));

  static Future<List<Spelling>> findAll() => ActiveRecord.findAll(
        _tableName,
        (map) => Spelling.fromMap(map),
        orderBy: 'date DESC',
      );
}
