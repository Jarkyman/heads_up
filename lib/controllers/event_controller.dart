import 'package:get/get.dart';

enum EventStatus { none, halloween, christmas, valentine, easter }

// Thanksgiving, St Patrick's Day,

class EventController extends GetxController implements GetxService {
  DateTime? _eventDate;
  EventStatus _eventStatus = EventStatus.none;

  DateTime? get getEventDate => _eventDate;
  EventStatus get getEventStatus => _eventStatus;

  void getDate({DateTime? now}) {
    final date = now ?? DateTime.now();
    _eventDate = date;
    final year = date.year;
    if (_isChristmas(date, year)) {
      _eventStatus = EventStatus.christmas;
    } else if (_isHalloween(date, year)) {
      _eventStatus = EventStatus.halloween;
    } else if (_isValentine(date, year)) {
      _eventStatus = EventStatus.valentine;
    } else if (_isEaster(date, year)) {
      _eventStatus = EventStatus.easter;
    } else {
      _eventStatus = EventStatus.none;
    }
  }

  bool _isChristmas(DateTime date, int year) {
    DateTime christmasStart = DateTime(year, 12, 1);
    DateTime christmasEnd = DateTime(year, 1, 5);
    if (!date.isBefore(christmasStart) || date.isBefore(christmasEnd)) {
      return true;
    }
    return false;
  }

  bool _isHalloween(DateTime date, int year) {
    DateTime halloweenStart = DateTime(year, 10, 25);
    DateTime halloweenEnd = DateTime(year, 11, 5);
    if (!date.isBefore(halloweenStart) && date.isBefore(halloweenEnd)) {
      return true;
    }
    return false;
  }

  bool _isValentine(DateTime date, int year) {
    DateTime valentineStart = DateTime(year, 02, 10);
    DateTime valentineEnd = DateTime(year, 02, 16);
    if (!date.isBefore(valentineStart) && date.isBefore(valentineEnd)) {
      return true;
    }
    return false;
  }

  bool _isEaster(DateTime date, int year) {
    DateTime easterSunday = _calculateEaster(year);
    final easterStart = DateTime(
      year,
      easterSunday.month,
      easterSunday.day - 3,
    );
    final easterEnd = DateTime(year, easterSunday.month, easterSunday.day + 1);

    return !date.isBefore(easterStart) && date.isBefore(easterEnd);
  }

  DateTime _calculateEaster(int year) {
    int a = year % 19;
    int b = (year / 100).floor();
    int c = year % 100;
    int d = (b / 4).floor();
    int e = b % 4;
    int f = ((b + 8) / 25).floor();
    int g = ((b - f + 1) / 3).floor();
    int h = (19 * a + b - d - g + 15) % 30;
    int i = (c / 4).floor();
    int k = c % 4;
    int l = (32 + 2 * e + 2 * i - h - k) % 7;
    int m = ((a + 11 * h + 22 * l) / 451).floor();
    int month = ((h + l - 7 * m + 114) / 31).floor();
    int day = ((h + l - 7 * m + 114) % 31) + 1;

    return DateTime(year, month, day);
  }
}
