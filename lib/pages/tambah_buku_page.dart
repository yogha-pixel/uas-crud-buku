import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TambahBukuPage extends StatelessWidget {
  const TambahBukuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final idC = TextEditingController();
    final judulC = TextEditingController();
    final pengarangC = TextEditingController();
    final penerbitC = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Buku")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
                controller: idC,
                decoration: const InputDecoration(labelText: "ID Buku")),
            TextField(
                controller: judulC,
                decoration: const InputDecoration(labelText: "Judul")),
            TextField(
                controller: pengarangC,
                decoration: const InputDecoration(labelText: "Pengarang")),
            TextField(
                controller: penerbitC,
                decoration: const InputDecoration(labelText: "Penerbit")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await ApiService.tambahBuku(
                  idC.text,
                  judulC.text,
                  pengarangC.text,
                  penerbitC.text,
                );
                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
