import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:sa_fiti_cuminti/form.dart';

class EtichetaWidget extends StatelessWidget {
  const EtichetaWidget({super.key, required this.eticheta});

  final Eticheta eticheta;
  final double ETICHETA_HEIGHT = 270;
  final double ETICHETA_COL1_WIDTH = 350;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // SA FITI CUMINTI LOGO
        Positioned(
          right: 20,
          bottom: 20,
          child: Image.asset('assets/safiticuminti.jpeg', width: 60,),
        ),
        
        // ETICHETA PROPRIUZISA
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1.0, color: Colors.black26),
          ),


          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Col 1
              LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),

                          SizedBox(
                            width: 300,
                            child: Text(eticheta.autor.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold), softWrap: true,)
                          ),

                          SizedBox(height: 10,),

                          Text(eticheta.titlu),
                          Text(eticheta.marime),
                          Text(eticheta.an),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      height: 1,
                      width: ETICHETA_COL1_WIDTH,
                      color: Colors.black26,
                    ),

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

                          SizedBox(width: 40,),

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
                  ],);
                },
              ),

              Container(
                color: Colors.black26,
                width: 1,
                height: ETICHETA_HEIGHT,
              ),

              // Col Descriere
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20.0),
                    child: Text(eticheta.description, textAlign: TextAlign.justify, style: TextStyle(fontFamily: 'DarkerGrotesque', fontSize: 14, fontWeight: FontWeight.w200, letterSpacing: 0,),)
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}