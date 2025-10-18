import 'package:flutter/material.dart';

import 'form.dart';

class LucrariList extends StatefulWidget {
  final List<Lucrare> lucrari;
  final LucrariController controller;
  final Function() onUpdate;

  const LucrariList( {super.key, required this.lucrari, required this.controller, required this.onUpdate});

  @override
  State<LucrariList> createState() => _LucrariListState();
}

class _LucrariListState extends State<LucrariList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        Row(
          spacing: 30,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.controller.addMultiple(widget.lucrari);
                });

                widget.onUpdate();
              },
              child: Text('Select all', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),)),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.controller.removeAll();
                });
              },
              child: Text('Select none', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),)),
          ],
        ),
        Table(
          columnWidths: const {
            0: FixedColumnWidth(60),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
          },
          border: TableBorder.all(
              color: Colors.indigo.shade100,
              width: 1.0,
              style: BorderStyle.solid
          ),
          children: widget.lucrari.map((x) => _buildRow(x)).toList(),
        ),
      ],
    );
  }

  TableRow _buildRow(Lucrare l) {
    return TableRow(
        children: [
          Checkbox(value: widget.controller.contains(l), onChanged: (value) {
            if (value == true) {
              setState(() {
                widget.controller.add(l);
              });
            } else {
              setState(() {
                widget.controller.remove(l);
              });
            }
            widget.onUpdate();
          }),
          _buildDataCell(l.autor),
          _buildDataCell(l.denumire),
          _buildDataCell(l.tip)
        ]
    );
  }

  // Helper function to create a regular data cell style
  Widget _buildDataCell(String text, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      // Alternating background color for readability
      color: color ?? Colors.white,
      child: Text(
        text,
        style: TextStyle(color: Colors.grey.shade800),
      ),
    );
  }
}

class LucrariController {
  Set<Lucrare> selected = {};

  void add(Lucrare l) {
    selected.add(l);
  }

  void remove(Lucrare l) {
    selected.removeWhere((x) => x.denumire == l.denumire);
  }

  bool contains(Lucrare l) {
    return selected.any((x) => x.denumire == l.denumire);
  }

  void addMultiple(List<Lucrare> lucrari) {
    selected.addAll(lucrari);
  }

  void removeAll() {
    selected.clear();
  }

  int get size => selected.length;
}