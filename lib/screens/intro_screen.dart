// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:smartvestment/screens/signin_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward().whenComplete(() {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: FadeTransition(
        opacity: _animation,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo1.png',
                    height: 100,
                    width: 100,
                    color: const Color.fromARGB(255, 41, 27, 4),
                  ),
                  const SizedBox(height: 50), // ✅ مسافة بين اللوجو واللودر
                  const CircularProgressIndicator(
                    // ✅ لودر متحرك
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(255, 85, 55, 8), // ✅ نفس لون النصوص
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(
              bottom: 30,
              left: 30,
              right: 30,
              child: Column(
                children: [
                  Text(
                    'Powered By',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Color.fromARGB(255, 85, 55, 8),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'BEYOND INVESTMENTS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 85, 55, 8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
