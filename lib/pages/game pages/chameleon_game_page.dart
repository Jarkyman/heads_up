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

class _ChameleonGamePageState extends State<ChameleonGamePage>
    with SingleTickerProviderStateMixin {
  late String secretWord;
  late List<String> roles;
  late CategoryModel category;
  late List<String> playerNames;
  late int impostersCount;
  late bool canReplay;
  late AnimationController _revealHoldController;
  bool _hasOpenedReveal = false;

  double get _gameButtonWidth => Dimensions.width45 * 5.5;
  double get _gameButtonHeight => Dimensions.height20 * 3.4;
  double get _gameButtonBorderWidth => 1.4;

  @override
  void initState() {
    super.initState();
    secretWord = Get.arguments[0];
    roles = List<String>.from(Get.arguments[1]);
    category = Get.arguments[2];
    playerNames = List<String>.from(Get.arguments[3]);
    impostersCount = Get.arguments[4];
    canReplay = Get.arguments[5];

    _revealHoldController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _openRevealPage();
        }
      });
  }

  void _showRulesDialog() {
    buildHowToDialog(isChameleon: true);
  }

  void _openRevealPage() {
    if (_hasOpenedReveal) return;
    _hasOpenedReveal = true;

    Get.off(() => const ChameleonRevealPage(), arguments: [
      secretWord,
      roles,
      category,
      playerNames,
      impostersCount,
      canReplay,
    ]);
  }

  void _startRevealHold() {
    if (_hasOpenedReveal) return;
    _revealHoldController.forward(from: 0);
  }

  void _cancelRevealHold() {
    if (_revealHoldController.isCompleted) return;
    _revealHoldController.reset();
  }

  void _showEndGameDialog() {
    Get.dialog<void>(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radius30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: EdgeInsets.all(Dimensions.height20),
              decoration: BoxDecoration(
                color: AppColors.glassWhiteStrong,
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                border: Border.all(
                  color: AppColors.glassBorder,
                  width: 1.4,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: Dimensions.height45 * 1.45,
                    width: Dimensions.height45 * 1.45,
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.redAccent.withValues(alpha: 0.55),
                        width: 1.2,
                      ),
                    ),
                    child: Icon(
                      Icons.flag_rounded,
                      color: Colors.white,
                      size: Dimensions.iconSize32,
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      'End game?'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Dimensions.font26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height10),
                  SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      'End this game and return to the main menu?'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                        height: 1.35,
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDialogButton(
                          text: 'Keep playing'.tr,
                          onTap: Get.back,
                        ),
                      ),
                      SizedBox(width: Dimensions.width10),
                      Expanded(
                        child: _buildDialogButton(
                          text: 'End game'.tr,
                          isDestructive: true,
                          onTap: () {
                            Get.back();
                            Get.until((route) => route.isFirst);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierColor: Colors.black.withValues(alpha: 0.5),
    );
  }

  @override
  void dispose() {
    _revealHoldController.dispose();
    super.dispose();
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
                    SizedBox(
                      width: Dimensions.screenWidth,
                      child: Text(
                        'Find the Chameleon!'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: Dimensions.font26 * 1.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          shadows: const [
                            Shadow(blurRadius: 10, color: Colors.black54),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height20),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width20 * 2),
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
                    _buildHoldRevealButton(),
                    SizedBox(height: Dimensions.height30),
                    _buildGameButton(
                      text: 'Rules'.tr,
                      icon: Icons.menu_book,
                      color: AppColors.glassWhite,
                      onTap: _showRulesDialog,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: IconBtn(
                  onTap: _showEndGameDialog,
                  icon: Icons.close,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHoldRevealButton() {
    return Listener(
      onPointerDown: (_) => _startRevealHold(),
      onPointerUp: (_) => _cancelRevealHold(),
      onPointerCancel: (_) => _cancelRevealHold(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: AnimatedBuilder(
            animation: _revealHoldController,
            builder: (context, child) {
              return Container(
                width: _gameButtonWidth,
                height: _gameButtonHeight,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.28),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: Colors.redAccent.withValues(alpha: 0.55),
                    width: _gameButtonBorderWidth,
                  ),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26, blurRadius: 8, spreadRadius: 1),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: constraints.maxWidth *
                                  _revealHoldController.value,
                              height: double.infinity,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.red.shade900
                                          .withValues(alpha: 0.55),
                                      Colors.red.shade900
                                          .withValues(alpha: 0.34),
                                      Colors.red.shade900.withValues(alpha: 0),
                                    ],
                                    stops: const [0, 0.82, 1],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.translate(
                            offset: Offset(0, Dimensions.height10 * 0.35),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.visibility,
                                    color: Colors.white,
                                    size: Dimensions.iconSize24 * 1.2),
                                SizedBox(width: Dimensions.width10),
                                Text(
                                  'Reveal'.tr,
                                  style: TextStyle(
                                    fontSize: Dimensions.font20 * 1.2,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Dimensions.height10 * 0.1),
                          Text(
                            '(hold)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.72,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.72),
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
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
            width: _gameButtonWidth,
            height: _gameButtonHeight,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.55),
                width: _gameButtonBorderWidth,
              ),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 8, spreadRadius: 1),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    color: Colors.white, size: Dimensions.iconSize24 * 1.2),
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

  Widget _buildDialogButton({
    required String text,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width10,
          vertical: Dimensions.height15,
        ),
        decoration: BoxDecoration(
          color: isDestructive
              ? Colors.redAccent.withValues(alpha: 0.28)
              : AppColors.glassWhite,
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          border: Border.all(
            color: isDestructive
                ? Colors.redAccent.withValues(alpha: 0.62)
                : AppColors.glassBorder,
            width: 1.2,
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            maxLines: 1,
            style: TextStyle(
              fontSize: Dimensions.font16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
