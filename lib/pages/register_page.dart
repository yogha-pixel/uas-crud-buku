import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();

  bool isLoading = false;
  bool obscure = true;

  Future<void> handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final success =
        await ApiService.register(nameC.text, emailC.text, passC.text);

    setState(() => isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registrasi berhasil, silakan login"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registrasi gagal"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
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
                      Icons.person_add,
                      size: 60,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Buat Akun Baru",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // NAMA
                    TextFormField(
                      controller: nameC,
                      decoration: const InputDecoration(
                        labelText: "Nama",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Nama wajib diisi" : null,
                    ),
                    const SizedBox(height: 15),

                    // EMAIL
                    TextFormField(
                      controller: emailC,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Email wajib diisi" : null,
                    ),
                    const SizedBox(height: 15),

                    // PASSWORD
                    TextFormField(
                      controller: passC,
                      obscureText: obscure,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscure ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() => obscure = !obscure);
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password wajib diisi";
                        } else if (value.length < 6) {
                          return "Password minimal 6 karakter";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),

                    // BUTTON REGISTER
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : handleRegister,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("REGISTER"),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // BACK TO LOGIN
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Sudah punya akun? Login"),
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
