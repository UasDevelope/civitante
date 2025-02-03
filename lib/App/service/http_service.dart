import 'dart:convert';
import 'package:civitante/App/utilse/constant.dart';
import 'package:http/http.dart' as http;

class HttpService {
  static const String _baseUrl = 'https://civitante.vercel.app/user';

  static Future<dynamic> post(
      String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    print(data);
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
    String? uid = AppConstant().userID;
    print('here is url $url and uid is $uid');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${uid}',
        },
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
      final response = await http.delete(url);
      return _processResponse(response);
    } catch (e) {
      return {'error': 'Something went wrong', 'details': e.toString()};
    }
  }

  static dynamic _processResponse(http.Response response) {
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
