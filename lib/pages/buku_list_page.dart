import 'package:flutter/material.dart';
import '../models/buku.dart';
import '../services/api_service.dart';
import 'form_buku_page.dart';

class BukuListPage extends StatefulWidget {
  const BukuListPage({super.key});

  @override
  State<BukuListPage> createState() => _BukuListPageState();
}

class _BukuListPageState extends State<BukuListPage> {
  late Future<List<Buku>> futureBuku;

  @override
  void initState() {
    super.initState();
    futureBuku = ApiService.getBuku();
  }

  void refreshData() {
    setState(() {
      futureBuku = ApiService.getBuku();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Buku"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshData,
          ),
        ],
      ),

      // ✅ SATU FloatingActionButton
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormBukuPage()),
          );
          if (result == true) {
            refreshData();
          }
        },
      ),

      body: FutureBuilder<List<Buku>>(
        future: futureBuku,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Gagal mengambil data buku"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Data buku kosong"));
          }

          final bukuList = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.blue.shade100),
              columns: const [
                DataColumn(label: Text("ID Buku")),
                DataColumn(label: Text("Judul")),
                DataColumn(label: Text("Pengarang")),
                DataColumn(label: Text("Penerbit")),
                DataColumn(label: Text("Aksi")),
              ],
              rows: bukuList.map((buku) {
                return DataRow(cells: [
                  DataCell(Text(buku.idbuku)),
                  DataCell(Text(buku.judul)),
                  DataCell(Text(buku.pengarang)),
                  DataCell(Text(buku.penerbit)),
                  DataCell(Row(
                    children: [
                      // ✏️ EDIT
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FormBukuPage(buku: buku),
                            ),
                          );
                          if (result == true) {
                            refreshData();
                          }
                        },
                      ),

                      // 🗑 DELETE
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Hapus Buku"),
                              content: const Text(
                                  "Apakah Anda yakin ingin menghapus data ini?"),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text("Batal"),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Hapus"),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await ApiService.hapusBuku(buku.idbuku);
                            refreshData();
                          }
                        },
                      ),
                    ],
                  )),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
