import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heads_up/helper/ad_helper.dart';
import 'package:heads_up/helper/dimensions.dart';

class ResultBannerAd extends StatefulWidget {
  const ResultBannerAd({super.key});

  @override
  State<ResultBannerAd> createState() => _ResultBannerAdState();
}

class _ResultBannerAdState extends State<ResultBannerAd> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _shouldReserveSpace = false;

  @override
  void initState() {
    super.initState();
    _loadBanner();
  }

  void _loadBanner() {
    final adUnitId = AdHelper.bannerAdUnitId;
    if (adUnitId.isEmpty) return;
    _shouldReserveSpace = true;

    final bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: AdHelper.request,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Failed to load a banner ad: ${error.message}');
          ad.dispose();
        },
      ),
    );

    _bannerAd = bannerAd;
    bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldReserveSpace) return const SizedBox.shrink();

    final bannerAd = _bannerAd;

    return SizedBox(
      height: AdSize.banner.height.toDouble() + Dimensions.height10,
      width: double.maxFinite,
      child: bannerAd != null && _isLoaded
          ? Padding(
              padding: EdgeInsets.only(bottom: Dimensions.height10),
              child: Center(
                child: SizedBox(
                  height: bannerAd.size.height.toDouble(),
                  width: bannerAd.size.width.toDouble(),
                  child: AdWidget(ad: bannerAd),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
