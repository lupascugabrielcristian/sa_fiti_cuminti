import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sa_fiti_cuminti/csv_service.dart';
import 'package:sa_fiti_cuminti/form.dart';
import 'package:sa_fiti_cuminti/lucrari_list.dart';
import 'package:sa_fiti_cuminti/pdf_service.dart';

import 'eticheta_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Generator etichete', csvService: CsvService(), pdfService: PdfService(),),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.csvService, required this.pdfService});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final CsvService csvService;
  final PdfService pdfService;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // Default eticheta
  Eticheta eticheta = Eticheta(
    autor: "Adi Piorescu",
    titlu: 'I sealed myself to find me later',
    marime: '150 X 28 cm',
    description: '''S fi icumin i implic art live, expozi ii, galerie i street art. Mult diversitate, energie creativ i drive social. Vrem s provoc m societatea s î i trezeasc în fiecare zi la via creativitatea; i ce alt mod mai bun de a face asta, dac nu prin produsele care ne îmbrac i arta care ne înconjoar ?''',
    tip: 'Tablou',
    pret: 1500,
    pretUnit: 'RON',
    instagramAutor: '',
  );

  TextEditingController priceController = TextEditingController();
  TextEditingController titluController = TextEditingController();
  LucrariController controller = LucrariController();
  List<Lucrare> lucrari = [];
  int selected = 0;
  String generateBtnText = 'Generate';

  void _generatePdf() {
    widget.pdfService.generateEtichete(controller.selected.map((x) => Eticheta.fromLucrare(x)).toList()).then(( files ) {
      setState(() {
        generateBtnText = 'Generate ${controller.size}';
      });

      _showMessageDialog(context, 'Completed', '$files generated');
    });
    // PdfSyncfusionService().generatePage(eticheta);
  }

  void _pickDefault() {
    String filePath = '/Users/lolarucker/Downloads/Artisti & lucrari STOMA - Sheet1.csv';

    widget.csvService.readCsvLucrari(filePath).then((l) {
      setState(() {
        selected = 0;
        lucrari = l;
        eticheta = Eticheta.fromLucrare(l[selected]);
      });
    });
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {

      String? filePath = result.files.single.path;
      if (filePath != null) {
        widget.csvService.readCsvLucrari(filePath).then((l) {
          print(l);
          setState(() {
            selected = 0;
            lucrari = l;
            eticheta = Eticheta.fromLucrare(l[selected]);
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SizedBox(
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // PREV & NEXT BUTTONS
                          Row(
                            children: [

                              // PREV
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    selected = selected - 1;
                                    if (selected == -1) selected = lucrari.length - 1;
                                    _updateController(lucrari[selected]);
                                    eticheta = Eticheta.fromLucrare(lucrari[selected]);
                                  });
                                },
                                icon: const Icon(Icons.arrow_back),
                              ),

                              Text('Lucrare $selected din ${lucrari.length}'),

                              // NEXT
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    selected += 1;
                                    if (selected == lucrari.length) selected = 0;
                                    _updateController(lucrari[selected]);
                                    eticheta = Eticheta.fromLucrare(lucrari[selected]);
                                  });
                                },
                                icon: const Icon(Icons.arrow_forward),
                              ),

                              // Save eticheta changes
                              GestureDetector(
                                onTap: () => _saveEtichetaChanges(lucrari[selected]),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue[400],
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                                  child: const Text( 'Save changes', style: TextStyle(color: Colors.white), ),
                                ),
                              ),
                            ],
                          ),

                          // AUTOR
                          Text('Autor: ', style: TextStyle(fontSize: 18),),
                          TextField(maxLines: 1, decoration: InputDecoration.collapsed(hintText: eticheta.autor),),

                          SizedBox(height: 10,),

                          // TITLU
                          Text('Titlu: ', style: TextStyle(fontSize: 18),),
                          TextField(
                            controller: titluController,
                            maxLines: 1, decoration: InputDecoration.collapsed(hintText: '-'),),

                          SizedBox(height: 10,),

                          // MARIME
                          Text('Marime: ', style: TextStyle(fontSize: 18),),
                          TextField(maxLines: 1, decoration: InputDecoration.collapsed(hintText: eticheta.marime),),

                          SizedBox(height: 10,),

                          // AN
                          Text('An: ', style: TextStyle(fontSize: 18),),
                          TextField(maxLines: 1, decoration: InputDecoration.collapsed(hintText: eticheta.an),),

                          SizedBox(height: 10,),

                          // PRET
                          Text('Pret: ', style: TextStyle(fontSize: 18),),
                          TextField(
                            controller: priceController,
                            maxLines: 1,
                            decoration: InputDecoration.collapsed(hintText: '-'),
                          ),

                        ],
                      )),
                  ),
                ),

                Container(
                  width: 600,
                  color: Color.fromARGB(205, 238, 238, 208),
                  child: EtichetaWidget(eticheta: eticheta)),

              ],
            ),

            SizedBox(height: 10,),

            if (lucrari.isNotEmpty) SizedBox(
              height: MediaQuery.sizeOf(context).height - 490,
              child: SingleChildScrollView(child: LucrariList(
                lucrari: lucrari,
                controller: controller,
                onUpdate: () {
                  setState(() {
                    generateBtnText = 'Generate ${controller.size}';
                  });
                },
              ))
            ),

            SizedBox(height: 10,),

            Row(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // FILE PICKER
                GestureDetector(
                  onTap: _pickDefault,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[400],
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                    child: const Text( 'Selecteaza csv', style: TextStyle(color: Colors.white), ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      generateBtnText = '...';
                    });

                    _generatePdf();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.purple[400],
                      borderRadius: const BorderRadius.all(Radius.circular(20) ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(generateBtnText, style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showMessageDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _updateController(Lucrare lucrare) {
    setState(() {
      priceController.text = lucrare.pret;
      titluController.text = lucrare.denumire;
    });
  }

  void _saveEtichetaChanges(Lucrare lucrare) {
    setState(() {
      lucrari[selected] = lucrare.copyWith(p: priceController.text, t: titluController.text);
      eticheta = Eticheta.fromLucrare(lucrari[selected]);
    });
  }
}
