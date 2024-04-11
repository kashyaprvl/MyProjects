import 'package:flutter/material.dart';

import '../services/AdManager.dart';
import 'homepage.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  with WidgetsBindingObserver{

  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;

  @override
  void initState() {
    super.initState();

    //Load AppOpen Ad
    appOpenAdManager.loadAd();

    WidgetsBinding.instance.addObserver(this);
    Future.delayed(const Duration(seconds: 4)).then((value) {
      appOpenAdManager.showAdIfAvailable();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const TranslationPage(),
        ),
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      isPaused = true;
    }
    if (state == AppLifecycleState.resumed && isPaused) {
      print("Resumed==========================");
      appOpenAdManager.showAdIfAvailable();
      isPaused = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(238, 249, 255, 1.0),
      ),
      child: Hero(
        tag: "logo",
        child: Image.asset("assets/images/Splash Screen.png",fit: BoxFit.fill,),
      ),
    );
  }
}
