import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rate_my_app/rate_my_app.dart';

import '../helper/app_constants.dart';

class ReviewController {
  static final RateMyApp rateMyApp = RateMyApp(
    minDays: 0,
    minLaunches: 1,
    remindDays: 3,
    remindLaunches: 5,
    googlePlayIdentifier: AppConstants.ANDROID_ID,
    appStoreIdentifier: AppConstants.IOS_ID,
  );

  static bool checkReviewPopup(BuildContext context) {
    if (!rateMyApp.shouldOpenDialog) return false;

    rateMyApp.showRateDialog(
      context,
      title: 'Rate Hint Master'.tr,
      message: 'RateMsg'.tr,
      rateButton: 'RATE'.tr,
      noButton: 'NO THANKS'.tr,
      laterButton: 'MAYBE LATER'.tr,
      listener: (button) {
        // The button click listener (useful if you want to cancel the click event).
        switch (button) {
          case RateMyAppDialogButton.rate:
            debugPrint('Clicked on "Rate".');
            break;
          case RateMyAppDialogButton.later:
            debugPrint('Clicked on "Later".');
            break;
          case RateMyAppDialogButton.no:
            debugPrint('Clicked on "No".');
            break;
        }

        return true; // Return false if you want to cancel the click event.
      },
      ignoreNativeDialog: Platform.isAndroid,
      // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
      //dialogStyle: const DialogStyle(), // Custom dialog styles.
      onDismissed: () =>
          rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
      // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
      // actionsBuilder: (context) => [], // This one allows you to use your own buttons.
    );
    return true;
  }
}
