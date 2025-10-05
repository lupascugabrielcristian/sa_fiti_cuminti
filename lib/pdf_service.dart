import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfService {
  final pdf = pw.Document();

  void generate() {
    pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Row(
              children: [
                // Col 1
                pw.Column(
                  children: [
                    pw.Row(children: [pw.Text("ADI POPESCU")]),
                    pw.Row(children: [pw.Text('I sealed myself to find me later'),]),
                    pw.Row(children: [pw.Text('Sculptura'),]),
                    pw.Row(children: [pw.Text('150 X 28 cm'),]),

                    pw.Text('2025')
                  ],
                ),

                pw.Text('''Săfițicuminți implică artă
                          live, expoziții, galerie și
                          street art. Multă diversitate,
                          energie creativă și drive
                          social. Vrem să provocăm
                          societatea să își trezească
                          în fiecare zi la viață
                          creativitatea; și ce alt mod
                          mai bun de a face asta,
                          dacă nu prin produsele
                          care ne îmbracă și arta
                          care ne înconjoară?'''),
              ]
            ); // Center
          })); // Page

    _saveDocument();
  }

  void _saveDocument() async {
    final dir = await getApplicationDocumentsDirectory();
    log("downloads: $dir");

    final file = File('${dir.path}/safiticuminti.pdf');
    await file.writeAsBytes(await pdf.save());
  }
}