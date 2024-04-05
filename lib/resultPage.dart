import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final dynamic result;

  const ResultPage({super.key, this.result});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IMC"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Résultat: ${widget.result[0]}"),
              const SizedBox(height: 8),
              Text("Poids: ${widget.result[1]} kg"),
              const SizedBox(height: 8),
              Text("Catégorie: ${widget.result[2]}"),
              const SizedBox(height: 8),
              Text("${widget.result[3]}"),
              const SizedBox(height: 8),
              Text("Conseils: ${widget.result[4]}"),
            ],
          ),
        ),
      ),
    );
  }
}
