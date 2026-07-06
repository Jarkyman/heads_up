import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class OrientationHelper {
  static const List<DeviceOrientation> _portrait = [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ];

  static const List<DeviceOrientation> _landscape = [
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ];

  static Future<void> setPortrait() => _set(_portrait);

  static Future<void> setLandscape() => _set(_landscape);

  static Future<void> _set(List<DeviceOrientation> orientations) async {
    try {
      await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      await Future<void>.delayed(const Duration(milliseconds: 80));
      await SystemChrome.setPreferredOrientations(orientations);
    } catch (error) {
      debugPrint('Failed to change orientation: $error');
    }
  }
}
