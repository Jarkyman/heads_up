import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heads_up/helper/ad_helper.dart';
import 'package:heads_up/widgets/show_consent_form.dart';

class _ConsentInfo extends Fake implements ConsentInformation {
  @override
  Future<bool> canRequestAds() async => false;

  @override
  Future<PrivacyOptionsRequirementStatus>
  getPrivacyOptionsRequirementStatus() async =>
      PrivacyOptionsRequirementStatus.required;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'opening privacy options suspends ads until UMP allows requests',
    () async {
      final previous = ConsentInformation.instance;
      ConsentInformation.instance = _ConsentInfo();
      addTearDown(() => ConsentInformation.instance = previous);
      addTearDown(() => privacyOptionsRequired.value = false);
      addTearDown(() => AdHelper.setAdsAllowed(false));

      const channel = MethodChannel('plugins.flutter.io/google_mobile_ads/ump');
      final dismissed = Completer<void>();
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(channel, (call) async {
        expect(call.method, 'UserMessagingPlatform#showPrivacyOptionsForm');
        await dismissed.future;
        return null;
      });
      addTearDown(() => messenger.setMockMethodCallHandler(channel, null));

      AdHelper.setAdsAllowed(true);
      final dialog = showAdPrivacyOptions();

      expect(AdHelper.adsAllowed, isFalse);
      expect(AdHelper.bannerAdUnitId, isEmpty);
      expect(AdHelper.interstitialAdUnitId, isEmpty);
      expect(AdHelper.rewardedAdUnitId, isEmpty);
      dismissed.complete();
      expect(await dialog, isTrue);
      expect(AdHelper.adsAllowed, isFalse);
      expect(privacyOptionsRequired.value, isTrue);
    },
  );
}
