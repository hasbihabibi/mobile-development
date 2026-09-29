class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.category,
    required this.date,
    required this.readCount,
  });

  final int id;
  final String title;
  final String content;
  final String author;
  final String category;
  final String date;
  final int readCount;

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] as String? ?? 'Tanpa Judul',
      content: json['content'] as String? ?? json['body'] as String? ?? '',
      author: json['author'] as String? ?? 'Admin Jurusan',
      category: json['category'] as String? ?? 'Akademik',
      date: json['date'] as String? ?? '2026-09-01',
      readCount: json['readCount'] is int ? json['readCount'] as int : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author,
      'category': category,
      'date': date,
      'readCount': readCount,
    };
  }

  static List<Announcement> getSampleAnnouncements() {
    return const [
      Announcement(
        id: 101,
        title: 'Uji Coba Pengumuman',
        content: 'Ini adalah isi pengumuman uji coba.',
        author: 'Dosen Penguji',
        category: 'Akademik',
        date: '2026-09-03',
        readCount: 42,
      ),
      Announcement(
        id: 102,
        title: 'Pengumuman Beasiswa',
        content: 'Beasiswa dibuka.',
        author: 'Admin',
        category: 'Beasiswa',
        date: '2026-09-04',
        readCount: 10,
      ),
      Announcement(
        id: 103,
        title: 'Lomba Gemastik',
        content: 'Segera daftar.',
        author: 'Admin',
        category: 'Prestasi',
        date: '2026-09-05',
        readCount: 5,
      ),
      Announcement(
        id: 104,
        title: 'Kegiatan BEM',
        content: 'Rapat rutin bulanan.',
        author: 'Admin',
        category: 'Kegiatan',
        date: '2026-09-06',
        readCount: 20,
      ),
    ];
  }
}
