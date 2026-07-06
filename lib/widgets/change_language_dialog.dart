import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heads_up/controllers/word_controller.dart';

import '../../controllers/settings_controller.dart';
import '../../helper/app_colors.dart';
import '../../helper/dimensions.dart';

class _LanguageOption {
  const _LanguageOption({
    required this.name,
    required this.locale,
  });

  final String name;
  final Locale locale;

  String get localeKey => locale.toString();
  String get flagAsset =>
      'assets/locale/flags/${locale.countryCode!.toLowerCase()}.png';
}

const List<_LanguageOption> _locales = [
  _LanguageOption(name: 'Dansk', locale: Locale('da', 'DK')),
  _LanguageOption(name: 'English', locale: Locale('en', 'US')),
  _LanguageOption(name: 'Norsk', locale: Locale('nb', 'NO')),
  _LanguageOption(name: 'Svenska', locale: Locale('sv', 'SE')),
];

Future<void> updateLanguage(Locale locale) async {
  await Get.find<SettingsController>().languageSettingsSave(locale.toString());
  await Get.find<WordController>().readAllWords();
  Get.back();
}

void buildLanguageDialog() {
  Get.dialog(
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
              border: Border.all(color: AppColors.glassBorder, width: 1.4),
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
                Text(
                  'Choose Your Language'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Dimensions.font26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: Dimensions.height20),
                ..._locales.map((language) {
                  final isSelected =
                      Get.locale?.toString() == language.localeKey;
                  return Padding(
                    padding: EdgeInsets.only(bottom: Dimensions.height10),
                    child: _LanguageTile(
                      language: language,
                      isSelected: isSelected,
                      onTap: () => updateLanguage(language.locale),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    ),
    barrierColor: Colors.black.withValues(alpha: 0.45),
  );
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  final _LanguageOption language;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height15,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.greenColor.withValues(alpha: 0.28)
              : AppColors.glassWhite,
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          border: Border.all(
            color: isSelected
                ? AppColors.greenColor.withValues(alpha: 0.68)
                : AppColors.glassBorder,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: Dimensions.height30 * 1.25,
              width: Dimensions.height30 * 1.25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.38),
                  width: 1.2,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  language.flagAsset,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: Dimensions.width15),
            Expanded(
              child: Text(
                language.name,
                style: TextStyle(
                  fontSize: Dimensions.font20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 160),
              child: isSelected
                  ? Icon(
                      Icons.check_circle_rounded,
                      key: const ValueKey('selected'),
                      color: AppColors.greenColor,
                      size: Dimensions.iconSize24,
                    )
                  : Icon(
                      Icons.radio_button_unchecked_rounded,
                      key: const ValueKey('unselected'),
                      color: Colors.white70,
                      size: Dimensions.iconSize24,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
