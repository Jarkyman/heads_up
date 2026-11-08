import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../helper/ad_helper.dart';
import '../helper/dependencies.dart';

final privacyOptionsRequired = ValueNotifier(false);
Future<void>? _adsInitialization;
int _permissionRevision = 0;

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
  _permissionRevision++;
  AdHelper.setAdsAllowed(false);
  try {
    FormError? formError;
    await ConsentForm.showPrivacyOptionsForm((error) => formError = error);
    return formError == null;
  } catch (error) {
    debugPrint('Privacy options failed: $error');
    return false;
  } finally {
    unawaited(_refreshAdPermission());
  }
}

Future<void> _refreshAdPermission() async {
  final revision = ++_permissionRevision;
  final info = ConsentInformation.instance;
  try {
    final status = await info.getPrivacyOptionsRequirementStatus();
    if (revision != _permissionRevision) return;
    privacyOptionsRequired.value =
        status == PrivacyOptionsRequirementStatus.required;
  } catch (error) {
    debugPrint('Could not read privacy options requirement: $error');
  }
  try {
    if (revision != _permissionRevision ||
        !await info.canRequestAds() ||
        revision != _permissionRevision) {
      return;
    }
    final initialization = _adsInitialization ??= initializeAds();
    try {
      await initialization;
    } catch (_) {
      if (identical(_adsInitialization, initialization)) {
        _adsInitialization = null;
      }
      rethrow;
    }
    if (revision == _permissionRevision) AdHelper.setAdsAllowed(true);
  } catch (error) {
    debugPrint('Could not enable ads: $error');
  }
}
