import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:heads_up/background_image.dart';
import 'package:heads_up/controllers/game_controller.dart';
import 'package:heads_up/helper/app_colors.dart';
import 'package:heads_up/helper/dimensions.dart';
import 'package:heads_up/models/category_model.dart';

import '../../controllers/settings_controller.dart';

class WordPage extends StatefulWidget {
  const WordPage({super.key});

  @override
  State<WordPage> createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  late final GameController _game;

  @override
  void initState() {
    super.initState();
    final CategoryModel category = Get.arguments[0];
    final bool canReplay = Get.arguments[1];
    final int roundTime = Get.find<SettingsController>().getRoundTime;

    // Put a fresh GameController for this round, then initialise it.
    _game = Get.put(GameController());
    _game.init(category, canReplay, roundTime);
  }

  @override
  void dispose() {
    // Delete the controller so it is fully disposed (sensors + timers cleaned up).
    Get.delete<GameController>();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    return GetBuilder<GameController>(
      builder: (game) {
        return Scaffold(
          body: GestureDetector(
            onTap: () {
              if (!game.isStartTimerRunning) {
                game.startCountdownTimer();
              }
              if (!game.isFirstWordGenerated && game.isGameStarted) {
                game.generateFirstWord();
              }
            },
            child: BackgroundImage(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                color: game.backgroundColor,
                child: SafeArea(
                  child: Center(
                    child: Stack(
                      children: [
                        // — Pre-start: tap to begin —
                        if (!game.isGameStarted && !game.isStartTimerRunning)
                          Center(
                            child: Text(
                              'Tap the screen to start'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: Dimensions.font26 * 2,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                        // — Countdown: 3, 2, 1 —
                        if (game.isStartTimerRunning && !game.isGameStarted)
                          Center(
                            child: Text(
                              '${game.startCountdown}',
                              style: TextStyle(
                                fontSize: Dimensions.font26 * 3,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                        // — In-game: timer ring —
                        if (game.isGameStarted)
                          Padding(
                            padding:
                                EdgeInsets.only(top: Dimensions.height30),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: CircularCountDownTimer(
                                width: Dimensions.height20 * 3,
                                height: Dimensions.height20 * 3,
                                duration: game.roundTime,
                                isReverse: true,
                                controller: game.roundTimeController,
                                textFormat: CountdownTextFormat.SS,
                                fillColor: Colors.green,
                                ringColor: Colors.grey,
                                textStyle: TextStyle(
                                  fontSize: Dimensions.font26,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                onComplete: game.onRoundComplete,
                              ),
                            ),
                          ),

                        // — In-game: current word —
                        if (game.isGameStarted)
                          Center(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                game.currentWord,
                                style: TextStyle(
                                  fontSize: Dimensions.font26 * 2.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                        // — Tilt indicator badge (correct / pass) —
                        if (game.isGameStarted &&
                            game.backgroundColor != Colors.transparent)
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: Dimensions.height20 * 2),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width20,
                                    vertical: Dimensions.height10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius30),
                                ),
                                child: Text(
                                  game.backgroundColor == AppColors.correctColor
                                      ? 'Correct'.tr
                                      : 'Pass'.tr,
                                  style: TextStyle(
                                    fontSize: Dimensions.font26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
