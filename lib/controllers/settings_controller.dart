import "package:flutter/foundation.dart";
import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../helper/app_constants.dart';
import '../models/game_mode.dart';
import '../repos/settings_repo.dart';

class SettingsController extends GetxController implements GetxService {
  final SettingsRepo settingsRepo;
  Locale _locale = const Locale('en', 'US');

  int _roundTime = 60;

  int get getRoundTime => _roundTime;

  int _appLaunchCount = 0;

  int get appLaunchCount => _appLaunchCount;

  bool _unlockAll = false;

  bool get isUnlockAll => _unlockAll;

  GameMode _gameMode = GameMode.whoAmI;
  GameMode get gameMode => _gameMode;

  void setGameMode(GameMode mode) {
    _gameMode = mode;
    update();
  }

  int _tries = 0;

  int get getTries => _tries;

  List<StoreProduct> _products = [];

  List<StoreProduct> get products => _products;

  SettingsController({required this.settingsRepo});

  final List<String> _productsIds = [AppConstants.UNLOCK_ALL_ID];

  Future<void> readSettings() async {
    _readLanguage();
    _readRoundTime();
    await _registerAppLaunch();

    await initPlatformState();

    await unlockAllRead();

    Purchases.addCustomerInfoUpdateListener(
      (_) => updateCustomerStatus(),
    );
    updateCustomerStatus(); // Fetch from RevenueCat immediately on startup

    try {
      _products = await Purchases.getProducts(_productsIds,
          productCategory: ProductCategory.nonSubscription);
    } catch (e) {
      debugPrint(e.toString());
      _products = [];
    }
    await triesPerDayRead();
    resetTries();

    update();
  }

  Future<void> _registerAppLaunch() async {
    _appLaunchCount = settingsRepo.appLaunchCountRead() + 1;
    await settingsRepo.appLaunchCountSave(_appLaunchCount);
  }

  Future<List<StoreProduct>> get getProducts async {
    _products = await Purchases.getProducts(_productsIds,
        productCategory: ProductCategory.nonSubscription);
    return _products;
  }

  Future<void> initPlatformState() async {
    await Purchases.setLogLevel(LogLevel.debug);

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
      debugPrint(e.toString());
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
    await settingsRepo.roundTimeSettingsSave(time);
    update();
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
    //debugPrint('now $today');
    await settingsRepo.triesDateSave(today.toString());
    update();
  }

  Future<void> resetTries() async {
    DateTime today = await getDateNow();
    String loadRead = await settingsRepo.triesDateRead();
    //debugPrint('read $loadRead');
    DateTime old = DateTime.parse(loadRead).add(const Duration(days: 1));
    //DateTime old = DateTime.parse(loadRead).add(Duration(minutes: 1)); //TEST ONLY
    //debugPrint('Dif = ${old.difference(today)}');
    //debugPrint('?? = ${old.isBefore(today)}');
    if (old.isBefore(today)) {
      _tries = 0;
      settingsRepo.triesPerDaySave(0);
    }
    //debugPrint('Trys reset');
    update();
  }

  Future<Duration> getTimeToNewTry() async {
    DateTime today = await getDateNow();
    String loadRead = await settingsRepo.triesDateRead();
    //debugPrint('read $loadRead');
    DateTime old = DateTime.parse(loadRead).add(Duration(days: 1));
    //DateTime old = DateTime.parse(loadRead).add(Duration(minutes: 1)); //TEST ONLY
    //debugPrint('Dif = ${old.difference(today)}');
    return old.difference(today);
  }

  Future<DateTime> getDateNow() async {
    final String currentTimeZone =
        (await FlutterTimezone.getLocalTimezone()).identifier;
    Response response = await settingsRepo.getTime(currentTimeZone);
    //debugPrint(response.body);
    if (response.statusCode == 200) {
      return DateTime.parse(response.body['dateTime']);
    } else {
      return DateTime.now();
    }
  }
}
