import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:heads_up/background_image.dart';
import 'package:heads_up/controllers/word_controller.dart';
import 'package:heads_up/helper/app_colors.dart';
import 'package:heads_up/helper/dimensions.dart';
import 'package:heads_up/pages/game%20pages/result_page.dart';
import 'package:sensors_plus/sensors_plus.dart';

class WordPage extends StatefulWidget {
  const WordPage({super.key});

  @override
  State<WordPage> createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  double z = 0;
  bool delayBuffer = false;
  bool tipReset = false;
  bool cpState = false;
  bool isFirstWordGenerated = false;
  Color backgroundColor = Colors.transparent;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  late List<String> wordsList;
  List<String> wordsPassed = [
    'Grand Canyon',
    '#Machu Picchu',
    'Taj Mahal',
    'Colosseum',
    'Louvre',
    'Mount Everest',
    '#Big Ben'
  ];
  int score = 5;
  int wordIndex = 0;
  String _word = ' ';

  Timer _startWaitTimer = Timer(Duration.zero, () {});
  final CountDownController _roundTimeController = CountDownController();
  int _roundTime = 20;
  int _startWaitTime = 3;
  bool _isStartTimer = false;
  bool _isStarted = false;

  @override
  void initState() {
    super.initState();
    wordsList = Get.find<WordController>()
        .generateWordsListByCategory(Get.arguments[0]);
    //_roundTime = Get.find<SettingsController>().getRoundTime;
  }

  @override
  dispose() {
    _startWaitTimer.cancel();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  /// Starts timer for gameplay when fist 3 sec are counted and first word is generated.
  void startTimerForGameplay() {
    setState(() => _isStartTimer = true);
    const oneSec = Duration(seconds: 1);
    _startWaitTimer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_startWaitTime == 1) {
          setState(() {
            timer.cancel();
            setState(() {
              _isStarted = true;
              _roundTimeController.start();
            });
          });
        } else {
          setState(() {
            _startWaitTime--;
          });
        }
      },
    );
  }

  ///This check if the phone is tipped up or down on the side.
  /// Use z to listen on.
  void tipPhoneListener() {
    if (_isStarted) {
      //print('buffer = $delayBuffer\nTip = $tipReset\nz = $z');
      _streamSubscriptions.add(
        accelerometerEvents.listen((AccelerometerEvent event) {
          if (!delayBuffer && tipReset) {
            setState(() {
              z = event.z;
              if (z > 5) {
                callTipFunction(false, AppColors.passColor);
              } else if (z < -5) {
                callTipFunction(true, AppColors.correctColor);
              } else {
                backgroundColor = Colors.transparent;
                delayBuffer = false;
              }
            });
          }
        }),
      );
      _streamSubscriptions
          .add(accelerometerEvents.listen((AccelerometerEvent event) {
        if (!tipReset && !delayBuffer) {
          setState(() {
            z = event.z;
            if (z < 3 && z > -3) {
              backgroundColor = Colors.transparent;
              delayBuffer = false;
              tipReset = true;
              if (wordsPassed.isNotEmpty) {
                _nextWord(cpState);
              }
              if (!isFirstWordGenerated) {
                generateFirstWord();
              }
            }
          });
        }
      }));
    }
  }

  /// This is needed because the first word never gets set, to avoid this i generate the first word by this method.
  void generateFirstWord() {
    setState(() {
      String word = '#Grand Canyon';
      //wordsPassed.add(word);
      isFirstWordGenerated = true;
      _word = 'Grand Canyon';
    });
  }

  /// When phone is tipped message 'Correct' or 'Pass' Will show with a color.
  /// A delay on 500ms will start, after the game will continue.
  void callTipFunction(bool state, Color color) {
    if (state) {
      setState(() => _word = 'Correct'.tr);
    } else {
      setState(() => _word = 'Pass'.tr);
    }
    backgroundColor = color;
    delayBuffer = true;
    tipReset = false;
    const Duration(milliseconds: 500).delay(() {
      delayBuffer = false;
      cpState = state;
    });
  }

  /// Method to get the next word in the list.
  void _nextWord(bool isGuessed) {
    if (isGuessed) {
      wordsPassed[wordIndex] =
          wordsPassed[wordIndex].replaceFirstMapped('#', (match) => '');
    }

    if (isGuessed) {
      score++;
    }
    wordIndex++;

    if (wordIndex == wordsList.length) {
      wordsList.addAll(Get.find<WordController>()
          .generateWordsListByCategory(Get.arguments[0]));
    }
    String word = '#${wordsList[wordIndex]}';
    wordsPassed.add(word);
    setState(() {
      _word = wordsList[wordIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    const Duration(milliseconds: 100).delay(() {
      if (_isStarted && !isFirstWordGenerated) {
        setState(() {
          _word = 'Place the phone on your forehead to get the first word'.tr;
        });
      }
    });
    tipPhoneListener();
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (!_isStartTimer) {
            startTimerForGameplay();
          }
          if (!isFirstWordGenerated && _isStarted) {
            //TODO: test på en telefon
            generateFirstWord();
          }
        },
        child: BackgroundImage(
          child: Container(
            color: backgroundColor,
            child: SafeArea(
              child: Center(
                child: Stack(
                  children: [
                    if (!_isStarted && !_isStartTimer)
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
                    if (_isStartTimer && !_isStarted)
                      Center(
                        child: Text(
                          "$_startWaitTime",
                          style: TextStyle(
                            fontSize: Dimensions.font26 * 3,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    if (_isStarted)
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.height30),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: CircularCountDownTimer(
                            width: Dimensions.height20 * 3,
                            height: Dimensions.height20 * 3,
                            duration: _roundTime,
                            isReverse: true,
                            controller: _roundTimeController,
                            textFormat: CountdownTextFormat.SS,
                            fillColor: Colors.green,
                            ringColor: Colors.grey,
                            textStyle: TextStyle(
                              fontSize: Dimensions.font26,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            onComplete: () {
                              debugPrint('Countdown Ended');
                              Get.off(() => const ResultPage(), arguments: [
                                Get.arguments[0],
                                score,
                                wordsPassed,
                                Get.arguments[1],
                              ]);
                            },
                          ),
                        ),
                      ),
                    if (_isStarted)
                      Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            _word,
                            style: TextStyle(
                              fontSize: Dimensions.font26 * 2.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    /*Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () => _nextWord(true),
                              child: const Text(
                                'Correct',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                          SizedBox(
                            width: Dimensions.width20,
                          ),
                          ElevatedButton(
                              onPressed: () => _nextWord(false),
                              child: const Text(
                                'Pass',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                        ],
                      ),
                    ),*/
                    //if (!_isStarted)
                    /*Positioned(
                      top: Dimensions.height20,
                      right: Dimensions.width20,
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          height: Dimensions.width20 * 3.2,
                          width: Dimensions.width20 * 3.2,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),*/
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
