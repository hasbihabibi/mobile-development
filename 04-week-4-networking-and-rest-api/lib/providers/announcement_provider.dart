import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/announcement.dart';
import '../repositories/announcement_repository.dart';
import '../repositories/sample_announcement_repository.dart';

// Provider untuk Repository
final announcementRepositoryProvider = Provider<AnnouncementRepository>((ref) {
  return SampleAnnouncementRepository();
});

// Provider untuk Kategori Terpilih
class SelectedCategory extends Notifier<String> {
  @override
  String build() => 'Semua';

  void select(String value) => state = value;
}

final selectedCategoryProvider = NotifierProvider<SelectedCategory, String>(
  SelectedCategory.new,
);

// Provider untuk List Pengumuman (Otomatis bereaksi jika kategori berubah)
final announcementsProvider = FutureProvider<List<Announcement>>((ref) async {
  final repository = ref.watch(announcementRepositoryProvider);
  final category = ref.watch(selectedCategoryProvider);
  return repository.getAnnouncements(category: category);
});
