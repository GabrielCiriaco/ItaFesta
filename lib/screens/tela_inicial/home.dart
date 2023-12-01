import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:itafesta/screens/tela_carrinho/carrinho.dart';
import '../tela_produto/produtos.dart';
import 'package:http/http.dart' as http;

abstract class IFornecedor {
  int get id;
  String get tipo;
  String get nome;
  String get descricao;
  String get endereco;
  String get telefone;
}

Future<List<Fornecedor>> fetchFornecedores([tipo]) async {
  var url = '';

  if (tipo != null) {
    url =
        'https://redes-8ac53ee07f0c.herokuapp.com/api/v1/fornecedores?tipo[eq]=$tipo';
  } else {
    url = 'https://redes-8ac53ee07f0c.herokuapp.com/api/v1/fornecedores';
  }

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Se o servidor retornar um status OK, parseie o JSON
    var responseBody = jsonDecode(response.body) as Map<String, dynamic>;

    var data = responseBody['data'] as List<dynamic>;

    return data
        .map((fornecedor) => Fornecedor(
            id: fornecedor['id'],
            tipo: fornecedor['tipo'],
            nome: fornecedor['nome'],
            descricao: fornecedor['descricao'],
            endereco: fornecedor['endereco'],
            telefone: fornecedor['telefone']))
        .toList();
  } else {
    // Se o servidor não retornar um status OK, lança um erro.
    throw Exception('Falha ao carregar os fornecedores');
  }
}

class Fornecedor {
  final int id;
  final String nome;
  final String descricao;
  final String tipo;
  final String endereco;
  final String telefone;

  Fornecedor(
      {required this.id,
      required this.nome,
      required this.tipo,
      required this.descricao,
      required this.endereco,
      required this.telefone});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Fornecedor>> futureFornecedores;

  @override
  void initState() {
    super.initState();
    futureFornecedores = fetchFornecedores();
  }

  IconData getIcon(String tipo) {
    switch (tipo) {
      case 'bolos':
        return Icons.cake_rounded;
      case 'salgados':
        return Icons.bakery_dining_rounded;
      case 'doces':
        return Icons.icecream_rounded;
      case 'bebidas':
        return Icons.wine_bar_rounded;
      default:
        return Icons.store;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Inicio', textAlign: TextAlign.center),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CarrinhoPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            SizedBox(
                height: 70,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Filtra os fornecedores por tipo = bolos
                        setState(() {
                          futureFornecedores = fetchFornecedores();
                        });
                      },
                      child: const Card(
                        child: SizedBox(
                            height: 70,
                            width: 90,
                            child: Center(child: Text('Todos'))),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navegar para a tela de bebidas
                        setState(() {
                          futureFornecedores = fetchFornecedores('bolos');
                        });
                      },
                      child: const Card(
                        child: SizedBox(
                            height: 70,
                            width: 90,
                            child: Center(child: Text('Bolos'))),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navegar para a tela de salgados
                        setState(() {
                          futureFornecedores = fetchFornecedores('salgados');
                        });
                      },
                      child: const Card(
                        child: SizedBox(
                            height: 70,
                            width: 90,
                            child: Center(child: Text('Salgados'))),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navegar para a tela de doces
                        setState(() {
                          futureFornecedores = fetchFornecedores('doces');
                        });
                      },
                      child: const Card(
                        child: SizedBox(
                            height: 70,
                            width: 90,
                            child: Center(child: Text('Doces'))),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navegar para a tela de bebidas
                        setState(() {
                          futureFornecedores = fetchFornecedores('bebidas');
                        });
                      },
                      child: const Card(
                        child: SizedBox(
                            height: 70,
                            width: 90,
                            child: Center(child: Text('Bebidas'))),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 2.0, color: Colors.black),
                      ),
                    ),
                    child: const Text(
                      'Mais Populares',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder<List<Fornecedor>>(
              future: futureFornecedores,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 200.0,
                    width: 200.0,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return const Text('Erro ao carregar os fornecedores');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Nenhum fornecedor disponível');
                } else {
                  return RefreshIndicator(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var fornecedor = snapshot.data![index];
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProdutosPage(fornecedor),
                                  ),
                                );
                              },
                              child: Card(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey,
                                    ),
                                    child: Icon(
                                      getIcon(fornecedor.tipo),
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          fornecedor.nome,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(fornecedor.descricao),
                                      ],
                                    ),
                                  )
                                ]),
                              )));
                        }),
                    onRefresh: () async {
                      setState(() {
                        futureFornecedores = fetchFornecedores();
                      });
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CardWithStore extends StatelessWidget {
  final String storeName;
  final String storeDescription;
  final IconData icon;

  const CardWithStore({
    super.key,
    required this.storeName,
    required this.storeDescription,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: Icon(
                icon,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    storeName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(storeDescription),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
