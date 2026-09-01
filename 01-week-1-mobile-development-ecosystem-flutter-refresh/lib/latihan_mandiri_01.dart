// Soal 1: Implementasikan fungsi ini
double hitungLuasPersegiPanjang(double panjang, double lebar) {
  return panjang * lebar;
}

// Soal 2: Implementasikan class ini
class Profil {
  String nim;
  String nama;
  String? emailKampus;

  Profil({required this.nim, required this.nama, this.emailKampus});

  void tampilkanInfo() {
    String email = emailKampus ?? '(belum ada email)';
    print('[$nim] $nama | Email: $email');
  }
}

void main() {
  // Soal 1: Panggil hitungLuasPersegiPanjang
  double luas = hitungLuasPersegiPanjang(6, 7);
  print('Luas: ${luas.toStringAsFixed(2)} cm²');

  //Soal 2: Buat data Profil dan memanggil tampilkanInfo
  Profil mhs1 = Profil(
    nim: '362558302135',
    nama: 'Muh. Hasbiallah Habibi',
    emailKampus: 'hasbihabibi90@poliwangi.ac.id',
  );

  Profil mhs2 = Profil(nim: '362558302000', nama: 'Windah Basudara');

  mhs1.tampilkanInfo();
  mhs2.tampilkanInfo();
}
