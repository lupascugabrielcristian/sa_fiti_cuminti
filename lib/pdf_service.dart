import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sa_fiti_cuminti/form.dart';

class FontStyles {
  final pw.Font normal;
  final pw.Font qr;
  final pw.Font bold;

  const FontStyles(this.normal, this.qr, this.bold);
}

class PdfService {

  const PdfService();

  final double FIRST_COL_WIDTH = 210;
  final double CARD_HEIGHT = 200;
  final double FONT_SIZE = 11;
  final double FONT_SIZE_QR = 9;

  Future<int> generateEtichete(List<Eticheta> etichete) async {

    final n = (etichete.length / 4).round();
    for (var i = 0; i < n; i++) {
      await _generatePage([
        etichete[4 * i + 0],
        etichete[4 * i + 1],
        etichete[4 * i + 2],
        if (etichete.length > 4 * i + 3) etichete[4 * i + 3],
      ], i);
    }

    return n;
  }

  Future<File> _generatePage(List<Eticheta> etichete, int page) async {
    final qr1Image = await _getQRCodes();
    final qr2Image = await _getQRCodes();

    // final img = await rootBundle.load('assets/insta.png');
    final font = await _loadFont();
    final fontBold = await _loadFontBold();
    final fontStyles = FontStyles(font, font, fontBold);

    return _generate(etichete, qr1Image, qr2Image, page, fontStyles);
  }

  Future<pw.Font> _loadFont() async {
    final ByteData fontData = await rootBundle.load('assets/fonts/DarkerGrotesque-VariableFont_wght.ttf');
    final pw.Font ttf = pw.Font.ttf(fontData);
    return ttf;
  }

  Future<pw.Font> _loadFontBold() async {
    final ByteData fontData = await rootBundle.load('assets/fonts/Lulo Clean W01 One Bold.otf');
    // final ByteData fontData = await rootBundle.load('assets/fonts/LexendDeca-VariableFont_wght.ttf');
    // final ByteData fontData = await rootBundle.load('assets/fonts/IBMPlexSans-VariableFont_wdth,wght.ttf');
    final pw.Font ttf = pw.Font.ttf(fontData);
    return ttf;
  }

  Future<File> _generate(List<Eticheta> etichete, Uint8List? qr1, Uint8List? qr2, int page, FontStyles font) {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
      margin: pw.EdgeInsets.all(10),
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          children: etichete.map((x) => _buildEticheta(x, qr1, qr2, font)).toList()
        );
      })
    ); // Page

      return _saveDocument(pdf, page);
    }


    pw.Container _buildEticheta(Eticheta eticheta, Uint8List? qr1, Uint8List? qr2, FontStyles font) {
      pw.TextStyle fontStyleBold = pw.TextStyle(font: font.bold, fontSize: FONT_SIZE, fontWeight: pw.FontWeight.bold, letterSpacing: 0);
      pw.TextStyle fontStyleQr = pw.TextStyle(font: font.qr, fontSize: FONT_SIZE_QR, fontWeight: pw.FontWeight.values[1], lineSpacing: 0);
      pw.TextStyle fontStyle = pw.TextStyle(font: font.normal, fontSize: FONT_SIZE, fontWeight: pw.FontWeight.values[0]);

      return pw.Container(
        margin: pw.EdgeInsets.symmetric(vertical: 10),
          height: CARD_HEIGHT,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(
                width: 1.0, color: PdfColor.fromHex("#000")),
          ),

          child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [

                // Col 1
                pw.Stack(
                  children: [
                    pw.Container(
                      width: FIRST_COL_WIDTH,
                      decoration: pw.BoxDecoration(
                        border: pw.Border(
                            right: pw.BorderSide(width: 1.0, color: PdfColors.black)),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.only(left: 10, top: 5),

                            child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment .start,
                                children: [
                                  pw.Text(eticheta.autor.toUpperCase(), style: fontStyleBold,),

                                  pw.SizedBox(height: 5),

                                  pw.Text(eticheta.titlu, style: fontStyle),
                                  pw.Text(eticheta.tip, style: fontStyle),
                                  pw.Text(eticheta.marime, style: fontStyle),
                                  pw.Text(eticheta.an, style: fontStyle),
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
                                padding: pw.EdgeInsets.only(top: 20),
                                child: pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(width: 10),

                                    _qrCodeWithText(qr1!, eticheta.autor.toUpperCase(), fontStyleQr),

                                    pw.SizedBox(width: 30),

                                    _qrCodeWithText(qr2!, eticheta.autor.toUpperCase(), fontStyleQr),
                                  ],
                                ),
                              )
                          ),
                        ] )
                    ),

                    // PRETUL
                    if (eticheta.pret > 0) pw.Positioned(
                      top: 3,
                      right: 10,
                      child: pw.Text('${eticheta.pret}\n${eticheta.pretUnit}', style: fontStyle),
                    ),


                  ]
                ),

                // Col Descriere
                pw.Expanded(
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.symmetric( vertical: 5.0, horizontal: 10),
                    child: pw.Flexible( child: pw.Text( eticheta.description, style: fontStyle ),
                  ),
                )),
              ]
          )
      );
    }

    Future<File> _saveDocument(pw.Document pdf, int page) async {
      final dir = await getApplicationDocumentsDirectory();
      log("downloads: $dir");

      final file = File('${dir.path}/safiticuminti_$page.pdf');
      return file.writeAsBytes(await pdf.save());
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
          color: Color(0xFF3C3C3C), // Black
        ),
        dataModuleStyle: const QrDataModuleStyle(
          color: Color(0xFF3C3C3C),
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

    _qrCodeWithText(Uint8List qrData, String text, pw.TextStyle fontStyle) {
      return pw.Container(
        width: 70,
        child: pw.Row(
          children: [
            pw.Container(
              width: 60,
              height: 60,
              child: pw.Image(pw.MemoryImage(qrData), height: 60, width: 60),
            ),

            // pw.SizedBox(width: 5),
            
            pw.Container(
              width: 60,
              height: 60,
              margin: pw.EdgeInsets.only(top: 0),
              child: _rotatedText( text, fontStyle ),
            ),
          ]
        )
      );
    }

    pw.Widget _rotatedText(String text, pw.TextStyle fontStyle) {
      return pw.Transform.rotate(
          angle: 1.57079633,
          child: pw.Text(text, style: fontStyle));
    }

  }

