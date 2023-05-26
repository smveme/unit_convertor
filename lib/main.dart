import 'package:flutter/material.dart';
import 'package:units_converter/units_converter.dart';

void main() {
  runApp(const Convertisseur());
}

class Convertisseur extends StatelessWidget {
  const Convertisseur({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Convertisseur",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const UnitConverter(),
    );
  }
}

class UnitConverter extends StatefulWidget {
  const UnitConverter({super.key});

  @override
  State<UnitConverter> createState() => _UnitConverterState();
}

class _UnitConverterState extends State<UnitConverter> {
  final ValueNotifier<double> valueFrom = ValueNotifier<double>(0);
  final ValueNotifier<double> valueTo = ValueNotifier<double>(0);
  final ValueNotifier<dynamic> selectedStartUnit =
      ValueNotifier<dynamic>(MASS.grams);
  final ValueNotifier<dynamic> selectedTargetUnit =
      ValueNotifier<dynamic>(MASS.kilograms);

  final ValueNotifier<String> typeUnit = ValueNotifier<String>('Mass');

  final List<String> listTypesUnit = [
    'Mass',
    'Length',
    'Energy',
    'Area',
    'Temperature'
  ];

  List<dynamic> listUnits = [];

  void updateListUnits() {
    switch (typeUnit.value) {
      case 'Mass':
        listUnits = MASS.values.toList();
        break;
      case 'Length':
        listUnits = LENGTH.values.toList();
        break;
      case 'Energy':
        listUnits = ENERGY.values.toList();
        break;
      case 'Area':
        listUnits = AREA.values.toList();
        break;
      case 'Temperature':
        listUnits = TEMPERATURE.values.toList();
        break;
      default:
        listUnits = [];
        break;
    }
    selectedStartUnit.value = listUnits.first;
    selectedTargetUnit.value = listUnits.first;
  }

  @override
  void initState() {
    super.initState();
    updateListUnits();
  }

  @override
  void dispose() {
    valueFrom.dispose();
    valueTo.dispose();
    selectedStartUnit.dispose();
    selectedTargetUnit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Convertisseur")),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Sélection du type d'unité
            DropdownButtonFormField<String>(
              value: typeUnit.value,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
              style: const TextStyle(fontSize: 16, color: Colors.black),
              items: listTypesUnit.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                typeUnit.value = value!;
                updateListUnits();
                valueTo.value = 0;
              },
            ),
            const SizedBox(height: 8),
            // Sélection de l'unité de départ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("From:"),
                      const SizedBox(height: 4),
                      ValueListenableBuilder<dynamic>(
                        valueListenable: selectedStartUnit,
                        builder: (context, unit, _) {
                          return DropdownButtonFormField<dynamic>(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                              ),
                            ),
                            isExpanded: true,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            items: listUnits.map((unit) {
                              return DropdownMenuItem<dynamic>(
                                value: unit,
                                child: Text(unit.toString().split('.')[1]),
                              );
                            }).toList(),
                            value: unit,
                            onChanged: (value) {
                              selectedStartUnit.value = value!;
                              valueTo.value = 0;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("To:"),
                      const SizedBox(height: 4),
                      ValueListenableBuilder<dynamic>(
                        valueListenable: selectedTargetUnit,
                        builder: (context, unit, _) {
                          return DropdownButtonFormField<dynamic>(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                              ),
                            ),
                            isExpanded: true,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            items: listUnits.map((unit) {
                              return DropdownMenuItem<dynamic>(
                                value: unit,
                                child: Text(unit.toString().split('.')[1]),
                              );
                            }).toList(),
                            value: unit,
                            onChanged: (value) {
                              selectedTargetUnit.value = value!;
                              valueTo.value = 0;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: "input data"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      valueFrom.value = double.tryParse(value) ?? 0;
                      valueTo.value = 0;
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Action du bouton de conversion
                valueTo.value = valueFrom.value.convertFromTo(
                    selectedStartUnit.value, selectedTargetUnit.value)!;
              },
              icon: const Icon(Icons.swap_horiz), // Icône de conversion
              label: const Text('Convertir'),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<double>(
              valueListenable: valueTo,
              builder: (context, value, _) {
                if (value != 0) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "Result: ${valueFrom.value} ${selectedStartUnit.value.toString().split('.')[1]} = "),
                      Expanded(
                        child: Text(
                          "${value.toStringAsFixed(2)} ${selectedTargetUnit.value.toString().split('.')[1]}", // Formater le résultat avec 2 décimales
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox(height: 0);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
