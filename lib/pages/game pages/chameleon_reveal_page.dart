import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heads_up/background_image.dart';
import 'package:heads_up/helper/app_colors.dart';
import 'package:heads_up/helper/dimensions.dart';
import 'package:heads_up/widgets/icon_button.dart';
import 'package:heads_up/models/category_model.dart';
import 'package:heads_up/pages/game%20pages/chameleon_role_page.dart';

class ChameleonRevealPage extends StatefulWidget {
  const ChameleonRevealPage({super.key});

  @override
  State<ChameleonRevealPage> createState() => _ChameleonRevealPageState();
}

class _ChameleonRevealPageState extends State<ChameleonRevealPage> {
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

  List<int> _getChameleonIndices() {
    List<int> indices = [];
    for (int i = 0; i < roles.length; i++) {
      if (roles[i] == "Chameleon") {
        indices.add(i + 1); // Player numbers are 1-indexed
      }
    }
    return indices;
  }

  @override
  Widget build(BuildContext context) {
    List<int> chameleons = _getChameleonIndices();
    String chameleonsText = chameleons.map((e) => "${'Player'.tr} $e").join(", ");

    return Scaffold(
      body: BackgroundImage(
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Secret Word Card
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                          child: Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.all(Dimensions.height30),
                            decoration: BoxDecoration(
                              color: AppColors.correctColor.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(Dimensions.radius20),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
                              boxShadow: const [
                                BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'The secret word was:'.tr,
                                  style: TextStyle(
                                    fontSize: Dimensions.font20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white70,
                                  ),
                                ),
                                SizedBox(height: Dimensions.height10),
                                Text(
                                  secretWord,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: Dimensions.font26 * 1.5,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    shadows: const [
                                      Shadow(blurRadius: 8, color: Colors.black54),
                                    ],
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
                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                          child: Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.all(Dimensions.height30),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(Dimensions.radius20),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
                              boxShadow: const [
                                BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  chameleons.length > 1 ? 'The Chameleons were:'.tr : 'The Chameleon was:'.tr,
                                  style: TextStyle(
                                    fontSize: Dimensions.font20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white70,
                                  ),
                                ),
                                SizedBox(height: Dimensions.height10),
                                Text(
                                  chameleonsText,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: Dimensions.font26 * 1.2,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    shadows: const [
                                      Shadow(blurRadius: 8, color: Colors.black54),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: Dimensions.height45 * 1.5),

                      if (canReplay)
                        GestureDetector(
                          onTap: () {
                            Get.until((route) => route.isFirst);
                            Get.to(() => const ChameleonRolePage(), arguments: [
                              category,
                              playersCount,
                              impostersCount,
                              canReplay,
                            ]);
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
                                  color: AppColors.correctColor.withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: Colors.white, width: 2),
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
                        ),
                      if (canReplay) SizedBox(height: Dimensions.height20),
                      // Home button
                      GestureDetector(
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
                                border: Border.all(color: Colors.white, width: 2),
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
                      ),
                    ],
                  ),
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
}
