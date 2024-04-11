import 'dart:async';

import 'package:englishtogujarati/controllers/AppController.dart';
import 'package:englishtogujarati/screens/history.dart';
import 'package:englishtogujarati/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:in_app_review/in_app_review.dart';
import '../controllers/styles.dart';
import 'favourite.dart';

class TranslationAppDrawer extends StatelessWidget {

  final InAppReview inAppReview = InAppReview.instance;
  final FocusNode titleFocus ;

  TranslationAppDrawer({required this.titleFocus});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0.8, 1),
              colors: <Color>[
                Color.fromRGBO(0, 183, 255, 1),
                Color.fromRGBO(0, 108, 255, 0.7),
              ], // Gradient
            )),
        child: ListView(
          children: [
            DrawerHeader(
              child: Row(
                children: const [
                  CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 23,
                      backgroundImage: AssetImage(
                        'assets/images/Translatorlogo.png',
                      )),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Gujarati to English",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
              // decoration:
              //     BoxDecoration(color: Styles.tileColor1)
            ),
            ListTile(
              title: const Text("Favourite",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              onTap: () {
                Scaffold.of(context).openEndDrawer();
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FavouriteScreen()),
                ).whenComplete(() =>titleFocus.unfocus());
              },
              leading: const Icon(Icons.favorite, color: Color.fromRGBO(255, 255, 255, 1),),
            ),
            ListTile(
              title: const Text("History",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              onTap: () {

                Scaffold.of(context).openEndDrawer();
                Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryScreen()),).whenComplete(() => titleFocus.unfocus());
              },
              leading: const Icon(Icons.history, color: Color.fromRGBO(255, 255, 255, 1)),
            ),
            ListTile(
              title: const Text("Share App Link",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              onTap: (){
                _shareApp();
                },
              leading: const Icon(Icons.share, color: Color.fromRGBO(255, 255, 255, 1)),
            ),
            ListTile(
              title: const Text("Rate Us!",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              onTap: () {
                _rateApp();
              },
              leading: const Icon(Icons.thumb_up, color: Color.fromRGBO(255, 255, 255, 1)),
            ),
          ],
        ),
      ),
    );
  }

  _shareApp() async {
    await Share.share(
        "I Just found a Sinhala To English Translate! Check this out on \n" +
            "https://play.google.com/store/apps/details?id=com.transmission.sinhalatoenglishtranslator");
  }

  _rateApp() async {
    inAppReview.openStoreListing();
  }

}