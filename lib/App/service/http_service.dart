import 'dart:convert';
import 'dart:developer';
import 'package:civitante/App/utilse/constant.dart';
import 'package:http/http.dart' as http;

class HttpService {
  static const String _baseUrl = 'http://16.170.211.87:5000/user';

  static Future<dynamic> post(
      String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    print("User id is ${AppConstant().userID}");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConstant().userID}',
        },
        body: jsonEncode(data),
      );
      print('response : ${response.body}');
      return _processResponse(response);
    } catch (e) {
      return {'error': 'Something went wrong', 'details': e.toString()};
    }
  }

  static Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    log(" get Url is $url ");
    log(" get token is ${AppConstant().userID} ");
    try {
      var header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppConstant().userID}',
      };
      // log("Header is $header");
      final response = await http.get(
        url,
        headers: header,
      );
      return _processResponse(response);
    } catch (e) {
      return {'error': 'Something went wrong', 'details': e.toString()};
    }
  }

  static Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConstant().userID}',
        },
        body: jsonEncode(data),
      );
      return _processResponse(response);
    } catch (e) {
      return {'error': 'Something went wrong', 'details': e.toString()};
    }
  }

  static Future<dynamic> delete(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      print(url);
      final response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppConstant().userID}',
      });
      return _processResponse(response);
    } catch (e) {
      return {'error': 'Something went wrong', 'details': e.toString()};
    }
  }

  static dynamic _processResponse(http.Response response) {
    log("Response code is ${response.statusCode}");
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 400:
      case 401:
      case 403:
      case 500:
        return {
          'error': 'HTTP error ${response.statusCode}',
          'details': response.body
        };
      default:
        return {'error': 'Unknown error', 'details': response.body};
    }
  }
}
