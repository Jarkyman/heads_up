// Screenshot-only entrypoint: renders the real premium UI without changing an
// account entitlement or saving premium state. Never use this target to release.
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:heads_up/controllers/settings_controller.dart';
import 'package:heads_up/helper/dependencies.dart' as dependencies;
import 'package:heads_up/helper/orientation_helper.dart';
import 'package:heads_up/main.dart' show MyApp;
import 'package:heads_up/repos/settings_repo.dart';

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
}
