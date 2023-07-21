import 'package:heads_up/data/api/api_client.dart';
import 'package:get/get.dart';
import 'package:heads_up/helper/app_constants.dart';

class EventRepo {
  final ApiClient apiClient;

  EventRepo({required this.apiClient});

  Future<Response> getTime(String timeZone) async {
    String url = AppConstants.TIME_API + timeZone;
    return await apiClient.getData(url);
  }
}
