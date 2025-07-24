import 'package:flutter/material.dart';
import '../services/firestore_services.dart';
import '../models/produto.dart';
import '../widgets/produto_tile.dart';

class ProdutosPage extends StatelessWidget {
  final FirestoreService firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      body: StreamBuilder<List<Produto>>(
        stream: firestore.getProdutos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final produtos = snapshot.data!;
          return ListView.builder(
            itemCount: produtos.length,
            itemBuilder: (context, index) {
              final produto = produtos[index];
              return ProdutoTile(
                produto: produto,
                onExcluir: () => firestore.excluirProduto(produto.id),
                // onEditar: () => ... // Implemente conforme necessário
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final nomeController = TextEditingController();
              final caixasController = TextEditingController();
              final pacotesController = TextEditingController();
              final unidadesController = TextEditingController();
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: Text('Novo Produto'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nomeController,
                          decoration: InputDecoration(labelText: 'Nome'),
                        ),
                        TextField(
                          controller: caixasController,
                          decoration: InputDecoration(labelText: 'Caixas'),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: pacotesController,
                          decoration: InputDecoration(labelText: 'Pacotes'),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: unidadesController,
                          decoration: InputDecoration(labelText: 'Unidades'),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          final nome = nomeController.text.trim();
                          final caixas =
                              int.tryParse(caixasController.text) ?? 0;
                          final pacotes =
                              int.tryParse(pacotesController.text) ?? 0;
                          final unidades =
                              int.tryParse(unidadesController.text) ?? 0;
                          if (nome.isNotEmpty) {
                            await firestore.adicionarProduto(
                              Produto(
                                id: '',
                                nome: nome,
                                quantidades: {
                                  'Caixas': caixas,
                                  'Pacotes': pacotes,
                                  'Unidades': unidades,
                                },
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: Text('Salvar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancelar'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
