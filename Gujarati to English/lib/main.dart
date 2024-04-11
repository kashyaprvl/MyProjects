import 'package:englishtogujarati/screens/favourite.dart';
import 'package:englishtogujarati/screens/history.dart';
import 'package:englishtogujarati/screens/homepage.dart';
import 'package:englishtogujarati/screens/splash_screen.dart';
import 'package:flutter/material.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sinhala To English',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes:{
        '/': (context)=> SplashScreen(),
       '/homepage': (context)=>  TranslationPage(),
      '/history': (context) =>  HistoryScreen(),
      '/favourite': (context) =>  FavouriteScreen(),
      },
      //home: TranslationPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}



class Decoration{
  Colors themeColor = Colors.greenAccent as Colors;
}
