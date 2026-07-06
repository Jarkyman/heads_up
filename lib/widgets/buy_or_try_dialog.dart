import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heads_up/models/game_mode.dart';
import 'package:heads_up/pages/game%20pages/chameleon_setup_page.dart';
import 'package:heads_up/pages/game%20pages/word_page.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../controllers/settings_controller.dart';
import '../../helper/app_colors.dart';
import '../../helper/dimensions.dart';
import '../helper/app_constants.dart';
import '../models/category_model.dart';
import 'premium_dialog_components.dart';

void buildBuyOrTryDialog(
  RewardedAd? rewardedAd,
  bool isAdLoaded,
  CategoryModel categoryData, {
  required VoidCallback onRewardedAdClosed,
}) {
  Get.bottomSheet(
    PremiumBottomSheet(
      child: BuyOrTryWidget(
        rewardedAd: rewardedAd,
        isAdLoaded: isAdLoaded,
        categoryData: categoryData,
        onRewardedAdClosed: onRewardedAdClosed,
      ),
    ),
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    isScrollControlled: true,
  );
}

class BuyOrTryWidget extends StatefulWidget {
  const BuyOrTryWidget({
    super.key,
    this.rewardedAd,
    required this.isAdLoaded,
    required this.categoryData,
    required this.onRewardedAdClosed,
  });

  final RewardedAd? rewardedAd;
  final bool isAdLoaded;
  final CategoryModel categoryData;
  final VoidCallback onRewardedAdClosed;

  @override
  State<BuyOrTryWidget> createState() => _BuyOrTryWidgetState();
}

class _BuyOrTryWidgetState extends State<BuyOrTryWidget> {
  bool _earnedReward = false;

  void _openCategory() {
    Get.close(1);
    if (Get.find<SettingsController>().gameMode == GameMode.whoAmI) {
      Get.to(
        () => const WordPage(),
        arguments: [widget.categoryData, false],
      );
    } else {
      Get.to(
        () => const ChameleonSetupPage(),
        arguments: [widget.categoryData, false],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PremiumSheetHandle(),
        SizedBox(height: Dimensions.height25),
        const PremiumHeroIcon(
          icon: Icons.lock_open_rounded,
        ),
        SizedBox(height: Dimensions.height20),
        PremiumTextPanel(
          children: [
            PremiumBodyText(
              'You do not have access to this category, buy the full version or watch a video and and get a free try.'
                  .tr,
              fontWeight: FontWeight.w800,
            ),
          ],
        ),
        const Spacer(),
        GetBuilder<SettingsController>(builder: (settingsController) {
          StoreProduct? product;
          if (settingsController.products.isNotEmpty) {
            product = settingsController.products[0];
          }

          return PremiumActionButton(
            onTap: () async {
              if (!settingsController.isUnlockAll) {
                try {
                  if (product != null) {
                    PurchaseResult result = await Purchases.purchase(
                      PurchaseParams.storeProduct(product),
                    );
                    CustomerInfo customerInfo = result.customerInfo;
                    debugPrint('Purchase info: $customerInfo');
                    settingsController.unlockAllSave(true);
                    debugPrint('Levels unlocked');
                    Get.back();
                  }
                } on PlatformException catch (e) {
                  var errorCode = PurchasesErrorHelper.getErrorCode(e);
                  if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
                    debugPrint('Failed to purchase product. ');
                    //purchaseErrorSnackbar();
                  }
                }
              }
            },
            title:
                product == null ? 'TRY AGAIN LATER'.tr : 'BUY FULL VERSION'.tr,
            price: product == null ? '' : product.priceString,
            accentColor: AppColors.greenColor,
            textColor: Colors.white,
            icon: Icons.monetization_on_outlined,
            enabled: product != null,
          );
        }),
        SizedBox(height: Dimensions.height15),
        GetBuilder<SettingsController>(builder: (settingsController) {
          final hasTriesLeft =
              settingsController.getTries < AppConstants.TRYS_PR_DAY;
          final canWatchAd = widget.isAdLoaded && hasTriesLeft;

          return PremiumActionButton(
            onTap: () {
              debugPrint(settingsController.getTries.toString());
              final rewardedAd = widget.rewardedAd;
              if (canWatchAd && rewardedAd != null) {
                _earnedReward = false;
                rewardedAd.fullScreenContentCallback =
                    FullScreenContentCallback(
                  onAdDismissedFullScreenContent: (ad) {
                    ad.dispose();
                    widget.onRewardedAdClosed();
                    if (_earnedReward) {
                      _openCategory();
                    }
                  },
                  onAdFailedToShowFullScreenContent: (ad, error) {
                    debugPrint(
                      'Failed to show rewarded ad: ${error.message}',
                    );
                    ad.dispose();
                    widget.onRewardedAdClosed();
                  },
                );
                rewardedAd.show(
                  onUserEarnedReward: (_, reward) {
                    _earnedReward = true;
                    settingsController.triesPerDaySave(
                      settingsController.getTries + 1,
                    );
                  },
                );
              }
            },
            title: hasTriesLeft
                ? widget.isAdLoaded
                    ? '${'GET A FREE TRY'.tr} ${settingsController.getTries}/${AppConstants.TRYS_PR_DAY}'
                    : 'AD NOT AVAILABLE'.tr
                : 'TRY AGAIN IN'.tr,
            isTimer: !hasTriesLeft,
            accentColor: Colors.white,
            textColor: Colors.white,
            icon: Icons.ondemand_video_rounded,
            enabled: canWatchAd,
          );
        }),
      ],
    );
  }
}
