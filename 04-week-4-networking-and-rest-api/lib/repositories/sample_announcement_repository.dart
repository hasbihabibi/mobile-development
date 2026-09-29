import '../models/announcement.dart';
import 'announcement_repository.dart';

class SampleAnnouncementRepository implements AnnouncementRepository {
  // Menggunakan List.of untuk menghindari error "unmodifiable list"
  final List<Announcement> _items = List<Announcement>.of(
    Announcement.getSampleAnnouncements(),
  );

  @override
  Future<List<Announcement>> getAnnouncements({String? category}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (category == null || category == 'Semua') {
      return _items;
    }
    return _items
        .where((a) => a.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  @override
  Future<Announcement> addAnnouncement(Announcement announcement) async {
    _items.add(announcement);
    return announcement;
  }
}
