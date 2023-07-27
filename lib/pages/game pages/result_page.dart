import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heads_up/background_image.dart';
import 'package:heads_up/controllers/settings_controller.dart';
import 'package:heads_up/helper/dimensions.dart';
import 'package:heads_up/pages/game%20pages/word_page.dart';
import 'package:heads_up/widgets/icon_button.dart';

import '../../controllers/review_controller.dart';
import '../../helper/ad_helper.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  ScrollController _controller = ScrollController();
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);*/
    _loadInterstitialAd();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int sec = (Get.arguments[2].length / 2).ceil();
      _controller.animateTo(_controller.position.maxScrollExtent,
          duration: Duration(seconds: sec), curve: Curves.ease);
    });
    super.initState();
  }

  @override
  dispose() {
    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);*/
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _loadInterstitialAd() {
    if (!Get.find<SettingsController>().isUnlockAll) {
      InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                //_loadInterstitialAd();
              },
            );
            setState(() {
              _interstitialAd = ad;
            });
          },
          onAdFailedToLoad: (err) {
            print('Failed to load an interstitial ad: ${err.message}');
          },
        ),
      );
    }
  }

  void isGuessed(String word) {
    word.replaceFirstMapped('#', (match) => '');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Duration(seconds: 2).delay(() {
      //_interstitialAd?.show(); //TODO: Tilføj reklame igen
      ReviewController.checkReviewPopup(context);
    });
    return Scaffold(
      body: BackgroundImage(
        child: SafeArea(
          child: Center(
            child: Stack(
              children: [
                Positioned(
                  top: Dimensions.height20,
                  left: Dimensions.width20,
                  child: IconBtn(
                    onTap: () => Get.back(),
                    icon: Icons.close,
                  ),
                ),
                if (Get.arguments[3])
                  Positioned(
                    top: Dimensions.height20,
                    right: Dimensions.width20,
                    child: IconBtn(
                      onTap: () => Get.off(() => const WordPage(),
                          arguments: [Get.arguments[0], Get.arguments[3]]),
                      icon: Icons.refresh,
                    ),
                  ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: Dimensions.height45),
                      child: Container(
                        height: Dimensions.height45 * 2,
                        width: Dimensions.height45 * 2,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius30 * 3),
                        ),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              '${Get.arguments[1]}',
                              style: TextStyle(
                                  fontSize: Dimensions.font20 * 2.5,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: Dimensions.screenWidth / 2,
                        padding: EdgeInsets.only(
                            top: Dimensions.height30,
                            bottom: Dimensions.height30),
                        child: ShaderMask(
                          shaderCallback: (Rect rect) {
                            return const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black,
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black
                              ],
                              stops: [0.0, 0.1, 0.9, 1.0],
                            ).createShader(rect);
                          },
                          blendMode: BlendMode.dstOut,
                          child: NotificationListener<
                              OverscrollIndicatorNotification>(
                            onNotification:
                                (OverscrollIndicatorNotification overscroll) {
                              overscroll.disallowIndicator();
                              return true;
                            },
                            child: SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              controller: _controller,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: Dimensions.height30,
                                    top: Dimensions.height45),
                                child: Column(
                                  children: List.generate(
                                    Get.arguments[2].length,
                                    (index) => Padding(
                                      padding:
                                          EdgeInsets.all(Dimensions.height20),
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          Get.arguments[2][index]
                                              .replaceFirstMapped(
                                                  '#', (match) => ''),
                                          style: TextStyle(
                                              fontSize: Dimensions.font26,
                                              color: Get.arguments[2][index]
                                                      .contains('#')
                                                  ? Colors.white
                                                      .withOpacity(0.4)
                                                  : Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
