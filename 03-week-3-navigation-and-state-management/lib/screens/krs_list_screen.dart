import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/krs_provider.dart';
import '../widgets/krs_course_tile.dart';

// Ubah menjadi ConsumerWidget agar bisa membaca Provider
class KrsListScreen extends ConsumerWidget {
  const KrsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pantau perubahan data
    final courses = ref.watch(krsProvider);
    final totalSks = ref.read(krsProvider.notifier).totalSks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rencana Studi (KRS) TRPL'), // Sesuai text di Test 2
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '$totalSks / 24 SKS',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return KrsCourseTile(
            course: course,
            onTap: () => context.push(
              '/modul-03/detail/${course.code}',
            ), // Navigasi GoRouter
            onDelete: () =>
                ref.read(krsProvider.notifier).hapusMataKuliah(course.code),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/modul-03/add'), // Navigasi GoRouter
        child: const Icon(Icons.add),
      ),
    );
  }
}
