class KrsCourse {
  const KrsCourse({
    required this.code,
    required this.name,
    required this.lecturer,
    required this.sks,
    this.description = '',
  });

  final String code;
  final String name;
  final String lecturer;
  final int sks;
  final String description;

  // Data dummy
  static List<KrsCourse> getInitialCourses() {
    return const [
      KrsCourse(
        code: 'TRPL501',
        name: 'Pemrograman Perangkat Bergerak',
        lecturer: 'Sepyan Purnama Kristanto, S.Kom., M.Kom.',
        sks: 3,
        description:
            'Mempelajari pembuatan UI dan State Management di Flutter.',
      ),
      KrsCourse(
        code: 'TRPL502',
        name: 'Interoperabilitas',
        lecturer: 'Furiansyah Dipraja, S.T., M.Kom.',
        sks: 3,
      ),
      KrsCourse(
        code: 'TRPL503',
        name: 'Rekayasa Kebutuhan Perangkat Lunak',
        lecturer: 'Eka Mistiko Rini, S.Kom., M.Kom.',
        sks: 3,
      ),
    ];
  }
}
