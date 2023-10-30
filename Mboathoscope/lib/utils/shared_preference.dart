import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static Future saveUserDetails(Map userDetails) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setString('userDetails', json.encode(userDetails));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<Map<String, dynamic>> readUserDetails() async {
    final prefs = await SharedPreferences.getInstance();

    return await json.decode(prefs.getString('userDetails')!);
  }

  static removeUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userDetails');
  }

  static Future<bool> userIsSaved() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userDetails') != null) {
      return true;
    } else {
      return false;
    }
  }
}
