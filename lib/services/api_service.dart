import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _apiKey = dotenv.env['UNSPLASH_ACCESS_KEY']!;
  int _currentPage = 1;

  Future<List<Map<String, dynamic>>> fetchImages() async {
    final response = await http.get(
      Uri.parse(
        'https://api.unsplash.com/photos?page=$_currentPage&per_page=10&client_id=$_apiKey',
      ),
    );

    // Debug logs
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      _currentPage++;

      return data.map((image) {
        return {
          'urls': image['urls'],
          'alt_description': image['alt_description'],
          'likes': image['likes'],
          'user': {
            'name': image['user']['name'],
            'profile_url': image['user']['links']['html'],
          },
        };
      }).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }

  void resetPage() {
    _currentPage = 1;
  }
}
