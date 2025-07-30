// lib/models/contagem_local.dart
class ContagemLocal {
  final String templateId;
  final Map<String, Map<String, int>> contagem; // produto -> categoria -> valor

  ContagemLocal({required this.templateId, required this.contagem});
}