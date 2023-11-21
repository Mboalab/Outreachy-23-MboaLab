import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

Map localization = <String, Map>{};

class LocalizationService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {};

  static Future<void> initLanguages() async {
    final Map<String, Map<String, String>> keys = {};

    final languages = ['en_US', 'fr_FR'];

    for (final lang in languages) {
      final languageKeys = await readJson(lang);
      keys[lang] = languageKeys;
      localization[lang] = languageKeys;
    }

    Get.clearTranslations();
    Get.addTranslations(keys);
  }

  static Future<Map<String, String>> readJson(String languageCode) async {
    final res = await rootBundle.loadString('translations/$languageCode.json');
    final List<dynamic> data = jsonDecode(res);

    final languageKeys = <String, String>{};
    for (final entry in data) {
      final String key = entry['ResourceKey'];
      final String value = entry['ResourceValue'];
      languageKeys[key] = value;
    }
    return languageKeys;
  }
}
