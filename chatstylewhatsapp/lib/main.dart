import 'package:flutter/material.dart';
import 'package:chatstylewhatsapp/ChatHomeScreen.dart';

import 'SplashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 51, 51, 51)),
        useMaterial3: true,
      ),

      home: SplashScreen(),
    );
  }
}

