import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:sa_fiti_cuminti/form.dart';

class EtichetaWidget extends StatelessWidget {
  const EtichetaWidget({super.key, required this.eticheta});

  final Eticheta eticheta;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1.0, color: Colors.black26),
      ),
      
      
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Col 1
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide( width: 1.0, color: Colors.black45, ),
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(eticheta.autor.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold),),

                        SizedBox(height: 10,),

                        Text(eticheta.titlu),
                        Text(eticheta.marime),
                        Text(eticheta.an),

                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20,),

                // QR codes row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [

                      // QR code 1
                      SizedBox(
                        height: 90,
                        width: 90,
                        child: PrettyQrView(
                          qrImage: QrImage(QrCode.fromData(data: "www.google.com ${Random().nextInt(5000)}" , errorCorrectLevel: QrErrorCorrectLevel.H),),
                          decoration: const PrettyQrDecoration(
                            background: Colors.transparent,
                            shape: const PrettyQrDotsSymbol(
                              color: Colors.black,
                            ),
                            quietZone: const PrettyQrQuietZone.modules(0),
                            image: PrettyQrDecorationImage(
                              image: AssetImage('assets/insta.png'),
                              position: PrettyQrDecorationImagePosition.embedded,
                              scale: 0.3,
                            ),
                            // image: AssetImage('assets/logo.png'),
                            // imageSize: Size(40, 40),
                          ),
                        ),
                      ),
                      SizedBox(width: 2,),

                      // NUME AUTOR
                      RotatedBox(
                        quarterTurns: 3,
                        child: SizedBox(
                          width: 100,
                          child: Text(eticheta.autor.toUpperCase(), softWrap: true, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),))),

                      SizedBox(width: 20,),

                      // QR code 2
                      SizedBox(
                        height: 90,
                        width: 90,
                        child: PrettyQrView(
                          qrImage: QrImage(QrCode.fromData(data: "www.google.com ${Random().nextInt(5000)}", errorCorrectLevel: QrErrorCorrectLevel.H),),
                          decoration: const PrettyQrDecoration(
                            background: Colors.transparent,
                            shape: const PrettyQrDotsSymbol(
                              color: Colors.black,
                            ),
                            quietZone: const PrettyQrQuietZone.modules(0),
                            image: PrettyQrDecorationImage(
                              image: AssetImage('assets/insta.png'),
                              position: PrettyQrDecorationImagePosition.embedded,
                              scale: 0.3,
                            ),
                            // image: AssetImage('assets/logo.png'),
                            // imageSize: Size(40, 40),
                          ),
                        ),
                      ),
                      SizedBox(width: 2,),
                      // GALLERY
                      RotatedBox(
                        quarterTurns: 3,
                        child: SizedBox(
                          width: 100,
                          child: Text('SAFITICUMINTI GALLERY', softWrap: true, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),))),
                    ],
                  ),
                )
              ],
            ),
          ),

          // // VERTICAL SEPARATOR
          // Container(
          //   margin: EdgeInsets.only(right: 20),
          //   height: 260,
          //   width: 1,
          //   color: Colors.black26,
          // ),

          // Col Descriere
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border( left: BorderSide( width: 1.0, color: Colors.black45, ), )
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
                child: Flexible(child: Text(eticheta.description, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200),)),
              ),
            ),
          ),
        ],
      ),
    );
  }

}