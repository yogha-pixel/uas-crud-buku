import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
                controller: nameC,
                decoration: const InputDecoration(labelText: "Nama")),
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
                await ApiService.register(nameC.text, emailC.text, passC.text);
                Navigator.pop(context);
              },
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
