import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(100),
        child: Column(
          children: [
            Hero(
              tag: 'Ahia logo',
              child: Text(
                "Ahia",
                style: TextStyle(
                    fontFamily: 'Signatra',
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            TextField(),
            TextField(),
            TextField(),
            TextField(),
          ],
        ),
      ),
    ));
  }
}
