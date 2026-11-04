import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:heads_up/controllers/event_controller.dart';
import 'package:heads_up/controllers/game_controller.dart';
import 'package:heads_up/controllers/settings_controller.dart';
import 'package:heads_up/data/api/api_client.dart';
import 'package:heads_up/helper/dimensions.dart';
import 'package:heads_up/models/category_model.dart';
import 'package:heads_up/pages/game pages/word_page.dart';
import 'package:heads_up/repos/event_repo.dart';
import 'package:heads_up/repos/settings_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _PreviewRound extends GameController {
  @override
  void init(CategoryModel cat, bool replay, int roundTime) {
    isGameStarted = true;
    isFirstWordGenerated = true;
    currentWord = 'Lemur';
  }

  @override
  int get roundTime => 60;
}

void main() {
  test(
    'rotating keeps gameplay readable and unfolding recalculates its scale',
    () {
      final portrait = Dimensions.gameplay(const Size(402, 874));
      final landscape = Dimensions.gameplay(const Size(874, 402));
      expect(landscape.font26 * 2.5, greaterThanOrEqualTo(65));
      expect(landscape.font26, portrait.font26);
      expect(landscape.height20, portrait.height20);
      final outer = Dimensions.gameplay(const Size(466, 678));
      final inner = Dimensions.gameplay(const Size(951, 669));
      expect(inner.font26, greaterThan(outer.font26));
      expect(Dimensions.gameplay(const Size(678, 466)).font26, outer.font26);
    },
  );

  testWidgets(
    'landscape word stays large while long words fit on each display',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(874, 402);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(Get.reset);
      SharedPreferences.setMockInitialValues({});
      final api = ApiClient(appBaseUrl: '');
      final repo = SettingsRepo(
        sharedPreferences: await SharedPreferences.getInstance(),
        apiClient: api,
      );
      Get.put(SettingsController(settingsRepo: repo));
      Get.put(EventController(eventRepo: EventRepo(apiClient: api)));
      final round = Get.put<GameController>(_PreviewRound());
      await tester.pumpWidget(
        GetMaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => Get.to(
                () => const WordPage(),
                arguments: [
                  CategoryModel(category: 'Animals', iconUrl: '', colorHex: 0),
                  false,
                ],
              ),
              child: const Text('Play'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Play'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.getSize(find.text('Lemur')).height, greaterThan(60));
      for (final size in [
        const Size(568, 320),
        const Size(874, 402),
        const Size(678, 466),
        const Size(951, 669),
        const Size(1376, 1032),
      ]) {
        tester.view.physicalSize = size;
        round.currentWord = 'The Lord of the Rings';
        round.update();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        expect(tester.takeException(), isNull, reason: '$size');
        final fitted = find.ancestor(
          of: find.text(round.currentWord),
          matching: find.byType(FittedBox),
        );
        final bounds = tester.getRect(fitted);
        expect(bounds.left, greaterThanOrEqualTo(0));
        expect(bounds.right, lessThanOrEqualTo(size.width));
        expect(bounds.bottom, lessThanOrEqualTo(size.height));
      }
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    },
  );
}
