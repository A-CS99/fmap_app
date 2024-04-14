import 'dart:convert';
import 'package:http/http.dart' as http;
import 'const.dart';

Future<Map<String, dynamic>> myGet(String path, List<Map<String, String>> query) async {
  final response = await http.get(Uri.parse('$baseUrl$path${query.isNotEmpty ? '?': ''}${query.map((e) => '${e.keys.first}=${e.values.first}').join('&')}'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load data! \n${response.statusCode} \n${response.body}');
  }
}

Future<Map<String, dynamic>> myPost(String path, List<Map<String, String>> query, Map<String, dynamic> body) async {
  final response = await http.post(
    Uri.parse('$baseUrl$path?${query.map((e) => '${e.keys.first}=${e.values.first}').join('&')}'), 
    headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(body),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load data! \n${response.statusCode} \n${response.body}');
  }
}