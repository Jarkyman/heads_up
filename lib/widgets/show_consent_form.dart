import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> showConsentForm({
  bool isForTest = false,
  String? testDeviceId,
}) async {
  ConsentDebugSettings? debugSettings;
  if (isForTest) {
    debugSettings = ConsentDebugSettings(
      debugGeography: DebugGeography.debugGeographyEea,
      testIdentifiers: testDeviceId != null && testDeviceId.isNotEmpty
          ? [testDeviceId]
          : null,
    );
  }

  final params = ConsentRequestParameters(
    tagForUnderAgeOfConsent: false,
    consentDebugSettings: debugSettings,
  );

  final consentInfo = ConsentInformation.instance;
  final completer = Completer<void>();

  try {
    consentInfo.requestConsentInfoUpdate(
      params,
      () async {
        try {
          final status = await consentInfo.getConsentStatus();
          await ConsentForm.loadAndShowConsentFormIfRequired(
            (FormError? formError) {
              if (formError != null) {
                debugPrint(
                  'Consent form failed: ${_formatConsentError(formError)}',
                );
              } else {
                debugPrint('Consent form handled (status: $status)');
              }
            },
          );
        } catch (error) {
          debugPrint('Consent form exception: $error');
        } finally {
          if (!completer.isCompleted) {
            completer.complete();
          }
        }
      },
      (FormError error) async {
        ConsentStatus? status;
        try {
          status = await consentInfo.getConsentStatus();
        } catch (_) {
          status = null;
        }
        debugPrint(
          'Consent update failed: ${_formatConsentError(error)} '
          '(current status: $status)',
        );
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
    );
  } catch (error) {
    debugPrint('Consent update exception: $error');
    if (!completer.isCompleted) {
      completer.complete();
    }
  }

  return completer.future;
}

String _formatConsentError(FormError error) {
  return 'code ${error.errorCode}: ${error.message}';
}
