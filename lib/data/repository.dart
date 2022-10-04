import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

abstract class RepositoryApi {
  Future<List<Img>> fetchImages(Uri uri);
}

class RepositoryImp implements RepositoryApi {
  @override
  Future<List<Img>> fetchImages(Uri uri) async {
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body)['story']['content']['img'];
        return parsed.map<Img>((json) => Img.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      rethrow;
    }
  }
}
