// Model data untuk mata kuliah
class Course {
  final String code;
  final String name;
  final String lecturer;
  final int sks;
  final double progress; // progres silabus (0.0 - 1.0)
  final String room;
  final String category; // Tambahan kategori mata kuliah
  final String time; //Tambahan Jam Mata Kuliah

  const Course({
    required this.code,
    required this.name,
    required this.lecturer,
    required this.sks,
    required this.progress,
    this.room = 'Lab Komputer 3',
    required this.category,
    required this.time,
  });

  // Data dummy untuk bahan praktikum & testing
  static List<Course> getSampleCourses() {
    return const [
      Course(
          code: 'TRPL501',
          name: 'Pemrograman Perangkat Bergerak',
          lecturer: 'Sepyan Purnama Kristanto',
          sks: 4,
          progress: 0.25,
          room: 'Lab TUK',
          category: 'Praktikum',
          time: '07.30 - 11.40'),
      Course(
          code: 'TRPL502',
          name: 'Basis Data Lanjut',
          lecturer: 'Dianni Yusuf',
          sks: 3,
          progress: 0.40,
          room: 'Lab TUK',
          category: 'Praktikum',
          time: '12.30 - 16.20'),
      Course(
          code: 'TRPL503',
          name: 'Interoperabilitas',
          lecturer: 'Furiansyah Dipraja',
          sks: 3,
          progress: 0.60,
          room: 'Lab Multimedia',
          category: 'Praktikum',
          time: '12.30 - 16.20'),
      Course(
          code: 'TRPL504',
          name: 'Pemrograman Web Lanjut',
          lecturer: 'Devit Suwardiyanto',
          sks: 2,
          progress: 0.15,
          room: 'Lab Program 2',
          category: 'Praktikum',
          time: '12.30 - 16.20'),
      Course(
          code: 'TRPL505',
          name: 'Statistika',
          lecturer: 'Siska Aprilia Hardiyanti',
          sks: 2,
          progress: 0.15,
          room: 'G2.01',
          category: 'Teori',
          time: '07.30 - 09.10'),
    ];
  }
}
