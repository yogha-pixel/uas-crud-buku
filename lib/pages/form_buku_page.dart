import 'package:flutter/material.dart';
import '../models/buku.dart';
import '../services/api_service.dart';

class FormBukuPage extends StatefulWidget {
  final Buku? buku;

  const FormBukuPage({super.key, this.buku});

  @override
  State<FormBukuPage> createState() => _FormBukuPageState();
}

class _FormBukuPageState extends State<FormBukuPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController idC;
  late TextEditingController judulC;
  late TextEditingController pengarangC;
  late TextEditingController penerbitC;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    idC = TextEditingController(text: widget.buku?.idbuku ?? "");
    judulC = TextEditingController(text: widget.buku?.judul ?? "");
    pengarangC = TextEditingController(text: widget.buku?.pengarang ?? "");
    penerbitC = TextEditingController(text: widget.buku?.penerbit ?? "");
  }

  @override
  void dispose() {
    idC.dispose();
    judulC.dispose();
    pengarangC.dispose();
    penerbitC.dispose();
    super.dispose();
  }

  Future<void> simpanData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      if (widget.buku == null) {
        await ApiService.tambahBuku(
          idC.text,
          judulC.text,
          pengarangC.text,
          penerbitC.text,
        );
      } else {
        await ApiService.updateBuku(
          widget.buku!.idbuku,
          judulC.text,
          pengarangC.text,
          penerbitC.text,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.buku == null
                ? "Buku berhasil ditambahkan"
                : "Buku berhasil diperbarui",
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menyimpan data: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.buku != null;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(isEdit ? "Edit Buku" : "Tambah Buku"),
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
                    Icon(
                      isEdit ? Icons.edit : Icons.library_add,
                      size: 60,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 15),

                    // ID BUKU
                    TextFormField(
                      controller: idC,
                      enabled: !isEdit,
                      decoration: const InputDecoration(
                        labelText: "ID Buku",
                        prefixIcon: Icon(Icons.numbers),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "ID buku wajib diisi" : null,
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

                    // BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : simpanData,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(isEdit ? "UPDATE" : "SIMPAN"),
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
