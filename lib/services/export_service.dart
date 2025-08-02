import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import '../models/contagem_real.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ExportService {
  Future<void> exportToXLSX(List<ContagemReal> contagens) async {
    final excel = Excel.createExcel();
    final sheet = excel['Contagens'];

    // Adicionar cabeçalhos
    sheet.appendRow([
      'ID da Contagem',
      'Nome do Template',
      'Data da Contagem',
      'Observações',
      'Responsável',
      'Item',
      'Unidade',
      'Quantidade',
    ]);

    // Adicionar dados
    for (var contagem in contagens) {
      for (var itemContado in contagem.itensContados) {
        itemContado.quantidades.forEach((unidade, quantidade) {
          sheet.appendRow([
            contagem.id,
            contagem.nomeTemplate,
            contagem.dataContagem.toLocal().toString().split(' ')[0],
            contagem.observacoes,
            contagem.responsavel,
            itemContado.nomeItem,
            unidade,
            quantidade,
          ]);
        });
      }
    }

    // Salvar o arquivo
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/contagens.xlsx';
    final file = File(path);
    await file.writeAsBytes(excel.encode()!);

    // Abrir o arquivo
    await OpenFilex.open(path);
  }

  Future<void> exportToPDF(List<ContagemReal> contagens) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Relatório de Contagens',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          for (var contagem in contagens)
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'ID da Contagem: ${contagem.id}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text('Nome do Template: ${contagem.nomeTemplate}'),
                pw.Text(
                  'Data da Contagem: ${contagem.dataContagem.toLocal().toString().split(' ')[0]}',
                ),
                pw.Text('Observações: ${contagem.observacoes}'),
                pw.Text('Responsável: ${contagem.responsavel}'),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headers: ['Item', 'Unidade', 'Quantidade'],
                  data: contagem.itensContados.expand((itemContado) {
                    return itemContado.quantidades.entries.map((entry) {
                      return [
                        itemContado.nomeItem,
                        entry.key,
                        entry.value.toString(),
                      ];
                    });
                  }).toList(),
                ),
                pw.SizedBox(height: 20),
              ],
            ),
        ],
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/contagens.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    await OpenFilex.open(path);
  }
}
