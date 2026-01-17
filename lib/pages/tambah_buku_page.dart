import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TambahBukuPage extends StatefulWidget {
  const TambahBukuPage({super.key});

  @override
  State<TambahBukuPage> createState() => _TambahBukuPageState();
}

class _TambahBukuPageState extends State<TambahBukuPage> {
  final _formKey = GlobalKey<FormState>();

  final idC = TextEditingController();
  final judulC = TextEditingController();
  final pengarangC = TextEditingController();
  final penerbitC = TextEditingController();

  bool isLoading = false;

  Future<void> simpanBuku() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await ApiService.tambahBuku(
        idC.text,
        judulC.text,
        pengarangC.text,
        penerbitC.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Buku berhasil ditambahkan"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menambah buku: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    idC.dispose();
    judulC.dispose();
    pengarangC.dispose();
    penerbitC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text("Tambah Buku"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.library_add,
                      size: 60,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 15),

                    // ID BUKU
                    TextFormField(
                      controller: idC,
                      decoration: const InputDecoration(
                        labelText: "ID Buku",
                        prefixIcon: Icon(Icons.numbers),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "ID Buku wajib diisi" : null,
                    ),
                    const SizedBox(height: 15),

                    // JUDUL
                    TextFormField(
                      controller: judulC,
                      decoration: const InputDecoration(
                        labelText: "Judul Buku",
                        prefixIcon: Icon(Icons.book),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Judul wajib diisi" : null,
                    ),
                    const SizedBox(height: 15),

                    // PENGARANG
                    TextFormField(
                      controller: pengarangC,
                      decoration: const InputDecoration(
                        labelText: "Pengarang",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Pengarang wajib diisi" : null,
                    ),
                    const SizedBox(height: 15),

                    // PENERBIT
                    TextFormField(
                      controller: penerbitC,
                      decoration: const InputDecoration(
                        labelText: "Penerbit",
                        prefixIcon: Icon(Icons.business),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Penerbit wajib diisi" : null,
                    ),
                    const SizedBox(height: 25),

                    // BUTTON SIMPAN
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : simpanBuku,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("SIMPAN"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
