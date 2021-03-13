import 'package:spelling_practice/model/active_record.dart';

class Vocabulary extends ActiveRecord {
  Vocabulary({
    int? id,
    required this.vocabulary,
    required this.spellingId,
  }) : super(id: id);

  String vocabulary;
  int spellingId;

  static const _tableName = 'vocabulary';
  static const _vocabularyColumn = "vocabulary";
  static const _spellingIdColumn = "spelling_id";

  @override
  String get tableName => _tableName;

  Vocabulary.fromMap(Map<String, dynamic> map)
      : vocabulary = map[_vocabularyColumn],
        spellingId = map[_spellingIdColumn],
        super.fromMap(map);

  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map[_vocabularyColumn] = vocabulary;
    map[_spellingIdColumn] = spellingId;
    return map;
  }

  static Future<int> delete(int id) => ActiveRecord.delete(_tableName, id);

  static Future<int> deleteAll({int? spellingId}) {
    String? where;
    List<dynamic>? whereArgs;

    if (spellingId != null) {
      where = '$_spellingIdColumn = ?';
      whereArgs = [spellingId];
    }

    return ActiveRecord.deleteAll(
      _tableName,
      where: where,
      whereArgs: whereArgs,
    );
  }

  static Future<Vocabulary?> find(int id) =>
      ActiveRecord.find(_tableName, id, (map) => Vocabulary.fromMap(map));

  static Future<List<Vocabulary>> findAll({
    int? spellingId,
    bool random = false,
  }) {
    String? where;
    List<dynamic>? whereArgs;
    String? orderBy;

    if (spellingId != null) {
      where = '$_spellingIdColumn = ?';
      whereArgs = [spellingId];
    }

    if (random) {
      orderBy = 'random()';
    }

    return ActiveRecord.findAll(
      _tableName,
      (map) => Vocabulary.fromMap(map),
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );
  }
}
