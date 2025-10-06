import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sa_fiti_cuminti/form.dart';

class PdfService {
  final pdf = pw.Document();

  void generate(Eticheta eticheta) {
    pdf.addPage(pw.Page(
          margin: pw.EdgeInsets.all(10),
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Container(
              height: 200,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(width: 1.0, color: PdfColor.fromHex("#000")),
              ),


              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [

                  // Col 1
                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(vertical: 20),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.symmetric(horizontal: 20),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(eticheta.autor.toUpperCase(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                              pw.Text(eticheta.titlu),
                              pw.Text(eticheta.marime),
                              pw.Text(eticheta.an),
                            ]
                          )
                        ),


                        // Horizontal separator
                        pw.Container(
                          margin: pw.EdgeInsets.symmetric(vertical: 20),
                          width: 200,
                          height: 1,
                          color: PdfColor.fromHex("#000")
                        ),

                        // QR codes
                      ]
                    ),
                  ),

                  // Vertical separator intre col 1 si descriere
                  pw.Container(
                    height: 300,
                    width: 1,
                    color: PdfColor.fromHex("#000")
                  ),

                  // Col Descriere
                  pw.Expanded(
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                      child: pw.Flexible(child: pw.Text(eticheta.description, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.values[0]),)),
                    ),
                  ),
                ]
              )
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