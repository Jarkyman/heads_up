import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heads_up/controllers/word_controller.dart';
import 'package:heads_up/helper/app_colors.dart';
import 'package:heads_up/models/category_model.dart';
import 'package:heads_up/pages/game%20pages/result_page.dart';
import 'package:sensors_plus/sensors_plus.dart';

enum TiltState { neutral, correct, pass }

class GameController extends GetxController {
  // — Game config —
  late CategoryModel category;
  late bool canReplay;
  late int _roundTime;

  // — Word state —
  late List<String> _wordsList;
  final List<String> wordsPassed = [];
  int wordIndex = 0;
  int score = 0;
  String currentWord = ' ';
  bool isFirstWordGenerated = false;

  // — Phase flags —
  bool isStartTimerRunning = false;
  bool isGameStarted = false;
  int startCountdown = 3;

  // — Tilt feedback —
  TiltState tiltState = TiltState.neutral;
  Color backgroundColor = Colors.transparent;

  // — Private helpers —
  bool _delayBuffer = false;
  bool _tipReset = false;
  bool _lastTiltWasCorrect = false;

  // — Timers & controllers —
  Timer _startWaitTimer = Timer(Duration.zero, () {});
  final CountDownController roundTimeController = CountDownController();
  final List<StreamSubscription<dynamic>> _streamSubscriptions = [];

  void init(CategoryModel cat, bool replay, int roundTime) {
    category = cat;
    canReplay = replay;
    _roundTime = roundTime;
    _wordsList =
        Get.find<WordController>().generateWordsListByCategory(category);
    _initSensorListeners();
  }

  int get roundTime => _roundTime;

  /// Starts the 3-second countdown, then kicks off the real round timer.
  void startCountdownTimer() {
    if (isStartTimerRunning) return;
    isStartTimerRunning = true;
    startCountdown = 3;
    update();

    const oneSec = Duration(seconds: 1);
    _startWaitTimer = Timer.periodic(oneSec, (timer) {
      if (startCountdown <= 1) {
        timer.cancel();
        isGameStarted = true;
        roundTimeController.start();
        update();
      } else {
        startCountdown--;
        update();
      }
    });
  }

  /// Called when the round timer reaches zero → navigate to results.
  void onRoundComplete() {
    Get.off(
      () => const ResultPage(),
      arguments: [category, score, wordsPassed, canReplay],
    );
  }

  /// The first word is only set after the phone is held upright for the first time.
  void generateFirstWord() {
    if (isFirstWordGenerated) return;
    final word = _wordsList[wordIndex];
    wordsPassed.add('#$word'); // '#' prefix = not guessed yet
    isFirstWordGenerated = true;
    currentWord = word;
    update();
  }

  void _nextWord(bool wasGuessed) {
    // Remove '#' prefix if the player guessed correctly
    if (wasGuessed) {
      wordsPassed[wordIndex] =
          wordsPassed[wordIndex].replaceFirstMapped('#', (_) => '');
      score++;
    }
    wordIndex++;

    // If we run out of words, generate a fresh shuffled batch
    if (wordIndex >= _wordsList.length) {
      _wordsList.addAll(
          Get.find<WordController>().generateWordsListByCategory(category));
    }

    final word = _wordsList[wordIndex];
    wordsPassed.add('#$word');
    currentWord = word;
    update();
  }

  void _initSensorListeners() {
    // Listener 1: detects tilt when the phone has been reset to neutral
    _streamSubscriptions.add(
      accelerometerEventStream().listen((AccelerometerEvent event) {
        if (!isGameStarted) return;
        if (_delayBuffer || !_tipReset) return;

        final z = event.z;
        if (z > 5) {
          _onTilt(wasCorrect: false);
        } else if (z < -5) {
          _onTilt(wasCorrect: true);
        } else {
          backgroundColor = Colors.transparent;
          _delayBuffer = false;
          update();
        }
      }),
    );

    // Listener 2: waits for phone to return to neutral before registering next tilt
    _streamSubscriptions.add(
      accelerometerEventStream().listen((AccelerometerEvent event) {
        if (!isGameStarted) return;
        if (_tipReset || _delayBuffer) return;

        final z = event.z;
        if (z < 3 && z > -3) {
          _delayBuffer = false;
          _tipReset = true;
          backgroundColor = Colors.transparent;
          if (!isFirstWordGenerated) {
            generateFirstWord();
          } else if (wordsPassed.isNotEmpty) {
            _nextWord(_lastTiltWasCorrect);
          }
          update();
        }
      }),
    );
  }

  void _onTilt({required bool wasCorrect}) {
    _lastTiltWasCorrect = wasCorrect;
    currentWord = wasCorrect ? 'Correct'.tr : 'Pass'.tr;
    backgroundColor =
        wasCorrect ? AppColors.correctColor : AppColors.passColor;
    _delayBuffer = true;
    _tipReset = false;
    update();

    const Duration(milliseconds: 500).delay(() {
      _delayBuffer = false;
      update();
    });
  }

  @override
  void onClose() {
    _startWaitTimer.cancel();
    for (final sub in _streamSubscriptions) {
      sub.cancel();
    }
    super.onClose();
  }
}
