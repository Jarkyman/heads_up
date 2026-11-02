import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:heads_up/controllers/event_controller.dart';
import 'package:heads_up/data/api/api_client.dart';
import 'package:heads_up/models/category_model.dart';
import 'package:heads_up/helper/dimensions.dart';
import 'package:heads_up/pages/game pages/chameleon_setup_page.dart';
import 'package:heads_up/repos/event_repo.dart';
import 'package:heads_up/repos/settings_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('drag moves edited names together and saves their new order', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1206, 2622);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({
      'chameleon-player-names': ['Anna', 'Bo', 'Clara', 'David'],
    });
    final api = ApiClient(appBaseUrl: '');
    final repo = SettingsRepo(
      sharedPreferences: await SharedPreferences.getInstance(),
      apiClient: api,
    );
    Get.put(repo);
    Get.put(EventController(eventRepo: EventRepo(apiClient: api)));
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: TextButton(
            onPressed: () => Get.to(
              () => const ChameleonSetupPage(),
              arguments: [
                CategoryModel(category: 'Animals', iconUrl: '', colorHex: 0),
                false,
              ],
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(repo.chameleonRandomStartRead(), isTrue);
    await tester.tap(find.byIcon(Icons.shuffle_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byIcon(Icons.shuffle_rounded), findsOneWidget);
    expect(find.byIcon(Icons.repeat_rounded), findsOneWidget);
    await tester.pumpAndSettle();
    expect(repo.chameleonRandomStartRead(), isFalse);
    expect(find.byIcon(Icons.repeat_rounded), findsOneWidget);
    await tester.tap(find.byIcon(Icons.repeat_rounded));
    await tester.pumpAndSettle();
    expect(repo.chameleonRandomStartRead(), isTrue);
    expect(find.byIcon(Icons.shuffle_rounded), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'Alice');
    tester.testTextInput.hide();
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    final handles = find.byIcon(Icons.drag_handle_rounded);
    expect(handles, findsNWidgets(4));
    final from = tester.getCenter(handles.first);
    final to = tester.getCenter(handles.at(2)) + const Offset(0, 25);
    final gesture = await tester.startGesture(from);
    await gesture.moveBy(const Offset(0, 10));
    await tester.pump(const Duration(milliseconds: 300));
    await gesture.moveTo(to);
    await tester.pump(const Duration(milliseconds: 500));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(await repo.chameleonPlayerNamesRead(), [
      'Bo',
      'Alice',
      'Clara',
      'David',
    ]);
    final names = tester
        .widgetList<TextField>(find.byType(TextField))
        .map((field) => field.controller!.text)
        .toList();
    expect(names, ['Bo', 'Alice', 'Clara', 'David']);
    expect(tester.takeException(), isNull);
    // Native Duo pixel sizes at 3x, including a fold/unfold round trip.
    for (final size in [
      const Size(960, 1704),
      const Size(1206, 2622),
      const Size(1398, 2034),
      const Size(2007, 2853),
      const Size(1398, 2034),
    ]) {
      tester.view.physicalSize = size;
      await tester.pumpAndSettle();
      expect(Dimensions.screenWidth, size.width / 3);
      expect(Dimensions.screenHeight, size.height / 3);
      expect(find.byType(TextField), findsNWidgets(4));
      final countSize = tester.getSize(
        find.byKey(const ValueKey('chameleon-count-card')),
      );
      final toggleSize = tester.getSize(
        find.byKey(const ValueKey('chameleon-start-order-button')),
      );
      expect(toggleSize.height, countSize.height);
      expect(toggleSize.width, toggleSize.height);
      expect(tester.takeException(), isNull);
    }
    await tester.pumpWidget(const SizedBox.shrink());
    Get.reset();
  });
}
