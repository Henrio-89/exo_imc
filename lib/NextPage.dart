import 'package:flutter/material.dart';
import 'package:oexchage/imcForm.dart';

class NextPage extends StatefulWidget {
  const NextPage({super.key});

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ImcForm(),
    );
  }
}