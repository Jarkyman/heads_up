import 'package:flutter_test/flutter_test.dart';
import 'package:heads_up/controllers/event_controller.dart';

void main() {
  test('seasonal cards follow local dates and clear after each season', () {
    final controller = EventController();
    final dates = {
      DateTime(2026, 10, 24, 23, 59): EventStatus.none,
      DateTime(2026, 10, 25): EventStatus.halloween,
      DateTime(2026, 11, 4, 23, 59): EventStatus.halloween,
      DateTime(2026, 11, 5): EventStatus.none,
      DateTime(2026, 12, 1): EventStatus.christmas,
      DateTime(2027, 1, 4, 23, 59): EventStatus.christmas,
      DateTime(2027, 1, 5): EventStatus.none,
      DateTime(2027, 2, 10): EventStatus.valentine,
      DateTime(2027, 2, 15, 23, 59): EventStatus.valentine,
      DateTime(2027, 2, 16): EventStatus.none,
      DateTime(2027, 3, 24, 23, 59): EventStatus.none,
      DateTime(2027, 3, 25): EventStatus.easter,
      DateTime(2027, 3, 28, 23, 59): EventStatus.easter,
      DateTime(2027, 3, 29): EventStatus.none,
    };

    for (final entry in dates.entries) {
      controller.getDate(now: entry.key);
      expect(controller.getEventStatus, entry.value, reason: '${entry.key}');
    }
  });
}
