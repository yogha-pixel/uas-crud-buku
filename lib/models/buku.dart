class Buku {
  final String idbuku;
  final String judul;
  final String pengarang;
  final String penerbit;

  Buku({
    required this.idbuku,
    required this.judul,
    required this.pengarang,
    required this.penerbit,
  });

  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(
      idbuku: json['idbuku'].toString(),
      judul: json['judul'],
      pengarang: json['pengarang'],
      penerbit: json['penerbit'],
    );
  }
}
