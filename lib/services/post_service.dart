
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostService {
  static const String baseUrl =
      'https://jsonplaceholder.typicode.com';

  // Mengambil seluruh pengumuman
  Future<List<Post>> getPosts() async {
    final url = Uri.parse('$baseUrl/posts');

    final response = await http.get(url)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data
          .map((item) => Post.fromJson(item))
          .toList();
    } else {
      throw Exception(
        'Gagal mengambil pengumuman: ${response.statusCode}',
      );
    }
  }

  // Mengambil detail pengumuman
  Future<Post> getPostDetail(int id) async {
    final url = Uri.parse('$baseUrl/posts/$id');

    final response = await http.get(url)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Gagal mengambil detail: ${response.statusCode}',
      );
    }
  }

  // Mengambil komentar
  Future<List<dynamic>> getComments(int id) async {
    final url = Uri.parse('$baseUrl/posts/$id/comments');

    final response = await http.get(url)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception(
        'Gagal mengambil komentar: ${response.statusCode}',
      );
    }
  }

  // Mengirim pengumuman baru
  Future<Post> addPost({
    required String title,
    required String body,
  }) async {
    final url = Uri.parse('$baseUrl/posts');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'title': title,
        'body': body,
        'userId': 1,
      }),
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Gagal membuat pengumuman: ${response.statusCode}',
      );
    }
  }
}
