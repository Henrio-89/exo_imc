import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImcForm extends StatefulWidget {
  const ImcForm({super.key});

  @override
  State<ImcForm> createState() => _ImcFormState();
}

class _ImcFormState extends State<ImcForm> {
  final _formKey = GlobalKey<FormState>();
  final _taillsController = TextEditingController();
  final _poidsController = TextEditingController();
  String? sexeSelected;

  // String result = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Healthy BMI: Calcul d'Indice de Masse Corporelle"),
      ),
      body: Container(
        // decoration: BoxDecoration(),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _taillsController,
                  decoration: const InputDecoration(
                    label: Text("Taille *"),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Taille est requis";
                    }
                    return null;
                  },
                ),
                SizedBox(width:10,height: 10),
                TextFormField(
                  controller: _poidsController,
                  decoration: const InputDecoration(
                    label: Text("Poids *"),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Poids est requis";
                    }
                    return null;
                  },
                ),
                SizedBox(width:10,height: 10),
                DropdownButtonFormField(
                  value: sexeSelected,
                  onChanged: (newValue) {
                    setState(() {
                      sexeSelected = newValue;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: "Masculin",
                      child: Text("Masculin"),
                    ),
                    DropdownMenuItem(
                      value: "Féminin",
                      child: Text("Féminin"),
                    ),
                  ],
                  decoration: const InputDecoration(
                    labelText: "Sexe", // Libellé du champ
                    border: OutlineInputBorder(), // Style de bordure
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      calcul();
                    }
                  },
                  color: Colors.blue,
                  child: const Text(
                    "Valide",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double calculerIMC(double poids, double taille, String sexe) {
    // Vérifier si la taille est en mètres
    if (taille > 10) {
      taille /= 100; // Conversion de centimètres en mètres
    }

    // Calcul de l'IMC en fonction du sexe
    double imc;
    if (sexe == "Masculin") {
      imc = poids / (taille * taille);
    } else if (sexe == "Féminin") {
      imc = poids / (taille * taille) * 1.1; // ajustement pour les femmes
    } else {
      throw Exception(
          "Sexe non reconnu. Veuillez spécifier 'homme' ou 'femme'.");
    }

    return imc;
  }

  void calcul() {
    //FORMULE
    double poids = double.parse(_poidsController.text);
    double taille = double.parse(_taillsController.text);
    String sexe = sexeSelected.toString();

    double result = calculerIMC(poids, taille, sexe);
    String formattedResult =
        result.toStringAsFixed(2); // Arrondir le résultat à deux décimales

    String category;
    String advice;
    String poidsIdealText = "";

    double poidsIdeal;
    if (sexe == "Masculin") {
      poidsIdeal = taille - 100 - ((taille - 150) / 4);
    } else if (sexe == "Féminin") {
      poidsIdeal = taille - 100 - ((taille - 150) / 2.5);
    } else {
      throw Exception(
          "Sexe non reconnu. Veuillez spécifier 'homme' ou 'femme'.");
    }
    poidsIdealText =
        "Poids idéal pour la taille: ${poidsIdeal.toStringAsFixed(1)} kg";
    if (result < 18.5) {
      category = "Sous-poids";
      advice =
          "Il est important de consulter un professionnel de la santé pour évaluer votre alimentation et votre état nutritionnel.";
    } else if (result >= 18.5 && result < 25) {
      category = "Poids normal";
      advice =
          "Maintenez un mode de vie sain en pratiquant une activité physique régulière et en adoptant une alimentation équilibrée.";
    } else if (result >= 25 && result < 30) {
      category = "Surpoids";
      advice =
          "Considérez des changements dans votre mode de vie, comme une alimentation plus équilibrée et une augmentation de l'activité physique.";
    } else {
      category = "Obésité";
      advice =
          "Consultez un professionnel de la santé pour obtenir des conseils personnalisés sur la gestion du poids et la santé générale.";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Résultat: $formattedResult"),
            SizedBox(height: 8),
            Text("Poids: $poids kg"), // Afficher le poids de la personne
            SizedBox(height: 8),
            Text("Catégorie: $category"),
            SizedBox(height: 8),
            if (poidsIdealText.isNotEmpty) Text(poidsIdealText),
            SizedBox(height: 8),
            Text("Conseils: $advice"),
          ],
        ),
      ),
    );
  }
}
