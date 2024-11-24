import 'dart:async';
import 'dart:io';
// Model Data
class Produk {
  String namaProduk;
  double harga;
  bool tersedia;
  Produk(this.namaProduk, this.harga, this.tersedia);
}
class Pengguna {
  String nama;
  int umur;
  late List<Produk>? daftarProduk;
  Peran? peran;
  Pengguna(this.nama, this.umur, {this.daftarProduk, this.peran});
}
enum Peran { Admin, Pelanggan }
class AdminPengguna extends Pengguna {
  AdminPengguna(String nama, int umur) : super(nama, umur, peran: Peran.Admin);
  void tambahProduk(Produk produk, Map<String, Produk> petaProduk, Set<String> namaProdukSet) {
    if (produk.tersedia) {
      if (!namaProdukSet.contains(produk.namaProduk)) {
        daftarProduk ??= [];
        daftarProduk!.add(produk);
        petaProduk[produk.namaProduk] = produk;
        namaProdukSet.add(produk.namaProduk);
        print("${produk.namaProduk} telah ditambahkan ke daftar produk.");
      } else {
        print("${produk.namaProduk} sudah ada dalam daftar produk.");
      }
    } else {
      throw Exception("${produk.namaProduk} tidak tersedia dalam stok.");
    }
  }
  void hapusProduk(String namaProduk) {
    daftarProduk ??= [];
    daftarProduk!.removeWhere((produk) => produk.namaProduk == namaProduk);
    print("$namaProduk telah dihapus dari daftar produk.");
  }
}
class PelangganPengguna extends Pengguna {
  PelangganPengguna(String nama, int umur) : super(nama, umur, peran: Peran.Pelanggan);
  void lihatProduk() {
    if (daftarProduk == null || daftarProduk!.isEmpty) {
      print("Daftar produk kosong.");
    } else {
      print("Daftar produk:");
      for (var produk in daftarProduk!) {
        print("- ${produk.namaProduk} (Harga: ${produk.harga})");
      }
    }
  }
}
void tambahProdukKePengguna(AdminPengguna admin, Produk produk, Map<String, Produk> petaProduk, Set<String> namaProdukSet) {
  try {
    admin.tambahProduk(produk, petaProduk, namaProdukSet);
  } on Exception catch (e) {
    print("Kesalahan: ${e.toString()}");
  }
}
Future<void> ambilDetailProduk(Produk produk) async {
  print("Mengambil detail produk ${produk.namaProduk}...");
  await Future.delayed(Duration(seconds: 2));
  print("Detail produk ${produk.namaProduk}: Harga - ${produk.harga}, Tersedia - ${produk.tersedia}");
}
void main() {
  var admin = AdminPengguna("Admin1", 30);
  var pelanggan = PelangganPengguna("Pelanggan1", 25);
  Map<String, Produk> petaProduk = {};
  Set<String> namaProdukSet = {};
  while (true) {
    print("\nMenu:");
    print("1. Tambah Produk");
    print("2. Hapus Produk");
    print("3. Lihat Produk");
    print("4. Keluar");
    stdout.write("Pilih opsi: ");
    var pilihan = stdin.readLineSync();
    switch (pilihan) {
      case '1':
        stdout.write("Masukkan nama produk: ");
        var namaProduk = stdin.readLineSync();
        stdout.write("Masukkan harga produk: ");
        var hargaProduk = double.tryParse(stdin.readLineSync() ?? "0") ?? 0;
        stdout.write("Apakah produk tersedia? (y/n): ");
        var tersediaInput = stdin.readLineSync();
        bool tersedia = tersediaInput?.toLowerCase() == 'y';
        if (namaProduk != null && namaProduk.isNotEmpty) {
          var produk = Produk(namaProduk, hargaProduk, tersedia);
          tambahProdukKePengguna(admin, produk, petaProduk, namaProdukSet);
        } else {
          print("Nama produk tidak boleh kosong.");
        }
        break;
      case '2':
        stdout.write("Masukkan nama produk yang ingin dihapus: ");
        var namaProdukHapus = stdin.readLineSync();
        if (namaProdukHapus != null && namaProdukHapus.isNotEmpty) {
          admin.hapusProduk(namaProdukHapus);
          namaProdukSet.remove(namaProdukHapus);
          petaProduk.remove(namaProdukHapus);
        } else {
          print("Nama produk tidak boleh kosong.");
        }
        break;
      case '3':
        pelanggan.daftarProduk = admin.daftarProduk;
        pelanggan.lihatProduk();
        break;
      case '4':
        print("Keluar dari program.");
        return;
      default:
        print("Pilihan tidak valid. Coba lagi.");
    }
  }
}