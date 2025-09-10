import 'package:flutter/material.dart';
import '../models/user.dart';

class HomePage extends StatelessWidget {
  final User user;
  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inicio")),
      body: Center(
        child: Text(
          "Bienvenido, ${user.name} 👋",
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
