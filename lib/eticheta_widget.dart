import 'package:flutter/material.dart';
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

                // QR codes
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