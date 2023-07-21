import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../controllers/settings_controller.dart';
import '../../helper/app_colors.dart';
import '../../helper/dimensions.dart';
import '../helper/app_constants.dart';

void buildBuyDialog() {
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
      child: Column(
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
                Icons.monetization_on_outlined,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Buy the full version, and unlock all the features.'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: Dimensions.font16,
                      color: AppColors.textColorGray,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
                Text(
                  'Unlock all categories.'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: Dimensions.font16,
                      color: AppColors.textColorGray,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  'Remove advertisements.'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: Dimensions.font16,
                      color: AppColors.textColorGray,
                      fontWeight: FontWeight.w600),
                ),
                /*Text(
                  'Ability to create custom categories and words.'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: Dimensions.font16,
                      color: AppColors.textColorGray,
                      fontWeight: FontWeight.w600),
                ),*/ //TODO: Skal på når man kan oprette selv
                Text(
                  'Experience the full functionality of the game.'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: Dimensions.font16,
                      color: AppColors.textColorGray,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Expanded(child: Container()),
          GetBuilder<SettingsController>(builder: (settingsController) {
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
                    if (errorCode !=
                        PurchasesErrorCode.purchaseCancelledError) {
                      debugPrint('Failed to purchase product. ');
                      //purchaseErrorSnackbar(); TODO: Error popup
                    }
                  }
                }
              },
              title: 'BUY FULL VERSION'.tr,
              color: AppColors.greenColor,
              textColor: Colors.white,
              icon: Icons.monetization_on_outlined,
            );
          }),
          SizedBox(
            height: Dimensions.height45,
          ),
        ],
      ),
    ),
  );
}

class CustomIconButton extends StatefulWidget {
  const CustomIconButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.color,
    this.textColor = Colors.black,
    this.isTimer = false,
  }) : super(key: key);

  final VoidCallback onTap;
  final String title;
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
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        _countdownTimer!.cancel();
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
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.w600,
                      ),
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
