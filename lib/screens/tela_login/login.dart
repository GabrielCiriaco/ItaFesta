import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:itafesta/screens/tela_registro/registro.dart';
import 'package:provider/provider.dart';
import '../tela_inicial/home.dart';

import 'package:http/http.dart' as http;

class Cliente {
  final int? id;
  final String nome;
  final String email;
  final String senha;
  final String endereco;
  final String telefone;
  final String? cpf;

  Cliente(
      {this.id,
      required this.nome,
      required this.email,
      required this.senha,
      required this.endereco,
      required this.telefone,
      this.cpf});

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      senha: json['senha'],
      endereco: json['endereco'],
      telefone: json['telefone'],
      // cpf: json['cpf'],
    );
  }
}

class ClienteModel extends ChangeNotifier {
  Cliente cliente = Cliente(
      nome: '', email: '', senha: '', endereco: '', telefone: '', cpf: '');

  Cliente get getCliente => cliente;

  void updateCliente(Cliente novoCliente) {
    cliente = novoCliente;
    notifyListeners();
  }

  void clearCliente() {
    cliente = Cliente(
        nome: '', email: '', senha: '', endereco: '', telefone: '', cpf: '');
    notifyListeners();
  }
}

Future<Cliente> attemptLogin(String email) async {
  var response = await http.get(Uri.parse(
      'https://redes-8ac53ee07f0c.herokuapp.com/api/v1/clientes?email[eq]=$email'));

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body) as Map<String, dynamic>;

    if (json['data'].isEmpty) {
      return Cliente(
          nome: '', email: '', senha: '', endereco: '', telefone: '', cpf: '');
    }

    var cliente = json['data'][0];

    return Cliente.fromJson(cliente);
  } else {
    throw Exception('Falha ao registrar o usuário.');
  }
}

class Login extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final loading = ValueNotifier<bool>(false);

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 100),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Image(
                image: AssetImage('lib/assets/logo.png'),
                height: 250,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                // Salvar o valor do campo login
                // Você pode usar um controller ou um onChanged para armazenar o valor
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true, // Para ocultar a senha
                // Salvar o valor do campo senha
                // Você pode usar um controller ou um onChanged para armazenar o valor
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RegistroPage()));
                },
                child: const Text('Registrar'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 92, 196, 212),
                ),
                onPressed: () async {
                  String enteredEmail = emailController.text;
                  String enteredPassword = passwordController.text;

                  loading.value = true;

                  var cliente = await attemptLogin(enteredEmail);

                  loading.value = false;

                  if (cliente.email != '' && enteredPassword == cliente.senha) {
                    if (!context.mounted) return;
                    Provider.of<ClienteModel>(context, listen: false)
                        .updateCliente(cliente);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } else {
                    if (!context.mounted) return;
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Erro de Login'),
                        content: const Text(
                            'Credenciais inválidas. Tente novamente.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
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
                        : const Text('Entrar');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
