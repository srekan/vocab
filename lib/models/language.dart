enum LanguageList {
  TELUGU,
  TAMIL,
  HINDI,
  MALAYALAM,
}

class Language {
  static LanguageList getLanguageByString(String lang) {
    switch (lang.toUpperCase()) {
      case 'TELUGU':
        return LanguageList.TELUGU;
      case 'TAMIL':
        return LanguageList.TAMIL;
      case 'HINDI':
        return LanguageList.HINDI;
      case 'MALAYALAM':
        return LanguageList.MALAYALAM;
      default:
        return LanguageList.TELUGU;
    }
  }
}
