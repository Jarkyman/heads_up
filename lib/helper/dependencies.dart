import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heads_up/controllers/categories_controller.dart';
import 'package:heads_up/controllers/event_controller.dart';
import 'package:heads_up/controllers/settings_controller.dart';
import 'package:heads_up/controllers/word_controller.dart';
import 'package:heads_up/repos/category_repo.dart';
import 'package:heads_up/repos/event_repo.dart';
import 'package:heads_up/repos/settings_repo.dart';
import 'package:heads_up/repos/word_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/api/api_client.dart';
import 'app_constants.dart';
import 'locale_handler.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    await MobileAds.instance.setSameAppKeyEnabled(false);
  }
  await MobileAds.instance.initialize().then((initializationStatus) {
    initializationStatus.adapterStatuses.forEach((key, value) {
      debugPrint('Adapter status for $key: ${value.description}');
    });
  });
  await MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      maxAdContentRating: MaxAdContentRating.pg,
    ),
  );
  if (defaultTargetPlatform == TargetPlatform.android) {
    try {
      await const MethodChannel('com.hartvigsolutions.hintmaster/privacy')
          .invokeMethod<void>('disablePublisherFirstPartyId');
    } on PlatformException catch (error) {
      debugPrint(
        'Could not disable the AdMob publisher first-party ID: $error',
      );
    }
  }
  await LocaleHandler.initLanguages();

  Get.lazyPut(
      () => ApiClient(appBaseUrl: '${AppConstants.TIME_API}Europe/Copenhagen'));

  //Repo
  Get.lazyPut(() => SettingsRepo(
      sharedPreferences: sharedPreferences, apiClient: Get.find()));
  Get.lazyPut(() => CategoryRepo(sharedPreferences: sharedPreferences));
  Get.lazyPut(() => WordRepo(sharedPreferences: sharedPreferences));
  Get.lazyPut(() => EventRepo(apiClient: Get.find()));

  //Controller
  Get.lazyPut(() => SettingsController(settingsRepo: Get.find()));
  Get.lazyPut(() => CategoryController(categoryRepo: Get.find()));
  Get.lazyPut(() => WordController(wordRepo: Get.find()));
  Get.lazyPut(() => EventController(eventRepo: Get.find()));
}
