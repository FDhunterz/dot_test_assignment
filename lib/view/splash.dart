import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(),
          Text('Welcome', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text('by faizal tri swanto', style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
