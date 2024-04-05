import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:imc/resultPage.dart';

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
        title: const Text("Calcul d'Indice de Masse Corporelle"),
      ),
      body: Container(
        // decoration: BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _taillsController,
                  decoration: const InputDecoration(
                    label: Text("Taille (cm)*"),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Taille est requis";
                    }
                    // Vérifier si la valeur est un nombre entier positif
                    if (int.tryParse(value) == null || int.parse(value) < 0) {
                      return "Taille doit être un nombre entier positif";
                    }
                    // Vérifier si la taille est inférieure à 10
                    if (int.parse(value) <= 50) {
                      return "La taille doit être supérieure ou égale à 50 cm";
                    }
                    return null;
                  },
                ),
                const SizedBox(width: 10, height: 10),
                TextFormField(
                  controller: _poidsController,
                  decoration: const InputDecoration(
                    label: Text("Poids (kg)*"),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Poids est requis";
                    }
                    if (int.tryParse(value) == null || int.parse(value) < 0) {
                      return "Taille doit être un nombre entier positif et supérieure ou égale à 1 kg";
                    }
                    return null;
                  },
                ),
                const SizedBox(width: 10, height: 10),
                DropdownButtonFormField(
                  value: sexeSelected,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez sélectionner un sexe";
                    }
                    return null;
                  },
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
                    labelText: "Sexe *", // Libellé du champ
                    border: OutlineInputBorder(), // Style de bordure
                  ),
                ),
                Row(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          calcul();
                        }
                      },
                      color: Colors.blue,
                      child: const Text(
                        "Dialog result",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 4),
                    MaterialButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          redirectToResultPage();
                        }
                      },
                      color: const Color.fromARGB(255, 23, 58, 87),
                      child: const Text(
                        "New page result",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void redirectToResultPage() {
    var result = calculPageResult();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ResultPage(result: result)));
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
    double poids = double.parse(_poidsController.text);
    double taille = double.parse(_taillsController.text);
    String sexe = sexeSelected.toString();

    double imc = calculerIMC(poids, taille, sexe);
    List<dynamic> result = calculerResultats(imc, poids, taille, sexe);
    afficherResultatSnackbar(result);
  }

  List<dynamic> calculPageResult() {
    double poids = double.parse(_poidsController.text);
    double taille = double.parse(_taillsController.text);
    String sexe = sexeSelected.toString();

    double imc = calculerIMC(poids, taille, sexe);
    return calculerResultats(imc, poids, taille, sexe);
  }

  List<dynamic> calculerResultats(
      double imc, double poids, double taille, String sexe) {
    String formattedResult = imc.toStringAsFixed(2);

    double poidsIdeal;
    String category;
    String advice;
    String poidsIdealText = "";

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

    if (imc < 18.5) {
      category = "Sous-poids";
      advice =
          "Il est important de consulter un professionnel de la santé pour évaluer votre alimentation et votre état nutritionnel.";
    } else if (imc < 25) {
      category = "Poids normal";
      advice =
          "Maintenez un mode de vie sain en pratiquant une activité physique régulière et en adoptant une alimentation équilibrée.";
    } else if (imc < 30) {
      category = "Surpoids";
      advice =
          "Considérez des changements dans votre mode de vie, comme une alimentation plus équilibrée et une augmentation de l'activité physique.";
    } else {
      category = "Obésité";
      advice =
          "Consultez un professionnel de la santé pour obtenir des conseils personnalisés sur la gestion du poids et la santé générale.";
    }

    return [formattedResult, poids, category, poidsIdealText, advice];
  }

  void afficherResultatSnackbar(List<dynamic> result) {
    String formattedResult = result[0];
    double poids = result[1];
    String category = result[2];
    String poidsIdealText = result[3];
    String advice = result[4];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Résultat: $formattedResult"),
            const SizedBox(height: 8),
            Text("Poids: $poids kg"), // Afficher le poids de la personne
            const SizedBox(height: 8),
            Text("Catégorie: $category"),
            const SizedBox(height: 8),
            if (poidsIdealText.isNotEmpty) Text(poidsIdealText),
            const SizedBox(height: 8),
            Text("Conseils: $advice"),
          ],
        ),
      ),
    );
  }
}
