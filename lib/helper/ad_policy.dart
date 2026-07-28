import 'package:heads_up/helper/app_constants.dart';

class AdPolicy {
  const AdPolicy._();

  static bool shouldShowInterstitial({
    required int launchCount,
    required int resultRoll,
  }) {
    return launchCount > AppConstants.INTERSTITIAL_FREE_LAUNCHES &&
        resultRoll == AppConstants.INTERSTITIAL_RESULT_ROLL;
  }
}
