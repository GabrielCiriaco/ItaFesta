import 'package:flutter/material.dart';
import 'package:itafesta/screens/tela_produto/produtos.dart';
import 'package:provider/provider.dart';

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
    final data = getProductsFromCart(cart);

    final produtosNoCarrinho = data['produtos'];
    final total = data['total'];

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
                    backgroundColor: Color.fromARGB(255, 32, 191, 240),
                    // padding: const EdgeInsets.all(15),
                  ),
                  onPressed: () {
                    // Lógica para finalizar a compra
                    // Disparar a notificação de compra realizada com sucesso
                    _showCompraRealizada(context);
                    // Redirecionar para a home
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Finalizar compra',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.red,
            //       // padding: const EdgeInsets.all(15),
            //     ),
            //     onPressed: () {
            //       // Lógica para finalizar a compra
            //       // Disparar a notificação de compra realizada com sucesso
            //       _showCompraRealizada(context);
            //       // Redirecionar para a home
            //       Navigator.pop(context);
            //     },
            //     child: const Text(
            //       'Finalizar compra',
            //       style: TextStyle(fontSize: 20, color: Colors.white),
            //     ),
            //   ),
            // ),
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
