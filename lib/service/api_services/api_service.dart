import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  Future<void> fetch() async {
    final url =
        Uri.parse('https://mock.apidog.com/m1/561191-524377-default/Event');
    const token = "2f68dbbf-519d-4f01-9636-e2421b68f379";
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
//
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('eventData', json.encode(data));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
