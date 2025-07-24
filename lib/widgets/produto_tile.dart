import 'package:flutter/material.dart';
import '../models/produto.dart';

class ProdutoTile extends StatelessWidget {
  final Produto produto;
  final VoidCallback? onEntrada;
  final VoidCallback? onSaida;
  final VoidCallback? onEditar;
  final VoidCallback? onExcluir;

  const ProdutoTile({
    Key? key,
    required this.produto,
    this.onEntrada,
    this.onSaida,
    this.onEditar,
    this.onExcluir,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(produto.nome),
        subtitle: Text(
          produto.quantidades.entries
              .where((e) => e.value > 0)
              .map((e) => '${e.value} ${e.key.toLowerCase()}')
              .join(' | '),
        ),
        leading: IconButton(
          icon: const Icon(Icons.remove, color: Colors.red),
          tooltip: 'Saída de estoque',
          onPressed: onSaida,
        ),
        trailing: Wrap(
          spacing: 4,
          children: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.green),
              tooltip: 'Entrada de estoque',
              onPressed: onEntrada,
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              tooltip: 'Editar produto',
              onPressed: onEditar,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey),
              tooltip: 'Excluir produto',
              onPressed: onExcluir,
            ),
          ],
        ),
      ),
    );
  }
}
