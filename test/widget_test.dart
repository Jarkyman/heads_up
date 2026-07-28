import 'package:flutter_test/flutter_test.dart';
import 'package:heads_up/helper/ad_policy.dart';

void main() {
  test('interstitials stay disabled for the first 20 launches', () {
    for (int launchCount = 1; launchCount <= 20; launchCount++) {
      expect(
        AdPolicy.shouldShowInterstitial(
          launchCount: launchCount,
          resultRoll: 2,
        ),
        isFalse,
      );
    }
  });

  test('interstitials can start on launch 21', () {
    expect(
      AdPolicy.shouldShowInterstitial(
        launchCount: 21,
        resultRoll: 2,
      ),
      isTrue,
    );
    expect(
      AdPolicy.shouldShowInterstitial(
        launchCount: 21,
        resultRoll: 1,
      ),
      isFalse,
    );
  });
}
