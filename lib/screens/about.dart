import 'package:flutter/material.dart';
import 'package:myapp/colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: Container(), // Remove back button
        title: const Text(
          "A propos",
          style: TextStyle(
              fontSize: 20, color: Colors.white), // Center and white text
        ),
        centerTitle: true, // Center the title
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            // Contenu de la page A propos
            Text(
              "Page A propos",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
