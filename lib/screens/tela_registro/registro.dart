import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itafesta/screens/tela_login/login.dart';

class RegistroPage extends StatelessWidget {
  const RegistroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Adicionar', textAlign: TextAlign.center),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); // Retorna para a tela anterior
            },
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: RegistroClienteForm(),
        ),
      ),
    );
  }
}

Future<void> registrarCliente(BuildContext context, Cliente cliente) async {
  var response = await http.post(
    Uri.parse('https://redes-8ac53ee07f0c.herokuapp.com/api/v1/clientes'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "nome": cliente.nome,
      "email": cliente.email,
      "senha": cliente.senha,
      "endereco": cliente.endereco,
      "telefone": cliente.telefone,
      "cpf": cliente.cpf
    }),
  );

  if (response.statusCode == 201) {
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Usuário cadastrado com sucesso!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o alerta
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Login()));
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  } else {
    print(response.statusCode);
  }
}

class RegistroClienteForm extends StatefulWidget {
  const RegistroClienteForm({Key? key}) : super(key: key);

  @override
  State<RegistroClienteForm> createState() => _RegistroClienteFormState();
}

class _RegistroClienteFormState extends State<RegistroClienteForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();

  final loading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Nome'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _senhaController,
          decoration: const InputDecoration(labelText: 'Senha'),
          obscureText: true,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _enderecoController,
          decoration: const InputDecoration(labelText: 'Endereço'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _telefoneController,
          decoration: const InputDecoration(labelText: 'Telefone'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _cpfController,
          decoration: const InputDecoration(labelText: 'CPF'),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () async {
            if (_senhaController.text.isEmpty ||
                _emailController.text.isEmpty ||
                _nameController.text.isEmpty ||
                _enderecoController.text.isEmpty ||
                _telefoneController.text.isEmpty ||
                _cpfController.text.isEmpty) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Preencha todos os campos!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Fecha o alerta
                      },
                      child: const Text('Ok'),
                    ),
                  ],
                ),
              );
              return;
            }

            loading.value = true;
            var cliente = Cliente(
                nome: _nameController.text,
                email: _emailController.text,
                senha: _senhaController.text,
                endereco: _enderecoController.text,
                telefone: _telefoneController.text,
                cpf: _cpfController.text);

            registrarCliente(context, cliente).then((value) => {
                  loading.value = false,
                });
          },
          child: AnimatedBuilder(
            animation: loading,
            builder: (context, child) {
              return loading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    )
                  : const Text('Cadastrar');
            },
          ),
        )
      ],
    ));
  }
}
