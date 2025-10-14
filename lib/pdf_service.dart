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

  final double FIRST_COL_WIDTH = 230;
  final double CARD_HEIGHT = 200;

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
              height: CARD_HEIGHT,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                    width: 1.0, color: PdfColor.fromHex("#000")),
              ),


              child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [

                  // Col 1
                  pw.Container(
                      width: FIRST_COL_WIDTH,
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('#555555'),
                        border: pw.Border(
                            right: pw.BorderSide(width: 1.0, color: PdfColors.black)),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.only(left: 10, top: 10),

                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment .start,
                              children: [
                                pw.Text(eticheta.autor.toUpperCase(), style: pw.TextStyle( fontWeight: pw.FontWeight.bold),),

                                pw.SizedBox(height: 10),

                                pw.Text(eticheta.titlu),
                                pw.Text(eticheta.tip),
                                pw.Text(eticheta.marime),
                                pw.Text(eticheta.an),
                              ]
                            ),
                          ),

                          pw.SizedBox(height: 10),

                          // QR codes in a row
                          pw.Container(
                            width: FIRST_COL_WIDTH,
                            decoration: const pw.BoxDecoration(
                              border: pw.Border(
                                  top: pw.BorderSide(width: 1.0, color: PdfColors.black)),
                            ),
                            child: pw.Padding(
                              padding: pw.EdgeInsets.only(top: 10),
                              child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.SizedBox(width: 10),

                                _qrCodeWithText(qr1!, eticheta.autor.toUpperCase()),

                                pw.SizedBox(width: 10),

                                _qrCodeWithText(qr2!, eticheta.autor.toUpperCase()),
                              ],
                            ),
                            )
                          ),
                        ] )
                    ),

                    // Vertical separator intre col 1 si descriere
                    // pw.Container(
                    //     height: 280,
                    //     width: 1,
                    //     color: PdfColor.fromHex("#000")
                    // ),

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
          eyeShape: QrEyeShape.square,
          color: Color(0xFF817E7E), // Black
        ),
        dataModuleStyle: const QrDataModuleStyle(
          color: Color(0xFF4C4848),
        )
      );

      // 2. Convert the painter to a ui.Image
      // We use the specified size to define the final image resolution.
      final ui.Image image = await painter.toImage(90.0);

      // 3. Convert the ui.Image to raw ByteData (PNG format)
      final ByteData? byteData = await image.toByteData(
          format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    }

    _qrCodeWithText(Uint8List qrData, String text) {
      return pw.Container(
        width: 90,
        child: pw.Row(
          children: [
            pw.Container(
              width: 80,
              height: 80,
              child: pw.Image(pw.MemoryImage(qrData), height: 70, width: 70),
            ),

            pw.SizedBox(width: 5),
            
            pw.Container(
              width: 80,
              height: 80,
              margin: pw.EdgeInsets.only(top: -10),
              child: _rotatedText( text ),
            ),
          ]
        )
      );
    }

    pw.Widget _rotatedText(String text) {
      return pw.Transform.rotate(
          angle: 1.57079633,
          child: pw.Text(text, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),));
    }

  }

