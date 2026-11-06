import 'package:flutter_test/flutter_test.dart';
import 'package:heads_up/helper/chameleon_player_order.dart';
import 'package:heads_up/repos/settings_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test(
    'random start rotates seating order and leaves the saved order intact',
    () {
      final names = ['Anna', 'Bo', 'Clara', 'David'];
      expect(chameleonPlayerOrder(names, startIndex: 2), [
        'Clara',
        'David',
        'Anna',
        'Bo',
      ]);
      expect(names, ['Anna', 'Bo', 'Clara', 'David']);
      expect(chameleonPlayerOrder(names, startIndex: 0), names);
      expect(chameleonPlayerOrder(names, startIndex: 3), [
        'David',
        'Anna',
        'Bo',
        'Clara',
      ]);
    },
  );

  test('random start defaults on and survives reloading preferences', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repo = SettingsRepo(sharedPreferences: prefs);
    expect(repo.chameleonRandomStartRead(), isTrue);
    await repo.chameleonRandomStartSave(false);
    await prefs.reload();
    expect(repo.chameleonRandomStartRead(), isFalse);
    await repo.chameleonRandomStartSave(true);
    expect(repo.chameleonRandomStartRead(), isTrue);
  });
}
