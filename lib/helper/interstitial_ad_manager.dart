import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heads_up/helper/ad_helper.dart';

class InterstitialAdManager {
  InterstitialAdManager({required this.enabled});

  final bool enabled;

  InterstitialAd? _ad;
  bool _isDisposed = false;
  bool _hasShown = false;
  int? _adRevision;

  void load() {
    final adUnitId = AdHelper.interstitialAdUnitId;
    if (!enabled || adUnitId.isEmpty || _isDisposed) return;

    final revision = AdHelper.consentRevision.value;
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: AdHelper.request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          if (_isDisposed || revision != AdHelper.consentRevision.value) {
            ad.dispose();
            return;
          }

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) => ad.dispose(),
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('Failed to show an interstitial ad: ${error.message}');
              ad.dispose();
            },
          );
          _adRevision = revision;
          _ad = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('Failed to load an interstitial ad: ${error.message}');
        },
      ),
    );
  }

  bool showIfReady() {
    final ad = _ad;
    if (ad == null ||
        _hasShown ||
        _isDisposed ||
        !AdHelper.adsAllowed ||
        _adRevision != AdHelper.consentRevision.value) {
      return false;
    }

    _hasShown = true;
    _ad = null;
    ad.show();
    return true;
  }

  void dispose() {
    _isDisposed = true;
    _ad?.dispose();
    _ad = null;
  }
}
