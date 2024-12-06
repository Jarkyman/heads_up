import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:heads_up/repos/event_repo.dart';

enum EventStatus { none, halloween, christmas, valentine, easter }

// Thanksgiving, St Patrick's Day,

class EventController extends GetxController implements GetxService {
  EventRepo eventRepo;
  DateTime? _eventDate;
  EventStatus _eventStatus = EventStatus.none;

  DateTime? get getEventDate => _eventDate;
  EventStatus get getEventStatus => _eventStatus;

  EventController({required this.eventRepo});

  Future<void> getDate() async {
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    Response response = await eventRepo.getTime(currentTimeZone);
    //print(response.body);
    if (response.statusCode == 200) {
      await setDate(response.body['dateTime']);
      //await setDate('2024-03-31 17:35:22.895127'); //2023-02-14 / 2023-10-31 / 2023-12-24 / 2024-03-31
      setEventStatus();
    }
  }

  setDate(String date) {
    _eventDate = DateTime.parse(date);
  }

  void setEventStatus() async {
    if (_isChristmas(_eventDate!, _eventDate!.year)) {
      _eventStatus = EventStatus.christmas;
      //update();
    } else if (_isHalloween(_eventDate!, _eventDate!.year)) {
      _eventStatus = EventStatus.halloween;
      //update();
    } else if (_isValentine(_eventDate!, _eventDate!.year)) {
      _eventStatus = EventStatus.valentine;
      //update();
    } else if (_isEaster(_eventDate!, _eventDate!.year)) {
      _eventStatus = EventStatus.easter;
      //update();
    }
  }

  bool _isChristmas(DateTime date, int year) {
    print(date);
    DateTime christmasStart = DateTime(year, 12, 1);
    DateTime christmasEnd = DateTime(year, 1, 5);
    if (date.isAfter(christmasStart) || date.isBefore(christmasEnd)) {
      return true;
    }
    return false;
  }

  bool _isHalloween(DateTime date, int year) {
    print(date);
    DateTime halloweenStart = DateTime(year, 10, 25);
    DateTime halloweenEnd = DateTime(year, 11, 5);
    if (date.isAfter(halloweenStart) && date.isBefore(halloweenEnd)) {
      return true;
    }
    return false;
  }

  bool _isValentine(DateTime date, int year) {
    print(date);
    DateTime valentineStart = DateTime(year, 02, 10);
    DateTime valentineEnd = DateTime(year, 02, 16);
    if (date.isAfter(valentineStart) && date.isBefore(valentineEnd)) {
      return true;
    }
    return false;
  }

  bool _isEaster(DateTime date, int year) {
    print(date);
    DateTime easterSunday = _calculateEaster(year);
    DateTime easterStart = easterSunday.subtract(Duration(days: 3)); // Skærtorsdag
    DateTime easterEnd = easterSunday.add(Duration(days: 1)); // 2. Påskedag

    return date.isAfter(easterStart) && date.isBefore(easterEnd);
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
