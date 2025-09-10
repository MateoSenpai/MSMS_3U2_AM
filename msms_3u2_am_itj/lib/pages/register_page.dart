import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import '../models/user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final DBHelper _dbHelper = DBHelper();

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      final existingUser = await _dbHelper.getUserByEmail(email);
      if (existingUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("El correo ya está registrado")),
        );
        return;
      }

      User user = User(name: name, email: email, password: password);
      await _dbHelper.insertUser(user);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registro exitoso")),
      );

      Navigator.pop(context); // Vuelve al login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingrese un nombre";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Correo"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingrese un correo";
                  }
                  return null; // ✅ Solo que no esté vacío
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
                  if (value.length < 4) {
                    return "Mínimo 4 caracteres";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _registerUser,
                child: const Text("Registrarse"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
