import 'package:flutter/material.dart'; 
import 'package:moviemeter/MainScreen.dart';
import 'LoginPage.dart'; // Import login screen
import 'RegisterPage.dart'; // Import register screen

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieMeter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login', // Start with LoginPage
      routes: {
        '/login': (context) => LoginPage(
              onLogin: (userId) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainScreen(userId: userId),
                  ),
                );
              },
            ),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
