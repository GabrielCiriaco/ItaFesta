import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:itafesta/screens/tela_inicial/home.dart';
import 'package:itafesta/screens/tela_login/login.dart';
import 'package:itafesta/screens/tela_produto/produtos.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<void> finalizaCompra(
    BuildContext context, List<CartItem> items, int clienteId) async {
  var ordersToSave = [];

  var now = DateTime.now();
  String formattedDate = DateFormat('dd/MM/yyyy').format(now);

  for (var item in items) {
    ordersToSave.add({
      'data': formattedDate,
      'quantidade': item.quantity,
      'status': 'pedido',
      'valor_total': item.product['valor'] * item.quantity,
      'retirada': 'false',
      'cliente_id': 1,
      'produto_id': item.product['id'],
      'fornecedor_id': item.product['fornecedorId'],
    });
  }

  var futures = <Future>[];

  for (var order in ordersToSave) {
    futures.add(http.post(
      Uri.parse('https://redes-8ac53ee07f0c.herokuapp.com/api/v1/pedidos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(order),
    ));
  }

  try {
    await Future.wait(futures, eagerError: true);
  } catch (e) {
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro ao finalizar compra!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o alerta
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
    return;
  }

  if (!context.mounted) return;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Compra realizada com sucesso!'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Fecha o alerta
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

class CarrinhoPage extends StatelessWidget {
  const CarrinhoPage({super.key});

  Map<String, dynamic> getProductsFromCart(CartModel cart) {
    List<Produto> produtos = [];
    double total = 0;

    for (var item in cart.items) {
      var produto = Produto(
        id: item.product['id'],
        nome: item.product['nome'],
        valor: item.product['valor'],
        descricao: item.product['descricao'],
        disponivel: item.product['disponivel'],
        quantidade: item.quantity,
        fornecedorId: item.product['fornecedorId'],
      );
      produtos.add(produto);
      total += double.parse(produto.valor) * produto.quantidade;
    }
    return {
      'produtos': produtos,
      'total': total.toStringAsFixed(2),
    };
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();
    final cliente = context.watch<ClienteModel>().getCliente;
    final data = getProductsFromCart(cart);

    final produtosNoCarrinho = data['produtos'];
    final total = data['total'];

    final loading = ValueNotifier(false);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Carrinho'),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: produtosNoCarrinho.length,
          itemBuilder: (context, index) {
            // Aqui, "produtosNoCarrinho" seria a lista de produtos no carrinho
            Produto produto = produtosNoCarrinho[index];
            return Card(
              child: ListTile(
                leading: const CircleAvatar(
                  radius: 30,
                  // Imagem do produto
                  // backgroundImage: AssetImage(produto.imagem),
                ),
                title: Text(produto.nome),
                subtitle: Text(
                    'Valor: R\$ ${produto.valor}\nQuantidade: ${produto.quantidade}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    cart.removeItem(cart.items[index]);
                  },
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: R\$ $total',
                  style: const TextStyle(fontSize: 18),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 92, 196, 212),
                    // padding: const EdgeInsets.all(15),
                  ),
                  onPressed: () async {
                    loading.value = true;
                    await finalizaCompra(context, cart.items, cliente.id!);
                    loading.value = false;
                    cart.clearCart();
                  },
                  child: AnimatedBuilder(
                    animation: loading,
                    builder: (context, child) {
                      return loading.value
                          ? const SizedBox(
                              height: 20,
                              width: 106,
                              child: Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ))
                          : const Text('Finalizar compra',
                              style: TextStyle(color: Colors.white));
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _showCompraRealizada(BuildContext context) {
    // Mostrar a notificação de compra realizada com sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Compra realizada com sucesso!'),
      ),
    );
  }
}
