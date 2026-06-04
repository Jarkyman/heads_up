import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heads_up/background_image.dart';
import 'package:heads_up/helper/app_colors.dart';
import 'package:heads_up/helper/dimensions.dart';
import 'package:heads_up/models/category_model.dart';
import 'package:heads_up/pages/game%20pages/chameleon_role_page.dart';
import 'package:heads_up/widgets/icon_button.dart';

class ChameleonSetupPage extends StatefulWidget {
  const ChameleonSetupPage({super.key});

  @override
  State<ChameleonSetupPage> createState() => _ChameleonSetupPageState();
}

class _ChameleonSetupPageState extends State<ChameleonSetupPage> {
  late CategoryModel category;
  late bool canReplay;
  int _playersCount = 4;
  int _impostersCount = 1;

  @override
  void initState() {
    super.initState();
    category = Get.arguments[0];
    canReplay = Get.arguments[1];
  }

  void _updatePlayers(int change) {
    setState(() {
      _playersCount += change;
      if (_playersCount < 3) _playersCount = 3;
      if (_playersCount > 15) _playersCount = 15;

      int maxImposters = _playersCount ~/ 3;
      if (maxImposters < 1) maxImposters = 1;
      if (_impostersCount > maxImposters) {
        _impostersCount = maxImposters;
      }
    });
  }

  void _updateImposters(int change) {
    setState(() {
      int maxImposters = _playersCount ~/ 3;
      if (maxImposters < 1) maxImposters = 1;
      
      _impostersCount += change;
      if (_impostersCount < 1) _impostersCount = 1;
      if (_impostersCount > maxImposters) _impostersCount = maxImposters;
    });
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
                      'Chameleon setup'.tr,
                      style: TextStyle(
                        fontSize: Dimensions.font26 * 1.2,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        shadows: const [
                          Shadow(blurRadius: 10, color: Colors.black54),
                        ],
                      ),
                    ),
                    SizedBox(height: Dimensions.height30),
                    
                    // Players Counter
                    _buildCounterTile(
                      title: 'Players'.tr,
                      count: _playersCount,
                      onMinus: () => _updatePlayers(-1),
                      onPlus: () => _updatePlayers(1),
                      canMinus: _playersCount > 3,
                      canPlus: _playersCount < 15,
                    ),
                    SizedBox(height: Dimensions.height20),
                    
                    // Imposters Counter
                    _buildCounterTile(
                      title: 'Imposters'.tr,
                      count: _impostersCount,
                      onMinus: () => _updateImposters(-1),
                      onPlus: () => _updateImposters(1),
                      canMinus: _impostersCount > 1,
                      canPlus: _impostersCount < (_playersCount ~/ 3 < 1 ? 1 : _playersCount ~/ 3),
                    ),
                    
                    SizedBox(height: Dimensions.height45),
                    
                    // Start Game Button
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const ChameleonRolePage(), arguments: [
                          category,
                          _playersCount,
                          _impostersCount,
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
                              'Start game'.tr,
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

  Widget _buildCounterTile({
    required String title,
    required int count,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
    required bool canMinus,
    required bool canPlus,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimensions.radius20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: Dimensions.width30 * 10,
          padding: EdgeInsets.all(Dimensions.height20),
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(Dimensions.radius20),
            border: Border.all(color: AppColors.glassBorder, width: 1.2),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: Dimensions.font20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: canMinus ? onMinus : null,
                    child: Container(
                      padding: EdgeInsets.all(Dimensions.height10),
                      decoration: BoxDecoration(
                        color: canMinus ? Colors.black.withValues(alpha: 0.3) : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.remove, color: canMinus ? Colors.white : Colors.white24, size: Dimensions.iconSize32),
                    ),
                  ),
                  Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: Dimensions.font26 * 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: canPlus ? onPlus : null,
                    child: Container(
                      padding: EdgeInsets.all(Dimensions.height10),
                      decoration: BoxDecoration(
                        color: canPlus ? Colors.black.withValues(alpha: 0.3) : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add, color: canPlus ? Colors.white : Colors.white24, size: Dimensions.iconSize32),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
