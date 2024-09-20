import 'package:flutter/material.dart';
import 'package:image_gallary_app/screens/main_page.dart';

import 'package:image_gallary_app/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'image_gallary_app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) =>
            SplashScreen(), // Ensure SplashScreen is correctly imported and defined
        '/main_page': (context) => MainPage(),
      },
    );
  }
}
