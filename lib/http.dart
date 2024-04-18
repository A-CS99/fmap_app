import 'dart:convert';
import 'package:fmap_app/funcs.dart';
import 'package:http/http.dart' as http;
import 'const.dart';

const String baseUrl = testUrl;

Future<Map<String, dynamic>> myGet(String path, List<Map<String, String>> query) async {
  final url = '$baseUrl$path${query.isNotEmpty ? '?': ''}${query.map((e) => '${e.keys.first}=${e.values.first}').join('&')}';
  // consoleLog('| GET | $url');
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final res = jsonDecode(response.body);
    consoleLog('| GET | $path res: $res');
    return jsonDecode(response.body);
  } else {
    consoleLog('| GET | $path error: ${response.statusCode} ${response.body}');
    throw Exception('Failed to load data! \n${response.statusCode} \n${response.body}');
  }
}

Future<Map<String, dynamic>> myPost(String path, List<Map<String, String>> query, Map<String, dynamic> body) async {
  final url = '$baseUrl$path${query.isNotEmpty ? '?': ''}${query.map((e) => '${e.keys.first}=${e.values.first}').join('&')}';
  // consoleLog('| POST | $url');
  final response = await http.post(
    Uri.parse(url), 
    headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(body),
  );
  if (response.statusCode == 200) {
    final res = jsonDecode(response.body);
    consoleLog('| POST | $path res: $res');
    return jsonDecode(response.body);
  } else {
    consoleLog('| POST | $path error: ${response.statusCode} ${response.body}');
    throw Exception('Failed to load data! \n${response.statusCode} \n${response.body}');
  }
}