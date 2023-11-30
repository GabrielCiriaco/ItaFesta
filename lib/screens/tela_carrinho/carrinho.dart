import 'package:flutter/material.dart';
import 'package:itafesta/screens/tela_produto/produtos.dart';
import 'package:provider/provider.dart';

class CarrinhoPage extends StatelessWidget {
  const CarrinhoPage({super.key});

  List<Produto> getProductsFromCart(CartModel cart) {
    List<Produto> produtos = [];
    for (var item in cart.items) {
      var produto = Produto(item.product['nome'], item.product['valor']);
      produtos.add(produto);
    }
    return produtos;
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();
    final produtosNoCarrinho = getProductsFromCart(cart);

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
              leading: CircleAvatar(
                radius: 30,
                // Imagem do produto
                // backgroundImage: AssetImage(produto.imagem),
              ),
              title: Text(produto.nome),
              subtitle: Text('R\$ ${produto.valor}'),
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
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              // Lógica para finalizar a compra
              // Disparar a notificação de compra realizada com sucesso
              _showCompraRealizada(context);
              // Redirecionar para a home
              Navigator.pop(context);
            },
            child: const Text('Finalizar Compra'),
          ),
        ),
      ),
    );
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

class Produto {
  final String nome;
  final String valor;
  // final String imagem;

  Produto(this.nome, this.valor);
}

// Exemplo de lista de produtos no carrinho
// List<Produto> produtosNoCarrinho = [
//   Produto('Produto 1', 20.0, 'caminho/imagem1.jpg'),
//   Produto('Produto 2', 30.0, 'caminho/imagem2.jpg'),
//   // Adicione outros produtos aqui
// ];
