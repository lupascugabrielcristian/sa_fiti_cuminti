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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(eticheta.autor.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(eticheta.titlu),
                      Text(eticheta.marime),
                      Text(eticheta.an),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  width: 250,
                  height: 1,
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
                          qrImage: QrImage(QrCode.fromData(data: "www.google.com", errorCorrectLevel: QrErrorCorrectLevel.H),),
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
                      RotatedBox(
                        quarterTurns: 3,
                          child: Text(eticheta.autor.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),)),

                      SizedBox(width: 20,),

                      // QR code 2
                      SizedBox(
                        height: 90,
                        width: 90,
                        child: PrettyQrView(
                          qrImage: QrImage(QrCode.fromData(data: "www.google.com", errorCorrectLevel: QrErrorCorrectLevel.H),),
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
                      RotatedBox(
                          quarterTurns: 3,
                          child: Text(eticheta.autor.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),)),
                    ],
                  ),
                )
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(right: 20),
            height: 300,
            width: 1,
            color: Colors.black26,
          ),

          // Col Descriere
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Flexible(child: Text(eticheta.description, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200),)),
            ),
          ),
        ],
      ),
    );
  }

}