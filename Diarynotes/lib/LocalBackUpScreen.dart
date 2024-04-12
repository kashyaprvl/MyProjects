import 'package:diarynotes/Data_Manager/ZipFile.dart';
import 'package:diarynotes/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LocalBackupScreen extends StatefulWidget {
  const LocalBackupScreen({super.key});

  @override
  State<LocalBackupScreen> createState() => _LocalBackupScreenState();
}

class _LocalBackupScreenState extends State<LocalBackupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brightBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              splashRadius: 0.001,
              alignment: Alignment.centerLeft,
              iconSize: 30,
              padding: EdgeInsets.only(left: 15,top: 20),
              onPressed: () {
                Navigator.pop(context);
              },
              icon:  const Icon(Icons.arrow_back,),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 14,vertical: 23),
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                // border: Border.all(width: 1)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 28.0),
                    child: const Text("Local backup",style: TextStyle(fontSize: 20),),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    minLeadingWidth: 26,
                    leading: const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Icon(Icons.backup_outlined,size: 26),
                    ),
                    title:  Text("Local backup notes",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300)),
                    subtitle: Text("Backup your diary to phone storage offline",style: TextStyle(fontSize: 12,)),
                    onTap: () {
                        showDialog(
                         context: context,
                         builder: (context) {
                          return AlertDialog(
                            insetPadding: EdgeInsets.symmetric(vertical: 300,horizontal: 45),
                            contentPadding: EdgeInsets.zero,
                            backgroundColor: lightBackgroundColor,
                            shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            title: Center(child: Text("Backup data",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800,))),
                            content: Center(child: Text("confirm local backup?",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w100),)),
                            actionsAlignment: MainAxisAlignment.spaceEvenly,
                            actions: [
                              SizedBox(
                                height: 7.h,
                                width: 25.w,
                                child: TextButton(
                                  child: Text("Later",style: TextStyle(fontSize: 19,)),
                                  clipBehavior: Clip.antiAlias,
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),side: BorderSide(color: brightBackgroundColor,width: 1))
                                  ),
                                  onPressed: () {
                                     Navigator.pop(context);
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 7.h,
                                width: 28.w,
                                child: TextButton(
                                  clipBehavior: Clip.antiAlias,
                                  style: TextButton.styleFrom(
                                      backgroundColor: brightBackgroundColor,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),side: BorderSide(color: brightBackgroundColor,width: 1))
                                  ),
                                  onPressed: () async{
                                    setState(() {});
                                      String filePath = await ZipFile().storeDataToZipFile(context);
                                       Fluttertoast.showToast(
                                         msg: filePath,
                                         backgroundColor: lightBackgroundColor
                                       );
                                  },
                                  child: Center(child: Text("Backup now",textAlign: TextAlign.center,style: TextStyle(fontSize: 19))),
                                ),
                              )
                            ],
                          );
                       },);
                  },),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    minLeadingWidth: 26,
                    leading: const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Icon(Icons.restore_page_outlined,size: 26),
                    ),
                    title:  Text("Restore notes from local",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300)),
                    subtitle:  Text("You do not have any local backup yet",style: TextStyle(fontSize: 12,)),
                    onTap: () {
                        Navigator.pushNamed(context, "/restoreZipFileScreen");
                  },),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
