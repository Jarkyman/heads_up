import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heads_up/splash_page.dart';

import 'helper/app_constants.dart';
import 'helper/dependencies.dart' as dep;
import 'helper/locale_handler.dart';
import 'helper/orientation_helper.dart';
import 'widgets/show_consent_form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await showConsentForm();
  await dep.init();

  await OrientationHelper.setPortrait();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.APP_NAME,
      debugShowCheckedModeBanner: false,
      translations: LocaleHandler(),
      locale: const Locale('en', 'US'),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
