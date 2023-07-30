import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';
import 'package:heads_up/background_image.dart';
import 'package:heads_up/controllers/settings_controller.dart';
import 'package:heads_up/helper/app_colors.dart';
import 'package:heads_up/helper/dimensions.dart';
import 'package:heads_up/widgets/how_to_play_dialog.dart';
import 'package:launch_review/launch_review.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../helper/app_constants.dart';
import '../widgets/change_language_dialog.dart';
import '../widgets/icon_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

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
                                      color: Colors.white.withOpacity(0.8),
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
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ),
                            GetBuilder<SettingsController>(
                              builder: (settingsController) {
                                print(settingsController.getRoundTime);
                                int time = settingsController.getRoundTime;
                                int index = 0;
                                switch (time) {
                                  case 60:
                                    index = 0;
                                    break;
                                  case 90:
                                    index = 1;
                                    break;
                                  case 120:
                                    index = 2;
                                    break;
                                  default:
                                    index = 0;
                                }
                                return GroupButton(
                                  controller: GroupButtonController(
                                      selectedIndex: index),
                                  buttons: const ['60', '90', '120'],
                                  onSelected: (value, index, selected) {
                                    settingsController
                                        .roundTimeSave(int.parse(value));
                                  },
                                  options: GroupButtonOptions(
                                    selectedTextStyle: TextStyle(
                                      fontSize: Dimensions.font16,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                    selectedColor: AppColors.correctColor,
                                    unselectedColor: AppColors.textColorGray,
                                    unselectedTextStyle: TextStyle(
                                      fontSize: Dimensions.font16,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                    selectedBorderColor: Colors.black,
                                    unselectedBorderColor: Colors.black,
                                    borderRadius: BorderRadius.circular(100),
                                    spacing: Dimensions.width10 / 3,
                                    runSpacing: Dimensions.width10 / 3,
                                    groupingType: GroupingType.row,
                                    direction: Axis.horizontal,
                                    buttonHeight: Dimensions.height45,
                                    buttonWidth: Dimensions.width45,
                                  ),
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
                        buildHowToDialog();
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
                                      color: Colors.white.withOpacity(0.8),
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
                        LaunchReview.launch(
                            androidAppId: AppConstants.ANDROID_ID,
                            iOSAppId: AppConstants.IOS_ID);
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
                                      color: Colors.white.withOpacity(0.8),
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
                        } on PlatformException catch (e) {
                          print(e);
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
                                      color: Colors.white.withOpacity(0.8),
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
    Key? key,
    required this.icon,
  }) : super(key: key);

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

class SettingsBtn extends StatelessWidget {
  final Widget child;
  const SettingsBtn({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.height10 * 10,
      width: Dimensions.width30 * 10,
      decoration: BoxDecoration(
        color: AppColors.darkPurpleColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: child,
    );
  }
}
