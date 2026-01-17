import 'package:flutter/material.dart';
import 'register_page.dart';
import 'buku_list_page.dart';
import '../services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool obscure = true;

  Future<void> handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final success = await ApiService.login(emailC.text, passC.text);

    setState(() => isLoading = false);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BukuListPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login gagal! Email atau password salah"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                      Icons.book,
                      size: 60,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Aplikasi Buku",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

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
                      validator: (value) =>
                          value!.isEmpty ? "Password wajib diisi" : null,
                    ),
                    const SizedBox(height: 25),

                    // BUTTON LOGIN
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : handleLogin,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("LOGIN"),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // REGISTER LINK
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Belum punya akun? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
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
