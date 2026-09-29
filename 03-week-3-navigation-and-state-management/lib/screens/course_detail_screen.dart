import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/krs_provider.dart';

class CourseDetailScreen extends ConsumerStatefulWidget {
  final String courseCode;
  const CourseDetailScreen({super.key, required this.courseCode});

  @override
  ConsumerState<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends ConsumerState<CourseDetailScreen> {
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    if (isError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Gagal Mengambil Data Silabus'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => setState(() => isError = false),
                child: const Text('Coba Lagi (Retry)'),
              ),
            ],
          ),
        ),
      );
    }

    final course = ref
        .watch(krsProvider)
        .firstWhere(
          (c) => c.code == widget.courseCode,
          orElse: () => throw Exception('Mata kuliah tidak ditemukan'),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(course.code),
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () => setState(() => isError = true),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              '${course.sks} SKS',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              course.lecturer,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
