import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heads_up/background_image.dart';
import 'package:heads_up/controllers/review_controller.dart';
import 'package:heads_up/controllers/settings_controller.dart';
import 'package:heads_up/helper/ad_policy.dart';
import 'package:heads_up/helper/app_colors.dart';
import 'package:heads_up/helper/app_constants.dart';
import 'package:heads_up/helper/dimensions.dart';
import 'package:heads_up/helper/interstitial_ad_manager.dart';
import 'package:heads_up/models/category_model.dart';
import 'package:heads_up/widgets/icon_button.dart';
import 'package:heads_up/widgets/result_banner_ad.dart';

class ChameleonRevealPage extends StatefulWidget {
  const ChameleonRevealPage({super.key});

  @override
  State<ChameleonRevealPage> createState() => _ChameleonRevealPageState();
}

class _ChameleonRevealPageState extends State<ChameleonRevealPage> {
  static const double _glassBorderWidth = 1.4;

  late final InterstitialAdManager _interstitialAdManager;
  late String secretWord;
  late List<String> roles;
  late CategoryModel category;
  late List<String> playerNames;
  late int impostersCount;
  late bool canReplay;

  @override
  void initState() {
    super.initState();
    final settingsController = Get.find<SettingsController>();
    final shouldShowInterstitial = AdPolicy.shouldShowInterstitial(
      launchCount: settingsController.appLaunchCount,
      resultRoll: Random().nextInt(AppConstants.INTERSTITIAL_RESULT_FREQUENCY),
    );
    _interstitialAdManager = InterstitialAdManager(
      enabled: !settingsController.isUnlockAll && shouldShowInterstitial,
    )..load();

    secretWord = Get.arguments[0];
    roles = List<String>.from(Get.arguments[1]);
    category = Get.arguments[2];
    playerNames = List<String>.from(Get.arguments[3]);
    impostersCount = Get.arguments[4];
    canReplay = Get.arguments[5];
    _showReviewOrInterstitial();
  }

  @override
  void dispose() {
    _interstitialAdManager.dispose();
    super.dispose();
  }

  Future<void> _showReviewOrInterstitial() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final reviewWasShown = ReviewController.checkReviewPopup(context);
    if (!reviewWasShown) {
      _interstitialAdManager.showIfReady();
    }
  }

  List<String> _getChameleonNames() {
    List<String> names = [];
    for (int i = 0; i < roles.length; i++) {
      if (roles[i] == "Chameleon") {
        names.add(playerNames[i]);
      }
    }
    return names;
  }

  @override
  Widget build(BuildContext context) {
    List<String> chameleons = _getChameleonNames();
    String chameleonsText = chameleons.join(", ");

    return Scaffold(
      body: BackgroundImage(
        child: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    Dimensions.width20,
                    Dimensions.height45 * 1.4,
                    Dimensions.width20,
                    Dimensions.height20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Secret Word Card
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                          child: Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.all(Dimensions.height30),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.glassWhiteStrong,
                                  AppColors.correctColor
                                      .withValues(alpha: 0.28),
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius20),
                              border: Border.all(
                                  color: AppColors.correctColor
                                      .withValues(alpha: 0.58),
                                  width: _glassBorderWidth),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    spreadRadius: 2),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: double.maxFinite,
                                  child: Text(
                                    'The secret word was:'.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: Dimensions.font20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                SizedBox(height: Dimensions.height10),
                                SizedBox(
                                  width: double.maxFinite,
                                  child: Text(
                                    secretWord,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: Dimensions.font26 * 1.5,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      shadows: const [
                                        Shadow(
                                            blurRadius: 8,
                                            color: Colors.black54),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.height30),

                      // Chameleons Card
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                          child: Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.all(Dimensions.height30),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.glassWhiteStrong,
                                  Colors.redAccent.withValues(alpha: 0.28),
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius20),
                              border: Border.all(
                                  color:
                                      Colors.redAccent.withValues(alpha: 0.58),
                                  width: _glassBorderWidth),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    spreadRadius: 2),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: double.maxFinite,
                                  child: Text(
                                    chameleons.length > 1
                                        ? 'The Chameleons were:'.tr
                                        : 'The Chameleon was:'.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: Dimensions.font20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                SizedBox(height: Dimensions.height10),
                                SizedBox(
                                  width: double.maxFinite,
                                  child: Text(
                                    chameleonsText,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: Dimensions.font26 * 1.2,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      shadows: const [
                                        Shadow(
                                            blurRadius: 8,
                                            color: Colors.black54),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: Dimensions.width20,
                right: Dimensions.width20,
                bottom: Dimensions.height20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (canReplay) _buildPlayAgainButton(),
                    if (canReplay) SizedBox(height: Dimensions.height20),
                    _buildMainMenuButton(),
                    SizedBox(height: Dimensions.height10),
                    const ResultBannerAd(),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: IconBtn(
                  onTap: () {
                    Get.until((route) => route.isFirst);
                  },
                  icon: Icons.close,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayAgainButton() {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width45,
              vertical: Dimensions.height20,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.glassWhiteStrong,
                  AppColors.correctColor.withValues(alpha: 0.28),
                ],
              ),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: AppColors.correctColor.withValues(alpha: 0.58),
                width: _glassBorderWidth,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Text(
              'Play again'.tr,
              style: TextStyle(
                fontSize: Dimensions.font26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainMenuButton() {
    return GestureDetector(
      onTap: () {
        Get.until((route) => route.isFirst);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width45,
              vertical: Dimensions.height20,
            ),
            decoration: BoxDecoration(
              color: AppColors.glassWhite,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: AppColors.glassBorder,
                width: _glassBorderWidth,
              ),
            ),
            child: Text(
              'Main menu'.tr,
              style: TextStyle(
                fontSize: Dimensions.font26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
