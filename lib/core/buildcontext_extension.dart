import 'package:flutter/material.dart';
import 'package:song_flutter/page/page.dart';

extension GeneralBuildContext on BuildContext {
  Future onPushTextEditPage(String title) async {
    final page = TextEditPage(title: title);
    return await Navigator.push(this, MaterialPageRoute(builder: (_) => page));
  }
}
