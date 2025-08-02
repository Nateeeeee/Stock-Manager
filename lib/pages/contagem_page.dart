import 'package:flutter/material.dart';
import '../models/template_contagem.dart';
import '../services/local_storage_service.dart';

class ContagemPage extends StatefulWidget {
  final String templateId;
  final String templateNome;
  final List<ItemTemplate> itens;
  final Map<String, Map<String, num>>? contagemInicial;

  const ContagemPage({
    required this.templateId,
    required this.templateNome,
    required this.itens,
    this.contagemInicial,
    super.key,
  });

  @override
  State<ContagemPage> createState() => _ContagemPageState();
}

class _ContagemPageState extends State<ContagemPage> {
  late Map<String, Map<String, num>> contagem;

  @override
  void initState() {
    super.initState();
    print('DEBUG: widget.itens.length = ${widget.itens.length}');
    for (var item in widget.itens) {
      print(
        'DEBUG: item.nome = ${item.nome}, item.unidades = ${item.unidades}',
      );
    }

    if (widget.contagemInicial != null) {
      print('DEBUG: contagemInicial is not null');
      contagem = Map<String, Map<String, num>>.from(
        widget.contagemInicial!.map(
          (key, value) => MapEntry(key, Map<String, num>.from(value)),
        ),
      );
    } else {
      print('DEBUG: contagemInicial is null, creating new contagem');
      contagem = {
        for (var item in widget.itens)
          item.nome: {for (var unidade in item.unidades) unidade: 0.0},
      };
    }

    print('DEBUG: contagem = $contagem');
  }

  @override
  Widget build(BuildContext context) {
    print('DEBUG: build called, widget.itens.length = ${widget.itens.length}');
    return Scaffold(
      appBar: AppBar(title: Text('Contagem - ${widget.templateNome}')),
      body: ListView(
        children: widget.itens.map((item) {
          print(
            'DEBUG: Building card for item: ${item.nome}, unidades: ${item.unidades}',
          );
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item.nome,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ...item.unidades.map((unidade) {
                  print('DEBUG: Building ListTile for unidade: $unidade');
                  return ListTile(
                    title: Text(unidade),
                    trailing: SizedBox(
                      width: 80,
                      child: TextFormField(
                        initialValue: (contagem[item.nome]?[unidade] ?? 0)
                            .toString(),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          setState(() {
                            contagem[item.nome]![unidade] =
                                num.tryParse(val) ?? 0;
                          });
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          // Converte todos os valores para int
          final contagemInt = contagem.map(
            (produto, unidades) => MapEntry(
              produto,
              unidades.map(
                (unidade, valor) => MapEntry(unidade, valor.toInt()),
              ),
            ),
          );

          await salvarContagemLocal(
            templateId: widget.templateId,
            templateNome: widget.templateNome,
            contagem: contagemInt,
          );
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Contagem salva localmente!')));
        },
      ),
    );
  }
}
