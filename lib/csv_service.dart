import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:sa_fiti_cuminti/form.dart';

class CsvService {

  const CsvService();

  Future<List<Lucrare>> readCsvLucrari(String path) async {

    final bytes = await File(path).readAsBytes();
    final csvString = utf8.decode(bytes);
    final List<List<dynamic>> rows = const CsvToListConverter(
      // Specify the separator if it's not a comma (e.g., semicolon)
      fieldDelimiter: ',',
      // Optional: Set to true if the first row is a header
      shouldParseNumbers: true, // Attempt to parse values as numbers
    ).convert(csvString);

    List<Lucrare> lucrari = rows.map((x) => _parseLucrare(x)).toList();
    lucrari = lucrari.map((x) => _fixLength(x)).toList();


    return lucrari;
  }

  Lucrare _parseLucrare(List<dynamic> row) {
    return Lucrare(
      autor: row[0],
      denumire: row[1],
      collabName: row[2] == 'Collab' ? 'From row' : '',
      locatie: _getLocatie(row),
      tip: row[6],
      dimensiune: row[7],
      descriere: row[8],
      pret: row[9],
      instagramAutor: 'https://www.instagram.com/paraschiv.doru?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==',
    );
  }

  String _getLocatie(row) {
    if( row[3].contains('Da')  ) {
      return 'Amzei';
    } else if ( row[4].contains('Da')  ) {
      return 'Cowork';
    } else if (row[5].contains('Da') ) {
      return 'Goethe';
    } else {
      return '';
    }
  }

  Lucrare _fixLength(Lucrare x) {
    if (x.dimensiune.length > 10) {
      return x.copyWith(d: x.dimensiune);
    } else if (x.pret.length > 10) {
      return x.copyWith(p: x.pret);
    }
    else {
      return x;
    }
  }


}