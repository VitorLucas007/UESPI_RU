import 'package:flutter/material.dart';
import 'views/splash/splash_page.dart';
import 'views/home/home_page.dart';
import 'views/details/cardapio_details_page.dart';
import 'views/notifications/notification_page.dart';
import 'views/location/location_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RuUespiApp());
}

class RuUespiApp extends StatelessWidget {
  const RuUespiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RU UESPI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF003366),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF003366),
          primary: const Color(0xFF003366),
          secondary: const Color(0xFFFFB300),
          surface: const Color(0xFFF7F9FC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        fontFamily: 'Roboto',
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashPage(),
        '/home': (context) => const HomePage(),
        '/details': (context) => const CardapioDetailsPage(),
        '/notifications': (context) => const NotificationPage(),
        '/location': (context) => const LocationPage(),
      },
    );
  }
}
