class Helper {
  static const String chineseRegex = "[\\u4e00-\\u9fa5]";
  static final RegExp chineseRegexp = RegExp(chineseRegex);

  /// 判断某个字符是否为汉字
  /// @return 是汉字返回true，否则返回false
  static bool isChinese(String c) {
    return '〇' == c || chineseRegexp.hasMatch(c);
  }
}
