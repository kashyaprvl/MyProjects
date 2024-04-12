
import 'package:diarynotes/Data_Manager/Constant.dart';
import 'package:provider/provider.dart';
import 'package:diarynotes/main.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';

import 'Data_Manager/CommonWidget.dart';
import 'Data_Manager/ThemeMode.dart';

class SettingScreen extends StatefulWidget {


   const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> with WidgetsBindingObserver{

  String googleSearchUrl = "https://www.google.com/search?q=${Uri.encodeComponent("https://play.google.com/store/apps/details?id=diary.journal.mood.tracker.secretdiary.diarywithlock")}";

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    themeNotifier.notifyListeners();
    print('Platform brightness changed!');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: brightBackgroundColor,
        // bottomNavigationBar: BottomAppBarCreate().bottomNavigationBar(context),
        // floatingActionButton: BottomAppBarCreate().floatingActionButton(context,),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 14,right: 10,left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text("Setting",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 18,right:  18,top : 20,bottom: 0),
                    padding:  const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: lightBackgroundColor,
                    ),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                           Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset("assets/images/paintBrush.png",fit: BoxFit.cover,color: isDarkMode ? Colors.white : Colors.black,scale: 1.7),
                            const Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Text("Theme",style: TextStyle(fontSize: 18),),
                            )
                          ],
                          ),
                        Container(
                          height: 15.h,
                          padding: const EdgeInsets.only(left: 15,right: 15,top: 4),
                          child: ListView.builder(
                            itemCount: constant.themeImages.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                               return GestureDetector(
                                 onTap: () {
                                   Navigator.pushNamed(context, "/chooseTheme");
                                 },
                                 child: Container(
                                   height: 8.h,
                                   width: 24.w,
                                   padding: const EdgeInsets.only(right: 5),
                                   child: ClipRRect(borderRadius: BorderRadius.circular(10),child: Image.asset(constant.themeImages[index],fit: BoxFit.cover)),
                                 ),
                               );
                            },
                          ),
                        ),
                        ])
                    ),
                        Container(
                          margin: const EdgeInsets.only(left: 18,right:  18,top : 15,bottom: 5),
                          padding:  const EdgeInsets.only(right: 18,left : 0,top : 0,bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: lightBackgroundColor,
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 20),
                                margin: EdgeInsets.only(top: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                   const Padding(
                                     padding: EdgeInsets.only(bottom: 4.0),
                                     child: Text("Setting",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400)),
                                   ),
                                   ListTile(leading: Image.asset("assets/images/password.png",fit: BoxFit.cover,color: isDarkMode ? Colors.white : Colors.black,scale: 1.9),minLeadingWidth: 30,title: Text("Password",style: TextStyle(fontSize: 12)),contentPadding: EdgeInsets.zero,onTap: () { Navigator.pushNamed(context, "/DiaryLockScreen");},),
                                   const Divider(height: 0),
                                   ListTile(leading: Image.asset("assets/images/upload.png",fit: BoxFit.cover,color: isDarkMode ? Colors.white : Colors.black,scale: 1.5),minLeadingWidth: 30,title: Text("Local backup",style: TextStyle(fontSize: 12)),contentPadding: EdgeInsets.zero,onTap: () {
                                     Navigator.pushNamed(context, "/LocalBackupScreen");
                                   },),
                                    const Divider(height: 0),
                                   ListTile(leading: Image.asset("assets/images/tag.png",fit: BoxFit.cover,color: isDarkMode ? Colors.white : Colors.black,scale: 1.7),minLeadingWidth: 30,title: Text("Tag",style: TextStyle(fontSize: 12)),contentPadding: EdgeInsets.zero,onTap: () { Navigator.pushNamed(context, "/TagScreen"); },),
                                    const Divider(height: 0),
                                    ListTile(leading: Image.asset("assets/images/dustbin.png",fit: BoxFit.cover,color: isDarkMode ? Colors.white : Colors.black,scale: 1.7),minLeadingWidth: 30,title: Text("Delete data",style: TextStyle(fontSize: 12)),contentPadding: EdgeInsets.zero,onTap: () {
                                      userBox.removeAll();
                                      setState(() {});
                                      showDialog(context: context, builder:
                                      (context) {
                                        return  AlertDialog(
                                          backgroundColor: brightBackgroundColor,
                                          title: const Text('Are you sure?'),
                                          content: const Text('Do you want to delete your all data?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: const Text('No'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                userBox.removeAll();
                                                  Navigator.pop(context);
                                              }, // <-- SEE HERE
                                              child: const Text('Yes'),
                                            ),
                                          ],
                                        );
                                      },
                                      );
                                    },),
                                    Divider(height: 0),
                                    ListTile(leading: Image.asset("assets/images/notification.png",fit: BoxFit.cover,color: isDarkMode ? Colors.white : Colors.black,scale: 1.7),minLeadingWidth: 30,title: Text("Daily Reminder",style: TextStyle(fontSize: 12)),contentPadding: EdgeInsets.zero,onTap: () { Navigator.pushNamed(context, "/NotifyScreen"); },),
                                    Divider(height: 0),
                                    ListTile(leading: Image.asset("assets/images/share.png",fit: BoxFit.cover,color: isDarkMode ? Colors.white : Colors.black,scale: 1.7),minLeadingWidth: 30,title: Text("Share With Your Friend",style: TextStyle(fontSize: 12)),contentPadding: EdgeInsets.zero,onTap: () {Share.share(googleSearchUrl);
                                    },),
                                    Divider(height: 0),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )

                      ],
                    ),
                  )
              ),
            ),
          ),
    );
  }
  Future<bool> _onWillPop() {
  Navigator.pushNamed(context, "//MultiPageView");
    return Future.value(false);
  }
}
