import 'package:flutter/material.dart';
import '../models/buku.dart';
import '../services/api_service.dart';
import 'form_buku_page.dart';
import 'login_page.dart';

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

  Future<void> logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Apakah Anda yakin ingin logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ApiService.logout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // ================= APP BAR =================
      appBar: AppBar(
        title: const Text("📚 Daftar Buku"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Refresh",
            onPressed: refreshData,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: logout,
          ),
        ],
      ),

      // ================= TAMBAH BUKU =================
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Tambah Buku"),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormBukuPage()),
          );
          if (result == true) refreshData();
        },
      ),

      // ================= LIST DATA =================
      body: FutureBuilder<List<Buku>>(
        future: futureBuku,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("❌ Gagal mengambil data buku"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("📭 Data buku masih kosong"));
          }

          final bukuList = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: bukuList.length,
            itemBuilder: (context, index) {
              final buku = bukuList[index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ================= JUDUL =================
                      Text(
                        buku.judul,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ================= INFO =================
                      Row(
                        children: [
                          const Icon(Icons.person, size: 16),
                          const SizedBox(width: 6),
                          Text(buku.pengarang),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.business, size: 16),
                          const SizedBox(width: 6),
                          Text(buku.penerbit),
                        ],
                      ),

                      const Divider(height: 24),

                      // ================= AKSI =================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Chip(
                            label: Text("ID: ${buku.idbuku}"),
                            backgroundColor: Colors.blue.shade100,
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.orange),
                                tooltip: "Edit",
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FormBukuPage(buku: buku),
                                    ),
                                  );
                                  if (result == true) refreshData();
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                tooltip: "Hapus",
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text("Hapus Buku"),
                                      content: const Text(
                                          "Yakin ingin menghapus buku ini?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text("Batal"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
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
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
