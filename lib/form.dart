// Ce contine o eticheta
class Eticheta {
  final String autor;
  final String titlu;
  final String marime;
  final String an = "2025";
  final String description;
  final String tip;
  final int pret;
  final String pretUnit;

  const Eticheta({required this.autor, required this.titlu, required this.marime, required this.description, required this.tip, required this.pret, required this.pretUnit, });

  factory Eticheta.fromLucrare(Lucrare lucrare) {

    final (pret, unit) = _extractPret(lucrare.pret);

    return Eticheta(
      autor: lucrare.autor,
      titlu: lucrare.denumire,
      marime: lucrare.dimensiune,
      description: 'Săfițicuminți implică artă live, expoziții, galerie și street art. Multă diversitate, energie creativă și drive social. Vrem să provocăm societatea să își trezească în fiecare zi la viață creativitatea; și ce alt mod mai bun de a face asta, dacă nu prin produsele care ne îmbracă și arta care ne înconjoară?',
      tip: lucrare.tip,
      pret: pret,
      pretUnit: unit
    );
  }

  static (int, String) _extractPret(String pretString) {
    final parts = pretString.split(' ');
    if (parts.length >= 2) {
      final p = int.tryParse(parts[0]);
      if (p != null) {
        String pU = parts[1].toUpperCase();
        if (pU.trim().toLowerCase() == 'e') {
          pU = 'EUR';
        } else if (pretString.toLowerCase().trim().contains('de lei')) {
          pU = 'RON';
        }

        return (p, pU);
      }
    }

    return (0, '');
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