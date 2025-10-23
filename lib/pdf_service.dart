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

  const FontStyles({required this.normal, required this.qr, required this.bold});
}

class EtichetaWithQR {
  final Eticheta eticheta;
  final Uint8List? qrAutor;
  final Uint8List? qrGalerie;
  final Uint8List? qrCollab;

  const EtichetaWithQR(this.eticheta, {this.qrAutor, this.qrGalerie, this.qrCollab});
}

class PdfService {

  const PdfService();

  final double FIRST_COL_WIDTH = 260;
  final double CARD_HEIGHT = 200;
  final double CARD_WIDTH = 450;
  final double FONT_SIZE = 11;
  final double FONT_SIZE_QR = 9;
  final int ETICHETE_PE_PAGINA = 3;

  Future<List<String>> generateEtichete(List<Eticheta> etichete) async {

    List<String> savedPaths = [];

    final n = (etichete.length / ETICHETE_PE_PAGINA).ceil();
    for (var i = 0; i < n; i++) {
      final savedFile = await _generatePage([
        if (etichete.length > (ETICHETE_PE_PAGINA * i + 0)) etichete[ETICHETE_PE_PAGINA * i + 0],
        if (etichete.length > (ETICHETE_PE_PAGINA * i + 1)) etichete[ETICHETE_PE_PAGINA * i + 1],
        if (etichete.length > (ETICHETE_PE_PAGINA * i + 2)) etichete[ETICHETE_PE_PAGINA * i + 2],
        if (etichete.length > (ETICHETE_PE_PAGINA * i + 3)) etichete[ETICHETE_PE_PAGINA * i + 3],
      ], i);
      savedPaths.add(savedFile.path);
    }

    return savedPaths;
  }

  Future<File> _generatePage(List<Eticheta> etichete, int page) async {
    final logoImage = await rootBundle.load('assets/safiticuminti.jpeg');

    final font = await _loadFont();
    final fontBold = await _loadFontBold();
    final fontStyles = FontStyles(normal: font, qr: fontBold, bold: fontBold);

    List<EtichetaWithQR> eticheteReady = [];
    for (final e in etichete) {
      final qr1Image = await _getQRCodes(e.instagramAutor);
      final qr2Image = await _getQRCodes(e.instagramGallery);
      eticheteReady.add(EtichetaWithQR(e, qrAutor: qr1Image, qrGalerie: qr2Image));
    }

    return _generate(eticheteReady, logoImage.buffer.asUint8List(), page, fontStyles);
  }

  Future<pw.Font> _loadFont() async {
    final ByteData fontData = await rootBundle.load('assets/fonts/DarkerGrotesque-VariableFont_wght.ttf');
    final pw.Font ttf = pw.Font.ttf(fontData);
    return ttf;
  }

  Future<pw.Font> _loadFontBold() async {
    // final ByteData fontData = await rootBundle.load('assets/fonts/Lulo Clean W01 One Bold.otf');
    final ByteData fontData = await rootBundle.load('assets/fonts/LexendDeca-VariableFont_wght.ttf');
    // final ByteData fontData = await rootBundle.load('assets/fonts/IBMPlexSans-VariableFont_wdth,wght.ttf');
    final pw.Font ttf = pw.Font.ttf(fontData);
    return ttf;
  }

  Future<File> _generate(List<EtichetaWithQR> etichete, Uint8List logoImage, int page, FontStyles fonts) {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
      margin: pw.EdgeInsets.all(10),
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          children: etichete.map((x) => _buildEticheta(x.eticheta, x.qrAutor, x.qrGalerie, logoImage, fonts)).toList()
        );
      })
    ); // Page

      return _saveDocument(pdf, page);
  }

  pw.Widget _buildEticheta(Eticheta eticheta, Uint8List? qr1, Uint8List? qr2, Uint8List logoImage, FontStyles fonts) {
    pw.TextStyle fontStyleBold = pw.TextStyle(font: fonts.bold, fontSize: FONT_SIZE, fontWeight: pw.FontWeight.bold, letterSpacing: 0);
    pw.TextStyle fontStyleQr = pw.TextStyle(font: fonts.qr, fontSize: FONT_SIZE_QR, fontWeight: pw.FontWeight.values[1], lineSpacing: 0);
    pw.TextStyle fontStyle = pw.TextStyle(font: fonts.normal, fontSize: FONT_SIZE, fontWeight: pw.FontWeight.values[0], lineSpacing: 0, height: 1);

    return pw.Stack(
      children: [
        // LOGO SAFITICUMINTI

        pw.Positioned(
          bottom: 20,
          right: 10,
          child: pw.Image(pw.MemoryImage(logoImage), height: 35),
        ),

        // ETICHETA PROPRIUZISA
        pw.Container(
          margin: pw.EdgeInsets.symmetric(vertical: 10),
          height: CARD_HEIGHT,
          width: CARD_WIDTH,
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
                pw.Expanded(
                  child: pw.Container(
                    width: FIRST_COL_WIDTH,
                      decoration: pw.BoxDecoration(
                        border: pw.Border(
                            right: pw.BorderSide(width: 1.0, color: PdfColors.black)),
                      ),
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 10, top: 10, right: 10),

                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
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
                                      top: pw.BorderSide(width: 0.5, color: PdfColors.black)),
                                ),
                                child: pw.Padding(
                                  padding: pw.EdgeInsets.only(top: 20),
                                  child: pw.Row(
                                    mainAxisAlignment: pw.MainAxisAlignment.start,
                                    children: [
                                      pw.SizedBox(width: 10),

                                      _qrCodeWithText(qr1!, eticheta.autor.toUpperCase(), fontStyleQr),

                                      pw.SizedBox(width: 50),

                                      _qrCodeWithText(qr2!, 'SAFITICUMINTI\NGALLERY', fontStyleQr),
                                    ],
                                  ),
                                )
                            ),
                          ] )
                  ),

                ),

                // PRETUL
                if (eticheta.pret > 0) pw.Positioned(
                  top: 8,
                  right: 10,
                  child: pw.Text('${eticheta.pret}\n${eticheta.pretUnit}', style: fontStyleBold, textAlign: pw.TextAlign.right),
                ),
              ]
            ),

            // Col Descriere
            pw.Expanded(
              child: pw.Padding(
                padding: const pw.EdgeInsets.symmetric( vertical: 5.0, horizontal: 30),
                child: pw.Flexible( child: pw.Text( eticheta.description, textAlign: pw.TextAlign.justify, style: fontStyle ),
                ),
            )),
          ]
        )),
      ]
    );
  }

  Future<File> _saveDocument(pw.Document pdf, int page) async {
    final Directory dir;

    if (Platform.isWindows) {
      dir = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    final file = File('${dir.path}/safiticuminti_$page.pdf');
    return file.writeAsBytes(await pdf.save());
  }

  Future<Uint8List?> _getQRCodes(String data) async {
    // 1. Configure the QrPainter
    final painter = QrPainter(
      data: data,
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
      width: 80,
      child: pw.Row(
        children: [
          pw.Container(
            width: 70,
            height: 70,
            child: pw.Image(pw.MemoryImage(qrData), height: 70, width: 70),
          ),

          // pw.SizedBox(width: 5),

          pw.Container(
            width: 70,
            height: 70,
            margin: pw.EdgeInsets.only(bottom: 10),
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

