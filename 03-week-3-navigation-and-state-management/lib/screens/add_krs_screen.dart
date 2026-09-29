import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/krs_course.dart';
import '../providers/krs_provider.dart';

class AddKrsScreen extends ConsumerStatefulWidget {
  const AddKrsScreen({super.key});

  @override
  ConsumerState<AddKrsScreen> createState() => _AddKrsScreenState();
}

class _AddKrsScreenState extends ConsumerState<AddKrsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _lecturerController = TextEditingController();
  final _sksController = TextEditingController(text: '3');

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _lecturerController.dispose();
    _sksController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final course = KrsCourse(
      code: _codeController.text.trim().toUpperCase(),
      name: _nameController.text.trim(),
      lecturer: _lecturerController.text.trim(),
      sks: int.tryParse(_sksController.text.trim()) ?? 3,
    );

    // Menyimpan lewat provider, bukan lewat Navigator.pop
    final success = ref.read(krsProvider.notifier).tambahMataKuliah(course);
    if (success) {
      context.pop();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Gagal ditambahkan')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Mata Kuliah KRS'),
      ), // Sesuai text Test 3
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Kode Mata Kuliah'),
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Kode mata kuliah wajib diisi'
                  : null, // Sesuai text Test 3
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Mata Kuliah'),
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Nama mata kuliah wajib diisi'
                  : null, // Sesuai text Test 3
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _simpan,
              child: const Text(
                'Simpan ke Rencana Studi',
              ), // Sesuai text Test 3
            ),
          ],
        ),
      ),
    );
  }
}
