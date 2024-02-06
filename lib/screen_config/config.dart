// configuracoes_screen.dart

import 'package:flutter/material.dart';

class ConfiguracoesScreen extends StatefulWidget {
  @override
  _ConfiguracoesScreenState createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Carre
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações do Banco de Dados'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade400,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(_hostController, 'Host', 'localhost'),
                _buildTextField(_portController, 'Porta', '3306'),
                _buildTextField(_userController, 'Usuário', 'root'),
                _buildTextField(_passController, 'Senha', 'password',
                    isPassword: true),
                _buildTextField(
                    _nameController, 'Nome do Banco de Dados', 'db_name'),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {},
                  child: const Text('Salvar Configurações'),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey.shade800,
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String defaultValue,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          hintText: defaultValue,
        ),
      ),
    );
  }
}
