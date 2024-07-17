import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:heads_up/repos/event_repo.dart';

enum EventStatus { none, halloween, christmas, valentine }

// Thanksgiving, St Patrick's Day, Easter

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
      //await setDate('2023-12-24 17:35:22.895127'); //2023-02-14 / 2023-10-31 / 2023-12-24
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
    DateTime halloweenStart = DateTime(year, 02, 10);
    DateTime halloweenEnd = DateTime(year, 02, 16);
    if (date.isAfter(halloweenStart) && date.isBefore(halloweenEnd)) {
      return true;
    }
    return false;
  }
}
