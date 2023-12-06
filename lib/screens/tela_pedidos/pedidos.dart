import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:itafesta/screens/tela_inicial/home.dart';
import 'package:itafesta/screens/tela_login/login.dart';
import 'package:itafesta/screens/tela_produto/produtos.dart';
import 'package:provider/provider.dart';

class Cliente {
  final int id;
  final String nome;
  final String endereco;

  Cliente({
    required this.id,
    required this.nome,
    required this.endereco,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nome: json['nome'],
      endereco: json['endereco'],
    );
  }
}

class Pedido {
  final int id;
  final String quantidade;
  final String data;
  final String retirada;
  final String valorTotal;
  final Cliente cliente;
  final Fornecedor fornecedor;
  final int produtoId;
  String? produtoNome;

  Pedido(
      {required this.id,
      required this.quantidade,
      required this.data,
      required this.retirada,
      required this.valorTotal,
      required this.cliente,
      required this.produtoId,
      required this.fornecedor,
      this.produtoNome});

  set setProdutoNome(String nome) {
    produtoNome = nome;
  }

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
        id: json['id'],
        quantidade: json['quantidade'],
        data: json['data'],
        retirada: json['retirada'],
        valorTotal: json['valor_total'],
        cliente: Cliente.fromJson(json['cliente']),
        fornecedor: Fornecedor.fromJson(json['fornecedor']),
        produtoId: json['produto_id']);
  }
}

Future<List<Pedido>> fetchPedidos(int clienteId) async {
  try {
    final pedidosResponse = await http.get(
      Uri.parse(
          'https://redes-8ac53ee07f0c.herokuapp.com/api/v1/pedidos?cliente_id[eq]=$clienteId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    final produtosResponse = await http.get(
      Uri.parse('https://redes-8ac53ee07f0c.herokuapp.com/api/v1/produtos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (pedidosResponse.statusCode == 200 &&
        produtosResponse.statusCode == 200) {
      List<Pedido> pedidos = [];

      var produtosJson =
          jsonDecode(produtosResponse.body) as Map<String, dynamic>;
      var produtosData = produtosJson['data'] as List<dynamic>;

      var pedidosJson =
          jsonDecode(pedidosResponse.body) as Map<String, dynamic>;
      var pedidosData = pedidosJson['data'] as List<dynamic>;

      for (var pedido in pedidosData) {
        var instancia = Pedido.fromJson(pedido);

        for (var produto in produtosData) {
          var instanciaProduto = Produto.fromJson(produto);

          if (instancia.produtoId == instanciaProduto.id) {
            instancia.produtoNome = instanciaProduto.nome;
          }
        }

        instancia.produtoNome ??= 'Produto não encontrado';

        pedidos.add(instancia);
      }

      return pedidos;
    }

    return [];
  } catch (e) {
    print(e);
    throw Exception('Falha ao carregar pedidos');
  }
}

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: Future.value(context.watch<ClienteModel>().getCliente.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          // Handle error or absence of clienteId
          return const Scaffold(
            body: Center(
              child: Text('Error fetching clienteId'),
            ),
          );
        } else {
          final clienteId = snapshot.data!;
          return OrderScreenContent(clienteId: clienteId);
        }
      },
    );
  }
}

class OrderScreenContent extends StatefulWidget {
  final int clienteId;

  const OrderScreenContent({super.key, required this.clienteId});

  @override
  State<OrderScreenContent> createState() => _OrderScreenContentState();
}

class _OrderScreenContentState extends State<OrderScreenContent> {
  late Future<List<Pedido>> futurePedidos;

  @override
  void initState() {
    super.initState();
    setState(() {
      futurePedidos = fetchPedidos(widget.clienteId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Meus Pedidos'),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder(
              future: futurePedidos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: SizedBox(
                    height: 40,
                    width: 40,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ));
                }

                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                if (snapshot.hasData) {
                  var pedidos = snapshot.data as List<Pedido>;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: pedidos.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return OrderCard(pedido: pedidos[index]);
                    },
                  );
                }

                return const SizedBox(height: 20.0, width: 20.0, child: null);
              },
            )),
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  // final Fornecedor fornecedor;
  final Pedido pedido;

  const OrderCard({super.key, required this.pedido});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: const Icon(Icons.shopping_bag), // Ícone referente ao produto
        title: Text(widget.pedido.produtoNome!),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.pedido.fornecedor.nome),
            Text(widget.pedido.cliente.endereco),
            Text('Total: R\$${widget.pedido.valorTotal}'),
          ],
        ),
      ),
    );
  }
}
