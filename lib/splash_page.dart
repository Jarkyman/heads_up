import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heads_up/background_image.dart';
import 'package:heads_up/controllers/categories_controller.dart';
import 'package:heads_up/controllers/event_controller.dart';
import 'package:heads_up/controllers/word_controller.dart';
import 'package:heads_up/helper/app_constants.dart';
import 'package:heads_up/pages/home_page.dart';
import 'package:wakelock/wakelock.dart';
import 'controllers/settings_controller.dart';
import 'helper/app_colors.dart';
import 'helper/dimensions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  Future<void> _loadResource() async {
    Wakelock.enable();
    print('loading settings');
    await Get.find<SettingsController>().readSettings();
    print('loaded settings');
    print('loading Events');
    await Get.find<EventController>().getDate();
    print('loaded Events');
    print('loading Categories');
    await Get.find<CategoryController>().readAllCategories();
    print('Loaded Categories');
    print('loading Words');
    await Get.find<WordController>().readAllWords();
    print('Loaded Words');
    print('Flutter phone locale = ${Platform.localeName}');
    if (controller.isCompleted) {
      await Future.delayed(const Duration(milliseconds: 4000));
      Get.off(() => const HomePage(),
          duration: Duration(seconds: 2),
          transition: Transition.circularReveal);
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Get.off(() => const HomePage(),
              duration: Duration(seconds: 2),
              transition: Transition.circularReveal));
      //Timer(Duration(seconds: 3), () => Get.off(TestPage()));
    }
  }

  @override
  void initState() {
    super.initState();
    _loadResource();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
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
                          Hero(
                            tag: AppConstants.LOGO_TAG,
                            child: SizedBox(
                              height: 75,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width45),
                                child: Image.asset('assets/images/Icon.png'),
                              ),
                            ),
                          ),
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
