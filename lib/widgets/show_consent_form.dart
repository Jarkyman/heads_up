import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../helper/ad_helper.dart';
import '../helper/dependencies.dart';

final privacyOptionsRequired = ValueNotifier(false);
bool _adsInitialized = false;

Future<void> showConsentForm({
  bool isForTest = false,
  String? testDeviceId,
}) async {
  final info = ConsentInformation.instance;
  final updated = Completer<bool>();
  try {
    info.requestConsentInfoUpdate(
      ConsentRequestParameters(
        consentDebugSettings: isForTest
            ? ConsentDebugSettings(
                debugGeography: DebugGeography.debugGeographyEea,
                testIdentifiers: testDeviceId != null && testDeviceId.isNotEmpty
                    ? [testDeviceId]
                    : null,
              )
            : null,
      ),
      () => updated.complete(true),
      (error) {
        debugPrint('Consent update failed: ${error.message}');
        updated.complete(false);
      },
    );
    if (await updated.future) {
      await ConsentForm.loadAndShowConsentFormIfRequired((error) {
        if (error != null) debugPrint('Consent form failed: ${error.message}');
      });
    }
  } catch (error) {
    debugPrint('Could not refresh ad consent: $error');
  } finally {
    await _refreshAdPermission();
  }
}

Future<bool> showAdPrivacyOptions() async {
  AdHelper.setAdsAllowed(false);
  try {
    FormError? formError;
    await ConsentForm.showPrivacyOptionsForm((error) => formError = error);
    return formError == null;
  } catch (error) {
    debugPrint('Privacy options failed: $error');
    return false;
  } finally {
    await _refreshAdPermission();
  }
}

Future<void> _refreshAdPermission() async {
  final info = ConsentInformation.instance;
  try {
    privacyOptionsRequired.value =
        await info.getPrivacyOptionsRequirementStatus() ==
        PrivacyOptionsRequirementStatus.required;
  } catch (error) {
    debugPrint('Could not read privacy options requirement: $error');
  }
  try {
    if (!await info.canRequestAds()) return;
    if (!_adsInitialized) {
      await initializeAds();
      _adsInitialized = true;
    }
    AdHelper.setAdsAllowed(true);
  } catch (error) {
    debugPrint('Could not enable ads: $error');
  }
}
