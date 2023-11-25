import 'package:flutter/material.dart';

class CarrinhoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
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
                backgroundImage: AssetImage(produto.imagem),
              ),
              title: Text(produto.nome),
              subtitle: Text('R\$ ${produto.valor.toStringAsFixed(2)}'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Lógica para remover o produto do carrinho
                  // produtosNoCarrinho.removeAt(index);
                  // Você pode usar um método para remover o item do carrinho
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              // Lógica para finalizar a compra
              // Disparar a notificação de compra realizada com sucesso
              _showCompraRealizada(context);
              // Redirecionar para a home
              Navigator.pop(context);
            },
            child: Text('Finalizar Compra'),
          ),
        ),
      ),
    );
  }

  void _showCompraRealizada(BuildContext context) {
    // Mostrar a notificação de compra realizada com sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compra realizada com sucesso!'),
      ),
    );
  }
}

class Produto {
  final String nome;
  final double valor;
  final String imagem;

  Produto(this.nome, this.valor, this.imagem);
}

// Exemplo de lista de produtos no carrinho
List<Produto> produtosNoCarrinho = [
  Produto('Produto 1', 20.0, 'caminho/imagem1.jpg'),
  Produto('Produto 2', 30.0, 'caminho/imagem2.jpg'),
  // Adicione outros produtos aqui
];
