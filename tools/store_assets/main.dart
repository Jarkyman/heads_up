// Screenshot-only entrypoint: renders the real premium UI without changing an
// account entitlement or saving premium state. Never use this target to release.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:heads_up/controllers/settings_controller.dart';
import 'package:heads_up/controllers/categories_controller.dart';
import 'package:heads_up/controllers/game_controller.dart';
import 'package:heads_up/controllers/word_controller.dart';
import 'package:heads_up/helper/dependencies.dart' as dependencies;
import 'package:heads_up/helper/orientation_helper.dart';
import 'package:heads_up/main.dart' show MyApp;
import 'package:heads_up/repos/settings_repo.dart';
import 'package:heads_up/pages/game pages/chameleon_setup_page.dart';
import 'package:heads_up/pages/game pages/chameleon_role_page.dart';
import 'package:heads_up/pages/game pages/chameleon_reveal_page.dart';
import 'package:heads_up/pages/game pages/word_page.dart';

class ScreenshotSettingsController extends SettingsController {
  ScreenshotSettingsController({required super.settingsRepo});

  @override
  bool get isUnlockAll => true;

  @override
  Future<void> readSettings() async {
    await languageSettingsSave(await settingsRepo.languageSettingRead());
    update();
  }
}

Future<void> main() async {
  if (!kDebugMode) {
    throw StateError('Store screenshots must use a local debug build.');
  }
  WidgetsFlutterBinding.ensureInitialized();
  await dependencies.init();
  Get.replace<SettingsController>(
    ScreenshotSettingsController(settingsRepo: Get.find<SettingsRepo>()),
  );
  await OrientationHelper.setPortrait();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const MyApp());
  // Apply after the Flutter view and the home route's orientation have settled.
  await Future<void>.delayed(const Duration(seconds: 2));
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  const scene = String.fromEnvironment('HINTMASTER_STORE_SCENE');
  if (scene.isNotEmpty) {
    await _openStoreScene(scene);
  }
}

// Repeatable debug fixtures use the production pages and their real data.
// Only this separate capture app uses these compile-time fixtures. Device Hub and
// Apple's devicectl capture its actual framebuffer; no UI is composited here.
Future<void> _openStoreScene(String scene) async {
  const names = ['Alex', 'Jamie', 'Sam', 'Robin'];
  for (var attempt = 0; attempt < 200; attempt++) {
    if (Get.find<CategoryController>().categories.isNotEmpty &&
        Get.find<WordController>().words.isNotEmpty &&
        Get.currentRoute.contains('HomePage')) {
      break;
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
  final category = Get.find<CategoryController>().categories.firstWhere(
    (category) => category.category.toLowerCase() == 'animals',
  );
  await Get.find<SettingsRepo>().chameleonPlayerNamesSave(names);
  switch (scene) {
    case 'categories':
      break;
    case 'gameplay':
      Get.to(() => const WordPage(), arguments: [category, true]);
      await Future<void>.delayed(const Duration(milliseconds: 1000));
      final game = Get.find<GameController>();
      game.startCountdownTimer();
      await Future<void>.delayed(const Duration(milliseconds: 3300));
      game.generateFirstWord();
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      game.roundTimeController.pause();
      break;
    case 'setup':
      Get.to(() => const ChameleonSetupPage(), arguments: [category, true]);
      break;
    case 'role':
      Get.to(
        () => const ChameleonRolePage(),
        arguments: [category, names, 1, true],
      );
      break;
    case 'reveal':
      // A seeded finished round: actual category word and valid role data,
      // rendered by the unmodified production result page.
      final word = Get.find<WordController>()
          .generateWordsListByCategory(category)
          .first;
      Get.to(
        () => const ChameleonRevealPage(),
        arguments: [
          word,
          [word, word, 'Chameleon', word],
          category,
          names,
          1,
          true,
        ],
      );
      break;
    default:
      throw ArgumentError.value(scene, 'HINTMASTER_STORE_SCENE');
  }
  await Future<void>.delayed(const Duration(milliseconds: 1500));
  await WidgetsBinding.instance.endOfFrame;
  final size =
      WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
  await File(
    '${Directory.systemTemp.path}/store-scene-ready.json',
  ).writeAsString(
    jsonEncode({
      'scene': scene,
      'width': size.width,
      'height': size.height,
      'ready_at': DateTime.now().toUtc().toIso8601String(),
    }),
  );
}
