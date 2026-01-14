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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
                controller: emailC,
                decoration: const InputDecoration(labelText: "Email")),
            TextField(
                controller: passC,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool success = await ApiService.login(emailC.text, passC.text);
                if (success) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const BukuListPage()));
                }
              },
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()));
              },
              child: const Text("Register"),
            )
          ],
        ),
      ),
    );
  }
}
