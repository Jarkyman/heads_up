import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heads_up/background_image.dart';
import 'package:heads_up/helper/app_colors.dart';
import 'package:heads_up/helper/dimensions.dart';
import 'package:heads_up/pages/game%20pages/chameleon_reveal_page.dart';
import 'package:heads_up/models/category_model.dart';
import 'package:heads_up/widgets/how_to_play_dialog.dart';
import 'package:heads_up/widgets/icon_button.dart';

class ChameleonGamePage extends StatefulWidget {
  const ChameleonGamePage({super.key});

  @override
  State<ChameleonGamePage> createState() => _ChameleonGamePageState();
}

class _ChameleonGamePageState extends State<ChameleonGamePage> {
  late String secretWord;
  late List<String> roles;
  late CategoryModel category;
  late int playersCount;
  late int impostersCount;
  late bool canReplay;

  @override
  void initState() {
    super.initState();
    secretWord = Get.arguments[0];
    roles = Get.arguments[1];
    category = Get.arguments[2];
    playersCount = Get.arguments[3];
    impostersCount = Get.arguments[4];
    canReplay = Get.arguments[5];
  }

  void _showRulesDialog() {
    buildHowToDialog(isChameleon: true);
  }

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
                    Text(
                      'Find the Chameleon!'.tr,
                      style: TextStyle(
                        fontSize: Dimensions.font26 * 1.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        shadows: const [
                          Shadow(blurRadius: 10, color: Colors.black54),
                        ],
                      ),
                    ),
                    SizedBox(height: Dimensions.height20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20 * 2),
                      child: Text(
                        'Say a word related to the secret word.'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: Dimensions.font20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height45 * 2),

                    // Rules button
                    _buildGameButton(
                      text: 'Rules'.tr,
                      icon: Icons.menu_book,
                      color: AppColors.glassWhite,
                      onTap: _showRulesDialog,
                    ),

                    SizedBox(height: Dimensions.height30),

                    // End game and Reveal button
                    _buildGameButton(
                      text: 'Reveal'.tr,
                      icon: Icons.visibility,
                      color: Colors.redAccent.withValues(alpha: 0.8),
                      onTap: () {
                        Get.to(() => const ChameleonRevealPage(), arguments: [
                          secretWord,
                          roles,
                          category,
                          playersCount,
                          impostersCount,
                          canReplay,
                        ]);
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: IconBtn(
                  onTap: () {
                    // Show confirmation dialog before leaving
                    Get.defaultDialog(
                      title: 'Quit Game?'.tr,
                      middleText: 'Are you sure you want to quit?'.tr,
                      backgroundColor: Colors.white,
                      textConfirm: 'Yes'.tr,
                      textCancel: 'No'.tr,
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        Get.until((route) => route.isFirst);
                      },
                    );
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

  Widget _buildGameButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: Dimensions.width45 * 5.5,
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.height20,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 8, spreadRadius: 1),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: Dimensions.iconSize24 * 1.2),
                SizedBox(width: Dimensions.width10),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: Dimensions.font20 * 1.2,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
