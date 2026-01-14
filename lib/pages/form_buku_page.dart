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
        // ➕ TAMBAH BUKU
        await ApiService.tambahBuku(
          idC.text,
          judulC.text,
          pengarangC.text,
          penerbitC.text,
        );
      } else {
        // ✏️ UPDATE BUKU
        await ApiService.updateBuku(
          widget.buku!.idbuku,
          judulC.text,
          pengarangC.text,
          penerbitC.text,
        );
      }

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
      appBar: AppBar(
        title: Text(isEdit ? "Edit Buku" : "Tambah Buku"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // ID BUKU
              TextFormField(
                controller: idC,
                enabled: !isEdit,
                decoration: const InputDecoration(
                  labelText: "ID Buku",
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
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Penerbit wajib diisi" : null,
              ),
              const SizedBox(height: 25),

              // TOMBOL SIMPAN / UPDATE
              ElevatedButton(
                onPressed: isLoading ? null : simpanData,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isEdit ? "Update" : "Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
