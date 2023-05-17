import 'dart:convert';

import 'package:dedepos/global.dart';
import 'package:dedepos/global_model.dart';
import 'package:flutter/services.dart';

Future<void> initLanguage() async {
  languageSystemCode =
      (json.decode(await rootBundle.loadString('assets/language.json')) as List)
          .map((i) => LanguageSystemCodeModel.fromJson(i))
          .toList();
  languageSystemCode.sort((a, b) {
    return a.code.compareTo(b.code);
  });
}
