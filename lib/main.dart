// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:madridmug_flutter/pages/counter_page.dart';
import 'package:madridmug_flutter/pages/menu_page.dart';
import 'package:madridmug_flutter/pages/todo_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:madridmug_flutter/pages/welcome_page.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:madridmug_flutter/pages/login_screen.dart';

Future<void> test() async {
  final logger = Logger();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user != null) {
      print(user.uid);
      logger.d(user.uid);
    } else {
      logger.d("No hay usuario actual");
    }
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await test();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data != null) {
              return MenuPage(); // Usuario está logueado
            }
            return WelcomePage(); // Usuario no está logueado
          }
          return CircularProgressIndicator(); // Esperando conexión
        },
      ),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: const Color(0xffFBE287),
          onPrimary: Colors.yellow.shade200,
          secondary: Colors.black,
          onSecondary: const Color.fromARGB(221, 69, 69, 69),
          error: Colors.red,
          onError: Colors.red.shade200,
          background: Color(0xFFFFF9EF),
          onBackground: Color.fromARGB(255, 130, 106, 35),
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        primarySwatch: Colors.yellow,
        primaryColor: Colors.yellow,
      ),
    );
  }
}
