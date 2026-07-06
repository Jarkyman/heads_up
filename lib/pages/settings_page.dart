import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:heads_up/background_image.dart';
import 'package:heads_up/controllers/settings_controller.dart';
import 'package:heads_up/helper/app_colors.dart';
import 'package:heads_up/helper/dimensions.dart';
import 'package:heads_up/widgets/how_to_play_dialog.dart';
import 'package:heads_up/controllers/review_controller.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../helper/app_constants.dart';
import '../widgets/change_language_dialog.dart';
import '../widgets/icon_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundImage(
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        buildLanguageDialog();
                      },
                      child: SettingsBtn(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: Dimensions.width30 * 7.5,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Language'.tr,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: Dimensions.font26,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Colors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: Dimensions.height45,
                                width: Dimensions.height45,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 2, color: Colors.black),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.height45),
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/locale/flags/${Get.locale.toString().split('_')[1].toLowerCase()}.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    SettingsBtn(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: Dimensions.width45 * 2.6,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Duration'.tr,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: Dimensions.font26,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                              ),
                            ),
                            GetBuilder<SettingsController>(
                              builder: (settingsController) {
                                return RoundTimeSelector(
                                  selectedTime: settingsController.getRoundTime,
                                  onSelected: settingsController.roundTimeSave,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    GestureDetector(
                      onTap: () {
                        buildHowToSelectionDialog();
                      },
                      child: SettingsBtn(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: Dimensions.width30 * 7.5,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'How to play'.tr,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: Dimensions.font26,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Colors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ),
                              ),
                              const IconIndicator(icon: Icons.question_mark),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    GestureDetector(
                      onTap: () {
                        ReviewController.rateMyApp.launchStore();
                      },
                      child: SettingsBtn(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: Dimensions.width30 * 7.5,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Review app'.tr,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: Dimensions.font26,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Colors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ),
                              ),
                              const IconIndicator(icon: Icons.star),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        try {
                          CustomerInfo restoredInfo =
                              await Purchases.restorePurchases();
                          final entitlementAds = restoredInfo.entitlements
                              .all[AppConstants.UNLOCK_ALL_ID_ENT]?.isActive;
                          bool isUnlockAll = entitlementAds == true;

                          Get.find<SettingsController>()
                              .unlockAllSave(isUnlockAll);

                          Get.snackbar(
                            'Restore purchase'.tr,
                            isUnlockAll ? '✔' : '✖',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor:
                                Colors.black.withValues(alpha: 0.6),
                            colorText: Colors.white,
                          );
                        } on PlatformException catch (e) {
                          debugPrint(e.toString());
                        }
                      },
                      child: SettingsBtn(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: Dimensions.width30 * 7.5,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Restore purchase'.tr,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: Dimensions.font26,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Colors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ),
                              ),
                              const IconIndicator(
                                icon: Icons.sync,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: IconBtn(
                  onTap: () => Get.back(),
                  icon: Icons.close,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IconIndicator extends StatelessWidget {
  final IconData icon;
  const IconIndicator({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: Dimensions.height45,
      color: Colors.white,
      shadows: const [
        Shadow(blurRadius: 6, color: Colors.black),
        Shadow(blurRadius: 6, color: Colors.black),
        Shadow(blurRadius: 6, color: Colors.black),
        Shadow(blurRadius: 6, color: Colors.black),
        Shadow(blurRadius: 6, color: Colors.black),
      ],
    );
  }
}

class RoundTimeSelector extends StatelessWidget {
  const RoundTimeSelector({
    super.key,
    required this.selectedTime,
    required this.onSelected,
  });

  final int selectedTime;
  final ValueChanged<int> onSelected;

  static const List<int> _times = [60, 90, 120];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_times.length, (index) {
        final time = _times[index];
        final isSelected = time == selectedTime;

        return Padding(
          padding: EdgeInsets.only(
            left: index == 0 ? 0 : Dimensions.width10 / 2,
          ),
          child: _RoundTimeButton(
            time: time,
            isSelected: isSelected,
            onTap: () => onSelected(time),
          ),
        );
      }),
    );
  }
}

class _RoundTimeButton extends StatelessWidget {
  const _RoundTimeButton({
    required this.time,
    required this.isSelected,
    required this.onTap,
  });

  final int time;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            height: Dimensions.height45,
            width: Dimensions.width45,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.greenColor.withValues(alpha: 0.32)
                  : AppColors.glassWhite,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: isSelected
                    ? AppColors.greenColor.withValues(alpha: 0.68)
                    : AppColors.glassBorder,
                width: 1.2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.greenColor.withValues(alpha: 0.18),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                '$time',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white.withValues(
                    alpha: isSelected ? 0.95 : 0.72,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsBtn extends StatelessWidget {
  final Widget child;
  const SettingsBtn({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimensions.radius20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          height: Dimensions.height10 * 10,
          width: Dimensions.width30 * 10,
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(Dimensions.radius20),
            border: Border.all(
              color: AppColors.glassBorder,
              width: 1.2,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
