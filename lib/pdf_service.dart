import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sa_fiti_cuminti/form.dart';

class PdfService {

  void generatePage(Eticheta eticheta) async {
    final qr1Image = await _getQRCodes();
    final qr2Image = await _getQRCodes();

    final img = await rootBundle.load('assets/insta.png');
    final imageBytes = img.buffer.asUint8List();

    _generate(eticheta, qr1Image, qr2Image);
  }

  void _generate(Eticheta eticheta, Uint8List? qr1, Uint8List? qr2) {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
        margin: pw.EdgeInsets.all(10),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
              height: 200,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                    width: 1.0, color: PdfColor.fromHex("#000")),
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
                                padding: pw.EdgeInsets.symmetric(
                                    horizontal: 20),
                                child: pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .start,
                                    children: [
                                      pw.Text(eticheta.autor.toUpperCase(),
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold),),
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

                            // QR codes in a row
                            pw.Container(
                              child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment .spaceBetween,
                                children: [
                                  // pw.Text("asfasdfasd", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.values[0])),
                                  pw.Container(
                                    width: 50,
                                    height: 50,
                                    // color: PdfColor.fromHex("#333333"),
                                    child: pw.Image(pw.MemoryImage(qr1!), height: 40, width: 40),
                                  ),

                                  pw.Container(
                                    width: 50,
                                    height: 50,
                                    // color: PdfColor.fromHex("#333333"),
                                    child: pw.Image(pw.MemoryImage(qr2!), height: 40, width: 40),
                                  )
                                ],
                              ),
                            ),
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
                        padding: const pw.EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20),
                        child: pw.Flexible(child: pw.Text(eticheta.description,
                          style: pw.TextStyle(fontSize: 14, fontWeight: pw
                              .FontWeight.values[0]),)),
                      ),
                    ),
                  ]
              )
          ); // Center
        })); // Page

      _saveDocument(pdf);
    }

    void _saveDocument(pw.Document pdf) async {
      final dir = await getApplicationDocumentsDirectory();
      log("downloads: $dir");

      final file = File('${dir.path}/safiticuminti.pdf');
      await file.writeAsBytes(await pdf.save());
    }

    Future<Uint8List?> _getQRCodes() async {
      // 1. Configure the QrPainter
      final painter = QrPainter(
        data: "https://www.instagram.ro",
        version: QrVersions.auto,
        gapless: false,
        // Define the colors/styles here if needed
        eyeStyle: const QrEyeStyle(
          color: Color(0xFF000000), // Black
        ),
        dataModuleStyle: const QrDataModuleStyle(
          color: Color(0xFFB81919),
        )
      );

      // 2. Convert the painter to a ui.Image
      // We use the specified size to define the final image resolution.
      final ui.Image image = await painter.toImage(100.0);

      // 3. Convert the ui.Image to raw ByteData (PNG format)
      final ByteData? byteData = await image.toByteData(
          format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    }
  }

