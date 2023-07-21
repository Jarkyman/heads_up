import 'dart:io';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/api/api_client.dart';
import '../helper/app_constants.dart';

class SettingsRepo {
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;

  SettingsRepo({required this.sharedPreferences, required this.apiClient});

  Future<String> languageSettingRead() async {
    String language = sharedPreferences.getString(AppConstants.LANG) ??
        (AppConstants.LOCALE_LIST.contains(Platform.localeName)
            ? Platform.localeName
            : 'en_US');
    return language;
  }

  Future<bool> languageSettingsSave(String language) async {
    return await sharedPreferences.setString(AppConstants.LANG, language);
  }

  Future<int> roundTimeSettingRead() async {
    int time = sharedPreferences.getInt(AppConstants.ROUND_TIME) ?? 60;
    return time;
  }

  Future<void> roundTimeSettingsSave(int time) async {
    await sharedPreferences.setInt(AppConstants.ROUND_TIME, time);
  }

  Future<bool> unlockAllRead() async {
    bool unlockAll =
        sharedPreferences.getBool(AppConstants.UNLOCK_ALL) ?? false;
    return unlockAll;
  }

  Future<bool> unlockAllSave(bool unlockAll) async {
    return await sharedPreferences.setBool(AppConstants.UNLOCK_ALL, unlockAll);
  }

  Future<int> triesPerDayRead() async {
    int tries = sharedPreferences.getInt(AppConstants.TRIES) ?? 0;
    return tries;
  }

  Future<bool> triesPerDaySave(int tries) async {
    return await sharedPreferences.setInt(AppConstants.TRIES, tries);
  }

  Future<String> triesDateRead() async {
    String date = sharedPreferences.getString(AppConstants.TRIES_DATE) ??
        DateTime.now().toString();
    return date;
  }

  Future<bool> triesDateSave(String date) async {
    return await sharedPreferences.setString(AppConstants.TRIES_DATE, date);
  }

  Future<Response> getTime(String timeZone) async {
    String url = AppConstants.TIME_API + timeZone;
    return await apiClient.getData(url);
  }
}
