import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as syncF;

import 'package:qr_flutter/qr_flutter.dart';

import 'form.dart';

const double PADDING = 10;
const double QR_SIZE = 70;
const double COL1_WIDTH = 200;
const double COL2_WIDTH = 200;
const double TITLE_SECTION_HEIGHT = 120;
const double CARD_HEIGHT = TITLE_SECTION_HEIGHT + QR_SIZE + 4 * PADDING;
const double ROW_SPACE_1 = 3; // Spatiul dintre randurile din sectiunea titlu
const double ROW_HEIGHT_1 = 20; // Inaltimea unui rand din sectiunea titlu
const double FONT_SIZE_1 = 14; // Dimensiunea fontului unui rand din sectiunea titlu
const double FONT_SIZE_2 = 10; // Dimensiunea fontului de la QR code name

class PdfSyncfusionService {
  void generatePage(Eticheta eticheta) async {
    final qr1Image = await _getQRCodes();
    final qr2Image = await _getQRCodes();


    _generate(eticheta, qr1Image, qr2Image);
  }

  Future<Uint8List?> _getQRCodes() async {
    // 1. Configure the QrPainter
    final painter = QrPainter(
        data: "https://www.instagram.ro",
        version: QrVersions.auto,
        gapless: false,
        // Define the colors/styles here if needed
        eyeStyle: const QrEyeStyle(
          color: ui.Color(0xFF000000), // Black
        ),
        // dataModuleStyle: const QrDataModuleStyle(
        //   color: ui.Color(0xFFB81919),           // culoarea punctelor
        // )
    );

    // 2. Convert the painter to a ui.Image
    // We use the specified size to define the final image resolution.
    final ui.Image image = await painter.toImage(240.0);

    // 3. Convert the ui.Image to raw ByteData (PNG format)
    final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  Future<void> _generate(Eticheta eticheta, Uint8List? qr1, Uint8List? qr2) async {
    //Create a PDF document.
    final syncF.PdfDocument document = syncF.PdfDocument();
    //Add page to the PDF
    final syncF.PdfPage page = document.pages.add();
    // //Get page client size
    // final ui.Size pageSize = page.getClientSize();

    _drawEticheta(Coord(5, 5), page, eticheta, qr1, qr2);

    final List<int> bytes = await document.save();
    final String dir = (await getApplicationDocumentsDirectory()).path;
    File('$dir/safiticuminti.pdf').writeAsBytes(bytes);

    document.dispose();
  }

  void _drawEticheta(Coord topleft, syncF.PdfPage page, Eticheta eticheta, Uint8List? qr1, Uint8List? qr2) {

    // Draw outside rectangle
    page.graphics.drawRectangle(
      pen: syncF.PdfPen(syncF.PdfColor(0, 0, 0), ),
      bounds: ui.Rect.fromLTWH(topleft.x, topleft.y, COL1_WIDTH + COL2_WIDTH + 4 * PADDING, CARD_HEIGHT),
    );

    // Draw vertical line between columns
    page.graphics.drawLine(
      syncF.PdfPen(syncF.PdfColor(0, 0, 0), ),
      ui.Offset(topleft.x + COL1_WIDTH + PADDING, topleft.y),
      ui.Offset(topleft.x + COL1_WIDTH + PADDING, topleft.y + CARD_HEIGHT),
    );

    // Draw horizontal line between title section and qr codes
    page.graphics.drawLine(
      syncF.PdfPen(syncF.PdfColor(0, 0, 0), ),
      ui.Offset(topleft.x, topleft.y + TITLE_SECTION_HEIGHT),
      ui.Offset(topleft.x + COL1_WIDTH + PADDING, topleft.y + TITLE_SECTION_HEIGHT),
    );


    // Draw autor
    final topLeftAutor = Coord(topleft.x + PADDING, topleft.y + PADDING);
    final topLeftSize = Coord(COL1_WIDTH, ROW_HEIGHT_1); // Width & height
    page.graphics.drawString(
      eticheta.autor.toUpperCase(),
      syncF.PdfStandardFont(syncF.PdfFontFamily.helvetica, FONT_SIZE_1, style: syncF.PdfFontStyle.bold),
      brush: syncF.PdfBrushes.black,
      bounds: ui.Rect.fromLTWH(topLeftAutor.x, topLeftAutor.y, topLeftSize.x, topLeftSize.y),
      format: syncF.PdfStringFormat(lineAlignment: syncF.PdfVerticalAlignment.middle),
    );

    // Draw titlu
    final topleftTitlu = Coord(topleft.x + PADDING, topLeftAutor.y + ROW_HEIGHT_1);
    final topLeftTitluSize = Coord(COL1_WIDTH, ROW_HEIGHT_1);
    page.graphics.drawString(
      eticheta.titlu,
      syncF.PdfStandardFont(syncF.PdfFontFamily.helvetica, FONT_SIZE_1),
      brush: syncF.PdfBrushes.black,
      bounds: ui.Rect.fromLTWH(topleftTitlu.x, topleftTitlu.y, topLeftTitluSize.x, topLeftTitluSize.y),
      format: syncF.PdfStringFormat(lineAlignment: syncF.PdfVerticalAlignment.middle),
    );

    // Draw type
    final topleftType = Coord(topleft.x + PADDING, topleftTitlu.y + ROW_HEIGHT_1);
    final topleftTypeSize = Coord(COL1_WIDTH, ROW_HEIGHT_1);
    page.graphics.drawString(
      'Sculptura',
      syncF.PdfStandardFont(syncF.PdfFontFamily.helvetica, FONT_SIZE_1),
      brush: syncF.PdfBrushes.black,
      bounds: ui.Rect.fromLTWH(topleftType.x, topleftType.y, topleftTypeSize.x, topleftTypeSize.y),
      format: syncF.PdfStringFormat(lineAlignment: syncF.PdfVerticalAlignment.middle),
    );

    // Draw size
    final topleftSize = Coord(topleft.x + PADDING, topleftType.y + ROW_HEIGHT_1);
    final topleftSizeSize = Coord(COL1_WIDTH, ROW_HEIGHT_1);
    page.graphics.drawString(
      eticheta.marime,
      syncF.PdfStandardFont(syncF.PdfFontFamily.helvetica, FONT_SIZE_1),
      brush: syncF.PdfBrushes.black,
      bounds: ui.Rect.fromLTWH(topleftSize.x, topleftSize.y, topleftSizeSize.x, topleftSizeSize.y),
      format: syncF.PdfStringFormat(lineAlignment: syncF.PdfVerticalAlignment.middle),
    );

    // Draw an
    final topleftAn = Coord(topleft.x + PADDING, topleftSize.y + ROW_HEIGHT_1);
    final topleftAnSize = Coord(COL1_WIDTH, ROW_HEIGHT_1);
    page.graphics.drawString(
      eticheta.an,
      syncF.PdfStandardFont(syncF.PdfFontFamily.helvetica, 16),
      brush: syncF.PdfBrushes.black,
      bounds: ui.Rect.fromLTWH(topleftAn.x, topleftAn.y, topleftAnSize.x, topleftAnSize.y),
      format: syncF.PdfStringFormat(lineAlignment: syncF.PdfVerticalAlignment.middle),
    );

    // Draw QR code 1
    final qr1pos = Coord(topleft.x + PADDING, TITLE_SECTION_HEIGHT + 2 * PADDING);
    final qr2pos = Coord(topleft.x + 2 * PADDING + QR_SIZE, qr1pos.y);
    if (qr1 != null) {
      page.graphics.drawImage(
        syncF.PdfBitmap(qr1),
        ui.Rect.fromLTWH(qr1pos.x, qr1pos.y, QR_SIZE, QR_SIZE),
      );
    }

    // Draw QR code text 1
    // final qrText1pos = Coord(qr1pos.x + QR_SIZE, qr1pos.y + QR_SIZE);
    final qrText1pos = Coord(400, 220);
    final qrText1Size = Coord(QR_SIZE, QR_SIZE); // Width & Height
    if (qr1 != null) {
      page.graphics.drawString('A',
        syncF.PdfStandardFont(syncF.PdfFontFamily.helvetica, FONT_SIZE_2),
        brush: syncF.PdfBrushes.black,
        bounds: ui.Rect.fromLTWH(qrText1pos.x, qrText1pos.y, qrText1Size.x, qrText1Size.y),
        format: syncF.PdfStringFormat(textDirection: syncF.PdfTextDirection.leftToRight),
      );

      page.graphics..rotateTransform(90)
        ..drawString(
        'Nume QR 1',
        syncF.PdfStandardFont(syncF.PdfFontFamily.helvetica, FONT_SIZE_2),
        brush: syncF.PdfBrushes.black,
        bounds: ui.Rect.fromLTWH(qrText1pos.x, qrText1pos.y, qrText1Size.x, qrText1Size.y),
        format: syncF.PdfStringFormat(textDirection: syncF.PdfTextDirection.leftToRight),
      )
      ..rotateTransform(-90);
    }

    // Draw QR code 2
    if (qr2!= null) {
      page.graphics.drawImage(
        syncF.PdfBitmap(qr2),
        ui.Rect.fromLTWH(qr2pos.x, qr2pos.y, QR_SIZE, QR_SIZE),
      );
    }

    // Draw description
    final topleftDesc = Coord(topleft.x + COL1_WIDTH + 2 * PADDING, topleft.y);
    final topleftDescSize = Coord(COL2_WIDTH + PADDING, CARD_HEIGHT); // Width & Height
    page.graphics.drawString(
      eticheta.description,
      syncF.PdfStandardFont(syncF.PdfFontFamily.helvetica, 16),
      brush: syncF.PdfBrushes.black,
      bounds: ui.Rect.fromLTWH(topleftDesc.x, topleftDesc.y, topleftDescSize.x, topleftDescSize.y),
      format: syncF.PdfStringFormat(lineAlignment: syncF.PdfVerticalAlignment.top),
    );
  }

  void _saveDocument(syncF.PdfDocument document) async {
  }
}

class Coord {
  final double x;
  final double y;

  const Coord(this.x, this.y);
  const Coord.of({required this.x, required this.y});

}