import 'package:diarynotes/CalenderScreen.dart';
import 'package:diarynotes/HomeScreenWithFile.dart';
import 'package:diarynotes/SettingScreen.dart';
import 'package:diarynotes/StatisticsScreen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../main.dart';
import 'CommonWidget.dart';

class MultiPageView extends StatefulWidget {
  @override
  _MultiPageViewState createState() => _MultiPageViewState();
}

class _MultiPageViewState extends State<MultiPageView> {
  PageController pageController = PageController();
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BottomAppBarCreate().floatingActionButton(context),
      backgroundColor: brightBackgroundColor,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 4.0,
        height: 7.5.h,
        color: lightBackgroundColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                  icon:  ImageIcon(currentPageIndex == 0 ? const AssetImage("assets/images/NoteIconWithColor.png") : const AssetImage("assets/images/NoteIcon.png"),size: 0.37.inches,color: currentPageIndex == 0 ?  brightBackgroundColor : null),
                  onPressed: () =>
                      pageController.animateToPage(0, duration: Duration(milliseconds: 100), curve: Curves.fastEaseInToSlowEaseOut)/*jumpToPage(0)*/
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 35.0),
              child: IconButton(
                  icon: ImageIcon( currentPageIndex == 1 ? const AssetImage("assets/images/CalenderIconWithColor.png")  : const AssetImage("assets/images/CalenderIcon.png"),size: 0.37.inches, color:currentPageIndex == 1 ?  brightBackgroundColor : null),
                  onPressed: () =>
                      pageController.animateToPage(1, duration: Duration(milliseconds: 100), curve: Curves.fastEaseInToSlowEaseOut)
              ),
            ), Padding(
              padding: const EdgeInsets.only(left: 35.0),
              child: IconButton(
                  icon: ImageIcon(currentPageIndex == 2 ? const AssetImage("assets/images/StatisticsIconWithColor.png") :const AssetImage("assets/images/StatisticsIcon.png"),size: 0.37.inches,color: currentPageIndex == 2 ?  brightBackgroundColor : null),
                  onPressed: () =>
                      pageController.animateToPage(2, duration:Duration(milliseconds: 100), curve: Curves.fastEaseInToSlowEaseOut)
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right : 8.0),
              child: IconButton(
                  icon: ImageIcon(currentPageIndex == 3 ? const AssetImage("assets/images/SettingIconWithColor.png") : const AssetImage("assets/images/SettingIcon.png"),size: 0.37.inches,color: currentPageIndex == 3 ? brightBackgroundColor : null),
                  onPressed: () =>
                      pageController.animateToPage(3, duration: Duration(milliseconds: 100), curve: Curves.fastEaseInToSlowEaseOut)
              ),
            ),
          ],
        ),
      ),
      body : PageView.builder(
                controller: pageController,
                // allowImplicitScrolling: true,
                onPageChanged: (index) {
                  setState(() {
                    currentPageIndex = index;
                  });
                },
               physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  // Build your content dynamically based on the current index
                  return buildPageContent(index);
                },
                itemCount: 4,
      ),
    );
  }

  Widget buildPageContent(int index) {
    switch (index) {
      case 0:
        return FileHomeScreen();
      case 1:
        return CalenderScreen();
      case 2:
        return StatisticsScreen();
      case 3:
        return SettingScreen();
      default:
        return Container(); // Return an empty container for unsupported index
    }
  }
}

