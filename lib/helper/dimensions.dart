import 'package:get/get.dart';

class Dimensions {
  static double get screenHeight => Get.context!.height; // 844 iPhone 12
  static double get screenWidth => Get.context!.width; // 390 iPhone 12

  //Dynamic height, padding and margin
  static double get height10 => screenHeight / 84.4;
  static double get height15 => screenHeight / 56.27;
  static double get height20 => screenHeight / 42.2;
  static double get height25 => screenHeight / 33.76;
  static double get height30 => screenHeight / 28.13;
  static double get height45 => screenHeight / 18.76;

  //Dynamic width, padding and margin
  static double get width5 => screenHeight / 168.8;
  static double get width10 => screenHeight / 84.4;
  static double get width15 => screenHeight / 56.27;
  static double get width20 => screenHeight / 42.2;
  static double get width30 => screenHeight / 28.13;
  static double get width45 => screenHeight / 18.76;

  //Font and icons
  static double get font16 => screenHeight / 52.75;
  static double get font20 => screenHeight / 42.2;
  static double get font26 => screenHeight / 32.46;
  static double get iconSize16 => screenHeight / 52.75;
  static double get iconSize24 => screenHeight / 35.17;
  static double get iconSize32 => screenHeight / 26.38;

  //Radius
  static double get radius10 => screenHeight / 84.4;
  static double get radius15 => screenHeight / 56.27;
  static double get radius20 => screenHeight / 42.2;
  static double get radius30 => screenHeight / 28.13;

  //Dynamic pageView
  static double get pageView => screenHeight / 2.64;
  static double get pageViewContainer => screenHeight / 3.84;
  static double get pageViewTextContainer => screenHeight / 7.03;

  //List view size
  static double get listViewImgSize => screenWidth / 3.25;
  static double get listViewTextContSize => screenWidth / 3.9;

  //popular food
  static double get popularFoodImgSize => screenHeight / 2.41;
  static double get bottomHeightBar => screenHeight / 7.03;

  //Splash Screen
  static double get splashImg => screenHeight / 1.2;
}
