import 'dart:ui';
import 'package:diarynotes/Data_Manager/Constant.dart';
import 'package:diarynotes/Data_Manager/ObjectBoxDataModel.dart';
import 'package:diarynotes/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:card_swiper/card_swiper.dart';

import '../Data_Manager/AppController.dart';
import '../Data_Manager/ThemeMode.dart';

class ChooseTheme extends StatefulWidget {
  const ChooseTheme({super.key});

  @override
  State<ChooseTheme> createState() => _ChooseThemeState();
}

class _ChooseThemeState extends State<ChooseTheme> {
  int selectedIndex = 0;

  late Future<void> updateDataFuture;

  Future<void> updateData(int index) async {
    try {
      brightBackgroundColor = await AppController()
          .loadBackgroundBrightColorScreenTheme(index);
      lightBackgroundColor = await AppController()
          .loadBackgroundLightColorScreenTheme(index);
    } catch (e) {}

    backgroundImage =
        await AppController().loadBackgroundImageTheme(index);
  }

  @override
  void initState() {
    super.initState();
    updateDataFuture = updateData(selectedIndex);
    floatingActionButtonColor = const Color.fromARGB(255, 182, 77, 96);
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: floatingActionButtonColor,
        child: const Icon(Icons.navigate_next),
        onPressed: () async {
          await updateData(selectedIndex);
          print("this is the Color of $brightBackgroundColor and $lightBackgroundColor and $floatingActionButtonColor");
          if (kDebugMode) {
            print("this is selected Index $selectedIndex");
          }
          if (!(selectedIndex == 1 || selectedIndex == 2 || selectedIndex == 6)) {
            isDarkMode = true;
            ThemeData theme = ThemeData.dark().copyWith(
              textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(primary: Colors.white)),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: brightBackgroundColor),
              bottomSheetTheme: const BottomSheetThemeData(
                backgroundColor: Colors.transparent,), datePickerTheme: DatePickerThemeData(
                backgroundColor: brightBackgroundColor,
                headerBackgroundColor: brightBackgroundColor,
                todayBackgroundColor: MaterialStatePropertyAll(
                    lightBackgroundColor),
                dayStyle: const TextStyle(color: Colors.white,)),);
            themeNotifier.setTheme(theme);
          } else {
            ThemeData themeData = ThemeData(
                textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(primary: Colors.black)),
                bottomSheetTheme: const BottomSheetThemeData(
                  backgroundColor: Colors.transparent,),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: brightBackgroundColor),
                datePickerTheme: DatePickerThemeData(
                    backgroundColor: brightBackgroundColor,
                    headerBackgroundColor: brightBackgroundColor,
                    todayBackgroundColor: MaterialStatePropertyAll(
                        lightBackgroundColor),
                    dayStyle: TextStyle(color: Colors.black,)));
            themeNotifier.setTheme(themeData);
            isDarkMode = false;
          }

          Future.delayed(const Duration(milliseconds: 300));
          // if (ActiveScreenTracker().currentRoute == "/FileScreen") {
            Navigator.pushNamed(context, "/MultiPageView");
          // } else {
          //   ActiveScreenTracker().navigateTo(context, "/FileScreen");
          // }
        },
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: updateDataFuture,
          builder: (context, snapshot) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage(constant.themeImages[selectedIndex]),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 40),
                          child: Text(
                            "Choose a theme that you prefer !",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Container(
                        height: 400,
                        padding: const EdgeInsets.all(18.0),
                        child: Swiper(
                          viewportFraction: 0.9,
                          curve: Curves.bounceInOut,
                          indicatorLayout: PageIndicatorLayout.COLOR,
                          allowImplicitScrolling: true,
                          control: SwiperPagination.rect,
                          layout: SwiperLayout.DEFAULT,
                          transformer:
                              ScaleAndFadeTransformer(scale: 0.6, fade: 0.3),
                          itemCount: constant.themeImages.length,
                          index: selectedIndex,
                          // customLayoutOption: CustomLayoutOption(startIndex: startIndex),
                          onIndexChanged: (index) async {
                            setState(() {
                              selectedIndex = index;
                              indexOfTheme = index;
                            });
                            floatingActionButtonColor = await AppController()
                                .navigatorFloatingActionButtonColor(selectedIndex);
                            ThemeSet ts = ThemeSet(selectedTheme: index);
                            themeManager.put(ts);
                          },
                          itemBuilder: (context, index) {
                            return Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              child: Image.asset(
                                constant.themeImages[index],
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
