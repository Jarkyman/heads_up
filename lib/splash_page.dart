import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heads_up/background_image.dart';
import 'package:heads_up/controllers/categories_controller.dart';
import 'package:heads_up/controllers/event_controller.dart';
import 'package:heads_up/controllers/word_controller.dart';
import 'package:heads_up/pages/home_page.dart';
import 'package:heads_up/widgets/app_logo_hero.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'controllers/review_controller.dart';
import 'controllers/settings_controller.dart';
import 'helper/app_colors.dart';
import 'helper/dimensions.dart';

const Duration _homeRouteDuration = Duration(milliseconds: 850);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  bool _hasOpenedHome = false;

  void _openHome() {
    if (_hasOpenedHome || !mounted) return;
    _hasOpenedHome = true;
    Get.off(
      () => const HomePage(),
      duration: _homeRouteDuration,
      transition: Transition.noTransition,
    );
  }

  Future<void> _loadResource() async {
    WakelockPlus.enable();
    await Get.find<SettingsController>().readSettings();

    await Get.find<EventController>().getDate();

    await Get.find<CategoryController>().readAllCategories();

    await Get.find<WordController>().readAllWords();

    ReviewController.rateMyApp.init().then((_) {
      for (var condition in ReviewController.rateMyApp.conditions) {
        if (condition is DebuggableCondition) {
          //condition.valuesAsString;
        }
      }
    });

    if (controller.isCompleted) {
      await Future.delayed(const Duration(milliseconds: 400));
      _openHome();
    } else {
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _openHome();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    _loadResource();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BackgroundImage(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ScaleTransition(
                    scale: animation,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const AppLogoHero(height: 75),
                          SizedBox(
                            height: 145,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.width45),
                              child: Image.asset('assets/images/Text.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 25,
                    right: 25,
                    child: CircularProgressIndicator(
                      color: AppColors.mainColor,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
