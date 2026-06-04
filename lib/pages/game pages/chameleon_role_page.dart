import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heads_up/background_image.dart';
import 'package:heads_up/controllers/word_controller.dart';
import 'package:heads_up/helper/app_colors.dart';
import 'package:heads_up/helper/dimensions.dart';
import 'package:heads_up/models/category_model.dart';
import 'package:heads_up/pages/game%20pages/chameleon_game_page.dart';
import 'package:heads_up/widgets/icon_button.dart';

class ChameleonRolePage extends StatefulWidget {
  const ChameleonRolePage({super.key});

  @override
  State<ChameleonRolePage> createState() => _ChameleonRolePageState();
}

class _ChameleonRolePageState extends State<ChameleonRolePage> with SingleTickerProviderStateMixin {
  late CategoryModel category;
  late int playersCount;
  late int impostersCount;
  late bool canReplay;

  String secretWord = "";
  List<String> roles = [];
  int currentPlayerIndex = 0;

  bool isHolding = false;
  bool isRevealed = false;
  bool hasRevealedOnce = false;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    category = Get.arguments[0];
    playersCount = Get.arguments[1];
    impostersCount = Get.arguments[2];
    canReplay = Get.arguments[3];

    _generateRoles();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isRevealed = true;
          hasRevealedOnce = true;
        });
      }
    });
  }

  void _generateRoles() {
    List<String> categoryWords = Get.find<WordController>().generateWordsListByCategory(category);
    if (categoryWords.isNotEmpty) {
      secretWord = categoryWords.first;
    } else {
      secretWord = "Word missing";
    }

    for (int i = 0; i < playersCount - impostersCount; i++) {
      roles.add(secretWord);
    }
    for (int i = 0; i < impostersCount; i++) {
      roles.add("Chameleon");
    }

    roles.shuffle();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _nextPlayer() {
    if (currentPlayerIndex < playersCount - 1) {
      setState(() {
        currentPlayerIndex++;
        isRevealed = false;
        isHolding = false;
        hasRevealedOnce = false;
        _animationController.reset();
      });
    } else {
      // Go to game page
      Get.off(() => const ChameleonGamePage(), arguments: [
        secretWord,
        roles,
        category,
        playersCount,
        impostersCount,
        canReplay,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundImage(
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: Dimensions.height45 * 2),
                  Text(
                    '${'Player'.tr} ${currentPlayerIndex + 1} - ${'Your turn'.tr}',
                    style: TextStyle(
                      fontSize: Dimensions.font26 * 1.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      shadows: const [
                        Shadow(blurRadius: 10, color: Colors.black54),
                      ],
                    ),
                  ),

                  // Interaction area fills the screen
                  Expanded(
                    child: Listener(
                      behavior: HitTestBehavior.opaque,
                      onPointerDown: (_) {
                        setState(() => isHolding = true);
                        _animationController.forward();
                      },
                      onPointerUp: (_) {
                        setState(() {
                          isHolding = false;
                          isRevealed = false;
                        });
                        _animationController.reverse();
                      },
                      onPointerCancel: (_) {
                        setState(() {
                          isHolding = false;
                          isRevealed = false;
                        });
                        _animationController.reverse();
                      },
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: isRevealed ? null : Dimensions.height20 * 12,
                          width: isRevealed ? null : Dimensions.width30 * 10,
                          padding: isRevealed ? EdgeInsets.symmetric(horizontal: Dimensions.width20) : null,
                          alignment: Alignment.center,
                          child: isRevealed
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: Dimensions.screenWidth * 0.9,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.center,
                                        child: Text(
                                          roles[currentPlayerIndex] == "Chameleon"
                                              ? 'You are the Chameleon!'.tr
                                              : roles[currentPlayerIndex],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: roles[currentPlayerIndex] == "Chameleon" ? Dimensions.font26 * 1.5 : Dimensions.font26 * 2.5,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (roles[currentPlayerIndex] != "Chameleon")
                                      Padding(
                                        padding: EdgeInsets.only(top: Dimensions.height10),
                                        child: Text(
                                          'Find out who the Chameleon is!'.tr,
                                          style: TextStyle(
                                            fontSize: Dimensions.font16,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                  ],
                                )
                              : Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    AnimatedBuilder(
                                      animation: _animationController,
                                      builder: (context, child) {
                                        if (!isHolding && _animationController.value == 0) {
                                          return const SizedBox.shrink();
                                        }
                                        return SizedBox(
                                          height: Dimensions.height20 * 8,
                                          width: Dimensions.height20 * 8,
                                          child: CircularProgressIndicator(
                                            value: _animationController.value,
                                            strokeWidth: 8,
                                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                                          ),
                                        );
                                      },
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '????????',
                                          style: TextStyle(
                                            fontSize: Dimensions.font26 * 1.5,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                        SizedBox(height: Dimensions.height10),
                                        Text(
                                          'Hold to reveal your word'.tr,
                                          style: TextStyle(
                                            fontSize: Dimensions.font16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white70,
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

                  // Next button
                    if (hasRevealedOnce)
                      GestureDetector(
                        onTap: _nextPlayer,
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
                                currentPlayerIndex < playersCount - 1
                                    ? 'Next player'.tr
                                    : 'Start game'.tr,
                                style: TextStyle(
                                  fontSize: Dimensions.font26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      SizedBox(height: Dimensions.height20 * 3 + 4), // Placeholder height to prevent jumping
                    
                    SizedBox(height: Dimensions.height45),
                  ],
                ),
              Positioned(
                top: 10,
                left: 10,
                child: IconBtn(
                  onTap: () {
                    // Dialog to confirm quitting setup?
                    Get.back();
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
