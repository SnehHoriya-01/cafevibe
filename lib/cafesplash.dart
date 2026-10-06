import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cafevibe/cafelogin.dart';
import "package:lottie/lottie.dart";
import 'dart:async';

class CafeSplash extends StatefulWidget {
  const CafeSplash({super.key});

  @override
  State<CafeSplash> createState() => _CafeSplashState();
}

class _CafeSplashState extends State<CafeSplash> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 4),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CafeLogin()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4E342E), // Deep Coffee Brown
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/coffeebean.json", height: 250, width: 250),
            const SizedBox(height: 20),
            const Text(
              "CaféVibe",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFEFEBE9),
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Your daily dose of joy.",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Color(0xFFD7CCC8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
