import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heads_up/helper/ad_helper.dart';
import 'package:heads_up/widgets/show_consent_form.dart';

class _ConsentInfo extends Fake implements ConsentInformation {
  final permissionCheck = Completer<bool>();

  @override
  Future<bool> canRequestAds() => permissionCheck.future;

  @override
  Future<PrivacyOptionsRequirementStatus>
  getPrivacyOptionsRequirementStatus() async =>
      PrivacyOptionsRequirementStatus.required;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'privacy options can reopen while ad permission is being refreshed',
    () async {
      final previous = ConsentInformation.instance;
      final info = _ConsentInfo();
      ConsentInformation.instance = info;
      addTearDown(() => ConsentInformation.instance = previous);
      addTearDown(() => privacyOptionsRequired.value = false);
      addTearDown(() => AdHelper.setAdsAllowed(false));

      const channel = MethodChannel('plugins.flutter.io/google_mobile_ads/ump');
      final dismissed = Completer<void>();
      var presentations = 0;
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(channel, (call) async {
        expect(call.method, 'UserMessagingPlatform#showPrivacyOptionsForm');
        presentations++;
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
      expect(await showAdPrivacyOptions(), isTrue);
      expect(presentations, 2);
      info.permissionCheck.complete(false);
      await Future<void>.delayed(Duration.zero);
      expect(AdHelper.adsAllowed, isFalse);
      expect(privacyOptionsRequired.value, isTrue);
    },
  );
}
