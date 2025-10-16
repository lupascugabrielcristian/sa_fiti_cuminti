// Ce contine o eticheta
class Eticheta {
  final String autor;
  final String titlu;
  final String marime;
  final String an = "2025";
  final String description;
  final String tip;

  const Eticheta({required this.autor, required this.titlu, required this.marime, required this.description, required this.tip});

  factory Eticheta.fromLucrare(Lucrare lucrare) {
    return Eticheta(
        autor: lucrare.autor,
        titlu: lucrare.denumire,
        marime: lucrare.dimensiune,
        description: lucrare.descriere,
        tip: lucrare.tip
    );
  }
}

class Lucrare {
  final String autor;
  final String denumire;
  final bool collab;
  final String locatie;
  final String tip;
  final String dimensiune;
  final String descriere;
  final String pret;

  const Lucrare({required this.autor, required this.denumire, required this.collab, required this.locatie, required this.tip, required this.dimensiune, required this.descriere, required this.pret});

  Lucrare copyWith({String? d, String? p}) {
    return Lucrare(autor: autor,
        denumire: denumire,
        collab: collab,
        locatie: locatie,
        tip: tip,
        dimensiune: d ?? dimensiune,
        descriere: descriere,
        pret: p ?? pret);
  }
}