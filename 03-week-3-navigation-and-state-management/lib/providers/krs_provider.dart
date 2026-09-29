import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/krs_course.dart';

class KrsNotifier extends Notifier<List<KrsCourse>> {
  @override
  List<KrsCourse> build() => KrsCourse.getInitialCourses();

  bool tambahMataKuliah(KrsCourse course) {
    final exists = state.any(
      (c) => c.code.toUpperCase() == course.code.toUpperCase(),
    );
    if (exists) return false;

    if (totalSks + course.sks > 24) return false;

    // State baru dibuat (immutable), bukan diubah di tempat
    state = [...state, course];
    return true;
  }

  void hapusMataKuliah(String code) {
    state = state.where((c) => c.code != code).toList();
  }

  int get totalSks => state.fold(0, (sum, c) => sum + c.sks);
}

final krsProvider = NotifierProvider<KrsNotifier, List<KrsCourse>>(
  KrsNotifier.new,
);
