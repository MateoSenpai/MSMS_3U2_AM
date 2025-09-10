import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final DBHelper _dbHelper = DBHelper();

  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      final user = await _dbHelper.validateLogin(email, password);

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(user: user),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Correo o contraseña incorrectos")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Correo"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingrese un correo";
                  }
                  return null; // ✅ No valida formato
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Contraseña"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingrese una contraseña";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loginUser,
                child: const Text("Iniciar Sesión"),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()),
                  );
                },
                child: const Text("¿No tienes cuenta? Regístrate aquí"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
