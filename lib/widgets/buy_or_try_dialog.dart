import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heads_up/pages/game%20pages/word_page.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../controllers/settings_controller.dart';
import '../../helper/app_colors.dart';
import '../../helper/dimensions.dart';
import '../helper/app_constants.dart';
import '../models/category_model.dart';

void buildBuyOrTryDialog(
    RewardedAd? rewardedAd, bool isAdLoaded, CategoryModel categoryData) {
  Get.bottomSheet(
    Container(
      height: Dimensions.screenHeight / 1.5,
      width: Dimensions.width45 * 6,
      decoration: BoxDecoration(
        color: AppColors.lightPurpleColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(Dimensions.radius30),
          topLeft: Radius.circular(Dimensions.radius30),
        ),
      ),
      child: BuyOrTryWidget(
          rewardedAd: rewardedAd,
          isAdLoaded: isAdLoaded,
          categoryData: categoryData),
    ),
  );
}

class BuyOrTryWidget extends StatefulWidget {
  const BuyOrTryWidget({
    Key? key,
    this.rewardedAd,
    required this.isAdLoaded,
    required this.categoryData,
  }) : super(key: key);

  final RewardedAd? rewardedAd;
  final bool isAdLoaded;
  final CategoryModel categoryData;

  @override
  State<BuyOrTryWidget> createState() => _BuyOrTryWidgetState();
}

class _BuyOrTryWidgetState extends State<BuyOrTryWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Dimensions.height45,
        ),
        Container(
          height: Dimensions.width45 * 3,
          width: Dimensions.width45 * 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.width45 * 2),
            color: AppColors.greenColor,
          ),
          child: const Center(
            child: Icon(
              Icons.add_circle_outline,
              color: Colors.white,
              size: 80,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: Dimensions.width10,
              right: Dimensions.width10,
              top: Dimensions.width20),
          child: Text(
            'You do not have access to this category, buy the full version or watch a video and and get a free try.'
                .tr,
            style: TextStyle(
                fontSize: Dimensions.font16,
                color: AppColors.textColorGray,
                fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(child: Container()),
        GetBuilder<SettingsController>(builder: (settingsController) {
          StoreProduct? product = settingsController.products[0];

          return CustomIconButton(
            onTap: () async {
              if (!settingsController.isUnlockAll) {
                try {
                  CustomerInfo customerInfo = await Purchases.purchaseProduct(
                      AppConstants.UNLOCK_ALL_ID,
                      type: PurchaseType.inapp);
                  debugPrint('Purchase info: $customerInfo');
                  settingsController.unlockAllSave(true);
                  debugPrint('Levels unlocked');
                  Get.back();
                } on PlatformException catch (e) {
                  var errorCode = PurchasesErrorHelper.getErrorCode(e);
                  if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
                    debugPrint('Failed to purchase product. ');
                    //purchaseErrorSnackbar(); TODO: Error popup
                  }
                }
              }
            },
            title: 'BUY FULL VERSION'.tr,
            price: product.priceString,
            color: AppColors.greenColor,
            textColor: Colors.white,
            icon: Icons.monetization_on_outlined,
          );
        }),
        SizedBox(
          height: Dimensions.height20,
        ),
        GetBuilder<SettingsController>(builder: (settingsController) {
          print('Trys = ' + settingsController.getTries.toString());
          return CustomIconButton(
            onTap: () {
              print(settingsController.getTries);
              if (widget.isAdLoaded &&
                  settingsController.getTries < AppConstants.TRYS_PR_DAY) {
                /*widget.rewardedAd?.show(
                  onUserEarnedReward: (_, reward) {
                    settingsController
                        .triesPerDaySave(settingsController.getTries + 1);
                    Get.close(1);
                    Get.to(() => const WordPage(),
                        arguments: [widget.categoryData, false]);
                  },
                );*/ //TODO: Tilføj reklame igen
                settingsController
                    .triesPerDaySave(settingsController.getTries + 1);
                Get.close(1);
                Get.to(() => const WordPage(),
                    arguments: [widget.categoryData, false]);
              }
            },
            title: settingsController.getTries < AppConstants.TRYS_PR_DAY
                ? widget.isAdLoaded
                    ? 'GET A FREE TRY'.tr +
                        ' ${settingsController.getTries}/${AppConstants.TRYS_PR_DAY}'
                    : 'AD NOT AVAILABLE'.tr
                : 'TRY AGAIN IN'.tr,
            isTimer: settingsController.getTries >= AppConstants.TRYS_PR_DAY,
            color: AppColors.lightGrayColor,
            textColor: widget.isAdLoaded ? Colors.black : Colors.grey,
            icon: Icons.ondemand_video_rounded,
          );
        }),
        SizedBox(
          height: Dimensions.height45,
        ),
      ],
    );
  }
}

class CustomIconButton extends StatefulWidget {
  const CustomIconButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.color,
    this.price = '',
    this.textColor = Colors.black,
    this.isTimer = false,
  }) : super(key: key);

  final VoidCallback onTap;
  final String title;
  final String price;
  final IconData icon;
  final Color color;
  final Color textColor;
  final bool isTimer;

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  Timer? _countdownTimer;
  Duration myDuration = Duration();

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _countdownTimer!.cancel();
    super.dispose();
  }

  void startTimer() async {
    myDuration = await Get.find<SettingsController>().getTimeToNewTry();
    _countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        print('Reset from sec');
        _countdownTimer!.cancel();
        Get.find<SettingsController>().resetTries();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');

    final hours = strDigits(myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: Dimensions.height30 * 2,
        width: Dimensions.width45 * 6.5,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
        ),
        child: Padding(
          padding: EdgeInsets.only(
              left: Dimensions.width10, right: Dimensions.width10),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  widget.icon,
                  color: widget.textColor,
                  size: Dimensions.iconSize24,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: Dimensions.font16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (widget.price != '')
                          Text(
                            ' ${widget.price}',
                            style: TextStyle(
                              color: widget.textColor,
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (widget.isTimer)
                    '$hours:$minutes:$seconds' != '00:00:00'
                        ? Text(
                            ' $hours:$minutes:$seconds',
                            style: TextStyle(
                              color: widget.textColor,
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : Stack(
                            children: [
                              Text(
                                ' 22:22:22 ',
                                style: TextStyle(
                                  color: Colors.transparent,
                                  fontSize: Dimensions.font16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: Dimensions.width20,
                                  ),
                                  CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 4.0,
                                  ),
                                ],
                              ),
                            ],
                          ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
