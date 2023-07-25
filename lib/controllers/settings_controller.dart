import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../helper/app_constants.dart';
import '../repos/settings_repo.dart';

class SettingsController extends GetxController implements GetxService {
  final SettingsRepo settingsRepo;
  Locale _locale = const Locale('en', 'US');

  int _roundTime = 60;

  int get getRoundTime => _roundTime;

  bool _unlockAll = false;

  bool get isUnlockAll => _unlockAll;

  int _tries = 0;

  int get getTries => _tries;

  List<StoreProduct> _products = [];

  List<StoreProduct> get products => _products;

  SettingsController({required this.settingsRepo});

  final List<String> _productsIds = [AppConstants.UNLOCK_ALL_ID];

  Future<void> readSettings() async {
    _readLanguage();
    _readRoundTime();

    await initPlatformState();

    Purchases.addCustomerInfoUpdateListener(
      (_) => updateCustomerStatus(),
    );
    try {
      _products =
          await Purchases.getProducts(_productsIds, type: PurchaseType.inapp);
    } catch (e) {
      print(e);
      _products = [];
    }
    await triesPerDayRead();
    resetTries();

    update();
  }

  Future<List<StoreProduct>> get getProducts async {
    _products =
        await Purchases.getProducts(_productsIds, type: PurchaseType.inapp);
    return _products;
  }

  Future<void> initPlatformState() async {
    await Purchases.setDebugLogsEnabled(true);

    PurchasesConfiguration? configuration;
    if (Platform.isAndroid) {
      configuration =
          PurchasesConfiguration("goog_riiqamVOtnindMUXSiiPffyBYGG");
    } else if (Platform.isIOS) {
      configuration =
          PurchasesConfiguration("appl_WavSBwnfIhFtucnTxQxHiZUeZzR");
    }
    await Purchases.configure(configuration!);
  }

  Future updateCustomerStatus() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();

      final entitlementAds = customerInfo
          .entitlements.all[AppConstants.UNLOCK_ALL_ID_ENT]?.isActive;

      bool isUnlockAll = entitlementAds == true;
      unlockAllSave(isUnlockAll);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void _readLanguage() async {
    String localeString = await settingsRepo.languageSettingRead();
    List<String> localeList = localeString.toString().split('_');
    _locale = Locale(localeList[0], localeList[1]);
    Get.updateLocale(_locale);
  }

  void _readRoundTime() async {
    int time = await settingsRepo.roundTimeSettingRead();
    _roundTime = time;
  }

  Future<void> languageSettingsSave(String language) async {
    _locale = Locale(language.split('_')[0], language.split('_')[1]);
    settingsRepo.languageSettingsSave(language);
    Get.updateLocale(_locale);
  }

  Future<void> roundTimeSave(int time) async {
    _roundTime = time;
    settingsRepo.roundTimeSettingsSave(time);
  }

  Future<void> unlockAllRead() async {
    _unlockAll = await settingsRepo.unlockAllRead();
  }

  Future<void> unlockAllSave(bool unlockAll) async {
    _unlockAll = unlockAll;
    await settingsRepo.unlockAllSave(unlockAll);
    update();
  }

  Future<void> triesPerDayRead() async {
    _tries = await settingsRepo.triesPerDayRead();
  }

  Future<void> triesPerDaySave(int tries) async {
    _tries = tries;
    await settingsRepo.triesPerDaySave(tries);
    DateTime today = await getDateNow();
    //print('now $today');
    await settingsRepo.triesDateSave(today.toString());
    update();
  }

  Future<void> resetTries() async {
    DateTime today = await getDateNow();
    String loadRead = await settingsRepo.triesDateRead();
    //print('read $loadRead');
    DateTime old = DateTime.parse(loadRead).add(const Duration(days: 1));
    //DateTime old = DateTime.parse(loadRead).add(Duration(minutes: 1)); //TEST ONLY
    //print('Dif = ${old.difference(today)}');
    //print('?? = ${old.isBefore(today)}');
    if (old.isBefore(today)) {
      _tries = 0;
      settingsRepo.triesPerDaySave(0);
    }
    //print('Trys reset');
    update();
  }

  Future<Duration> getTimeToNewTry() async {
    DateTime today = await getDateNow();
    String loadRead = await settingsRepo.triesDateRead();
    //print('read $loadRead');
    DateTime old = DateTime.parse(loadRead).add(Duration(days: 1));
    //DateTime old = DateTime.parse(loadRead).add(Duration(minutes: 1)); //TEST ONLY
    //print('Dif = ${old.difference(today)}');
    return old.difference(today);
  }

  Future<DateTime> getDateNow() async {
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    Response response = await settingsRepo.getTime(currentTimeZone);
    //print(response.body);
    if (response.statusCode == 200) {
      return DateTime.parse(response.body['dateTime']);
    } else {
      return DateTime.now();
    }
  }
}
