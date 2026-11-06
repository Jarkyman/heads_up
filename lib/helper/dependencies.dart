import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heads_up/controllers/categories_controller.dart';
import 'package:heads_up/controllers/event_controller.dart';
import 'package:heads_up/controllers/settings_controller.dart';
import 'package:heads_up/controllers/word_controller.dart';
import 'package:heads_up/repos/category_repo.dart';
import 'package:heads_up/repos/settings_repo.dart';
import 'package:heads_up/repos/word_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locale_handler.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  await LocaleHandler.initLanguages();

  Get.lazyPut(() => SettingsRepo(sharedPreferences: sharedPreferences));
  Get.lazyPut(() => CategoryRepo(sharedPreferences: sharedPreferences));
  Get.lazyPut(() => WordRepo(sharedPreferences: sharedPreferences));

  //Controller
  Get.lazyPut(() => SettingsController(settingsRepo: Get.find()));
  Get.lazyPut(() => CategoryController(categoryRepo: Get.find()));
  Get.lazyPut(() => WordController(wordRepo: Get.find()));
  Get.lazyPut(() => EventController());
}

Future<void> initializeAds() async {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    await MobileAds.instance.setSameAppKeyEnabled(false);
  }
  if (defaultTargetPlatform == TargetPlatform.android) {
    await const MethodChannel(
      'com.hartvigsolutions.hintmaster/privacy',
    ).invokeMethod<void>('disablePublisherFirstPartyId');
  }
  await MobileAds.instance.initialize().then((initializationStatus) {
    initializationStatus.adapterStatuses.forEach((key, value) {
      debugPrint('Adapter status for $key: ${value.description}');
    });
  });
  await MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(maxAdContentRating: MaxAdContentRating.pg),
  );
}
