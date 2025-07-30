import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'contagem_page.dart';
import '../models/template_contagem.dart';

class ContagensSalvasPage extends StatefulWidget {
  const ContagensSalvasPage({super.key});

  @override
  State<ContagensSalvasPage> createState() => _ContagensSalvasPageState();
}

class _ContagensSalvasPageState extends State<ContagensSalvasPage> {
  late Box contagensBox;

  @override
  void initState() {
    super.initState();
    Hive.openBox('contagens').then((box) {
      setState(() {
        contagensBox = box;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!Hive.isBoxOpen('contagens')) {
      return Scaffold(
        appBar: AppBar(title: Text('Contagens Salvas')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final keys = contagensBox.keys.toList();

    if (keys.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Contagens Salvas')),
        body: Center(child: Text('Nenhuma contagem salva localmente.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Contagens Salvas')),
      body: ListView.builder(
        itemCount: keys.length,
        itemBuilder: (context, index) {
          final key = keys[index];
          final data = contagensBox.get(key);
          if (data == null) return SizedBox.shrink();

          final mapData = data as Map;
          final nomeTemplate = mapData['templateNome'] ?? mapData['templateId'];
          final dataContagem = mapData['data'] ?? '';
          final produtos = (mapData['contagem'] as Map).keys.join(', ');
          return ListTile(
            title: Text('Contagem: $nomeTemplate'),
            subtitle: Text('Data: $dataContagem\nProdutos: $produtos'),
            trailing: Icon(Icons.chevron_right),
            onTap: () async {
              // Buscar itens do template no Firestore
              final doc = await FirebaseFirestore.instance
                  .collection('templates')
                  .doc(mapData['templateId'])
                  .get();
              if (!doc.exists) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Template não encontrado no Firestore!'),
                  ),
                );
                return;
              }
              final data = doc.data()!;
              final itens = (data['itens'] as List)
                  .map(
                    (e) => ItemTemplate.fromMap(Map<String, dynamic>.from(e)),
                  )
                  .toList();

              // Abrir ContagemPage com os dados salvos
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ContagemPage(
                    templateId: mapData['templateId'],
                    templateNome: mapData['templateNome'],
                    itens: itens,
                    contagemInicial: Map<String, Map<String, int>>.from(
                      (mapData['contagem'] as Map).map(
                        (k, v) => MapEntry(
                          k as String,
                          Map<String, int>.from(v as Map),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            onLongPress: () async {
              await contagensBox.delete(key);
              setState(() {});
            },
          );
        },
      ),
    );
  }
}
