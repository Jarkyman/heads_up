import 'package:get/get.dart';

class ApiClient extends GetConnect implements GetxService {
  final String appBaseUrl;

  late Map<String, String> _mainHeaders;

  ApiClient({required this.appBaseUrl}) {
    baseUrl = appBaseUrl;
    _mainHeaders = {
      'content-type': 'application/json; charset=utf-8',
    };
  }

  void updateHeader() {
    _mainHeaders = {
      'Content-type': 'application/json; charset=utf-8',
    };
  }

  Future<Response> getData(String uri, {Map<String, String>? headers}) async {
    final _connect = GetConnect();
    try {
      Response response = await _connect.get(uri, headers: _mainHeaders);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postData(String uri, dynamic body) async {
    print(body.toString());
    try {
      Response response = await post(uri, body, headers: _mainHeaders);
      print(response.toString());
      return response;
    } catch (e) {
      print(e.toString());
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
}
