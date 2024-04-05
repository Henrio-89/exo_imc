import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:oexchage/NextPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String uri_animation = "https://lottie.host/398c1900-2568-4fa2-8512-c3dc29adad24/IOAbg91cIU.json";

  @override
  void initState() {
    super.initState();
    // Attendre 10 secondes puis naviguer vers la page suivante
    Future.delayed(const Duration(seconds: 10), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => NextPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              uri_animation,
              width: 400, // Ajustez la largeur de l'animation selon vos besoins
              height:
                  400, // Ajustez la hauteur de l'animation selon vos besoins
            ),
            const SizedBox(height: 20),
            const Text(
              'Chargement...',
              style: TextStyle(fontSize: 20),
            ),
            Lottie.network("https://lottie.host/09998de7-81e3-4ce9-8cdf-924ee9564ef3/rmMPzrCzMj.json",width: 200,height: 100)
          ],
        ),
      ),
    );
  }
}
