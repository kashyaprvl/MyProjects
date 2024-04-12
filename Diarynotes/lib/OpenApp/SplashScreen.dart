import 'dart:async';
import 'package:diarynotes/Data_Manager/ObjectBoxDataModel.dart';
import 'package:diarynotes/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Data_Manager/AppController.dart';
import '../Data_Manager/ThemeMode.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }
}

class SplashState extends State<SplashScreen> {

  String _getPin =  "";
  List<int> _getPattern = [];
  bool? diaryLockEnable;

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
        "assets/images/splashscreen.png", fit: BoxFit.contain
    );
  }

  startTime() async {
    var duration = new Duration(seconds: 1);
    return Timer(duration, route);
  }

  route() async{
    final passwordManager = objectBox.store.box<PasswordManger>();
      try{ diaryLockEnable = passwordManager.getAll().last.diaryLockSwitchOn; }
      catch(e){print(e);}
      try{_getPin = await AppController().readString("pinPassword");  print("this is get pin splash after screen $_getPin");}
      catch(e){print(e);}
      try{_getPattern = await AppController().readIntList("patternPassword"); print("this is get pin splash after screen $_getPattern");}
      catch(e){print(e);}
      if(diaryLockEnable == true){
        if(_getPin.isNotEmpty || _getPattern.isNotEmpty) {
          print("this is paswword screen navigate");
          Navigator.pushNamed(context, "/passwordCheckScreen");
        }
      }else{
        try{
        final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
        lightBackgroundColor = await AppController().loadBackgroundLightColorScreenTheme(indexOfTheme);
        floatingActionButtonColor = await AppController().navigatorFloatingActionButtonColor(indexOfTheme);
        // Color(0xff89c2a7) and Color(0xff345966) and Color(0xff89c2a7)
        backgroundImage = AppController().loadBackgroundImageTheme(indexOfTheme);
        brightBackgroundColor = await AppController().loadBackgroundBrightColorScreenTheme(indexOfTheme);
        // print("this is the Color of $brightBackgroundColor and $lightBackgroundColor and $floatingActionButtonColor");
        if (!(indexOfTheme == 1 || indexOfTheme == 2 || indexOfTheme == 6)) {
          await themeNotifier.darkTheme();
          isDarkMode = true;
        }   else {
           await themeNotifier.lightTheme();
           isDarkMode = false;
        }
        Navigator.pushNamed(context,"/MultiPageView");
        }catch(e){
          Navigator.pushNamed(context, "/chooseTheme");
        }
      }
  }

}