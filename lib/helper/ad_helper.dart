import 'dart:io';

import 'package:get/get.dart';
import 'package:heads_up/controllers/settings_controller.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (!Get.find<SettingsController>().isUnlockAll) {
      if (Platform.isAndroid) {
        return '';
      } else if (Platform.isIOS) {
        return '';
      } else {
        throw new UnsupportedError('Unsupported platform');
      }
    } else {
      return 'No ad banner';
    }
  }

  static String get interstitialAdUnitId {
    if (!Get.find<SettingsController>().isUnlockAll) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-9894760850635221/7880130767';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-9894760850635221/3551941316';
      } else {
        throw new UnsupportedError("Unsupported platform");
      }
    } else {
      return "no ad interstitialAd";
    }
  }

  static String get rewardedAdUnitId {
    if (!Get.find<SettingsController>().isUnlockAll) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-9894760850635221/4870824043';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-9894760850635221/4268188814';
      } else {
        throw new UnsupportedError("Unsupported platform");
      }
    } else {
      return "no ad rewardedAd";
    }
  }
}

// TEST
/*
class AdHelper {
  static String get bannerAdUnitId {
    if (!Get.find<SettingsController>().isUnlockAll) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/2934735716';
      } else {
        throw UnsupportedError('Unsupported platform');
      }
    } else {
      return 'No ad banner';
    }
  }

  static String get interstitialAdUnitId {
    if (!Get.find<SettingsController>().isUnlockAll) {
      if (Platform.isAndroid) {
        return "ca-app-pub-3940256099942544/1033173712";
      } else if (Platform.isIOS) {
        return "ca-app-pub-3940256099942544/4411468910";
      } else {
        throw UnsupportedError("Unsupported platform");
      }
    } else {
      return "no ad interstitialAd";
    }
  }

  static String get rewardedAdUnitId {
    if (!Get.find<SettingsController>().isUnlockAll) {
      if (Platform.isAndroid) {
        return "ca-app-pub-3940256099942544/5224354917";
      } else if (Platform.isIOS) {
        return "ca-app-pub-3940256099942544/1712485313";
      } else {
        throw UnsupportedError("Unsupported platform");
      }
    } else {
      return "no ad RewardedAd";
    }
  }
}
*/
