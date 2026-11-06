
import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/post_service.dart';

class DetailScreen extends StatefulWidget {
  final Post post;

  const DetailScreen({
    super.key,
    required this.post,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final PostService service = PostService();

  late Future<List<dynamic>> futureComments;

  @override
  void initState() {
    super.initState();
    futureComments = service.getComments(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengumuman'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'PENGUMUMAN #${post.id}',
            style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            post.title,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            post.body,
            style: const TextStyle(fontSize: 16, height: 1.6),
          ),
          const SizedBox(height: 12),
          Text(
            'Penulis: User ${post.userId}',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const Divider(height: 40),
          const Text(
            'Komentar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          FutureBuilder<List<dynamic>>(
            future: futureComments,
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return const Text(
                  'Gagal memuat komentar. Periksa koneksi internet.',
                );
              }

              final comments = snapshot.data ?? [];

              if (comments.isEmpty) {
                return const Text('Belum ada komentar.');
              }

              return Column(
                children: comments.map((comment) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(comment['name'] ?? ''),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comment['email'] ?? ''),
                          const SizedBox(height: 8),
                          Text(comment['body'] ?? ''),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
