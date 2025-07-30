import 'package:hive/hive.dart';

/// Salva uma nova contagem localmente com chave única.
Future<void> salvarContagemLocal({
  required String templateId,
  required String templateNome,
  required Map<String, Map<String, int>> contagem,
}) async {
  final box = await Hive.openBox('contagens');
  final id = DateTime.now().millisecondsSinceEpoch.toString();
  await box.put(id, {
    'templateId': templateId,
    'templateNome': templateNome,
    'data': DateTime.now().toIso8601String(),
    'contagem': contagem,
  });
}

/// Recupera todas as contagens salvas como uma lista de mapas.
/// Cada mapa contém: templateId, templateNome, data, contagem, e a chave Hive.
Future<List<Map<String, dynamic>>> recuperarTodasContagens() async {
  final box = await Hive.openBox('contagens');
  final keys = box.keys.toList();
  List<Map<String, dynamic>> contagens = [];
  for (var key in keys) {
    final data = box.get(key);
    if (data != null && data is Map) {
      contagens.add({...data, 'hiveKey': key});
    }
  }
  return contagens;
}

/// Remove uma contagem pelo Hive key.
Future<void> removerContagem(dynamic hiveKey) async {
  final box = await Hive.openBox('contagens');
  await box.delete(hiveKey);
}