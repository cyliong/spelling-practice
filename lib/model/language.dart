class Language {
  const Language(this.code, this.name);

  final String code, name;
}

class Languages {
  Languages._();

  static const English = Language('en-US', 'English');
  static const Chinese = Language('zh-CN', 'Chinese');

  static const availableLanguages = [English, Chinese];
}
