import 'package:flutter/material.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToMain();
  }

  Future<void> _navigateToMain() async {
    await Future.delayed(const Duration(seconds: 4));
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/cafe.png',
              width: 150,
              height: 150,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.local_cafe, size: 120, color: Colors.blue),
            ),
            const SizedBox(height: 16),
            const Text(
              'Warung IS',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Selamat datang!'),
          ],
        ),
      ),
    );
  }
}
