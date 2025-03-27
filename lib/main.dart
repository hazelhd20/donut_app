import 'package:flutter/material.dart'; 
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:donut_app/pages/onboarding_screen.dart';
import 'package:donut_app/utils/constants.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configurar la barra de estado para que los iconos sean visibles sobre fondo blanco
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Hace que la barra de estado sea transparente
    statusBarIconBrightness: Brightness.dark, // Íconos en negro para contraste con fondo claro
    statusBarBrightness: Brightness.light, // Asegura visibilidad en iOS
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: appPrimaryColor),
      ),
      title: 'Donut App',
      home: OnboardingScreen(),
    );
  }
}


