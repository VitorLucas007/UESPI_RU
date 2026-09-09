import 'package:flutter/material.dart';

class SplashViewModel extends ChangeNotifier {
  Future<void> inicializar(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}
