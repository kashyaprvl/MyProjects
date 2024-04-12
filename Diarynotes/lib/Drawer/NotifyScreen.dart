import 'dart:convert';
import 'dart:io';
import 'package:diarynotes/Data_Manager/AppController.dart';
import 'package:diarynotes/main.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/services.dart';


class NotifyScreen extends StatefulWidget {
  const NotifyScreen({super.key});

  @override
  State<NotifyScreen> createState() => _NotifyScreenState();
}

class _NotifyScreenState extends State<NotifyScreen> {

  bool pinReminderNotificationSwitchOn = false;
  bool diaryReminderNotificationSwitchOn = false;
  int id = 0;
  String notificationTitle = "Write a diary now";
  int chooseIndex = 0;
  List<String> selectedDays = ["Automatically", "WorkWeekDay", "WeekEndDay""WeekDay", "Monthly",];

  
  @override
  void initState() {
    super.initState();
    checkSwitchButton();
  }

  checkSwitchButton() async{
    try{ pinReminderNotificationSwitchOn = await AppController().readBool("pinReminderNotificationSwitchOn");print("pinReminderNotificationSwitchOn $pinReminderNotificationSwitchOn");}catch(e){ print("this is error in pin $e");}
    try{ diaryReminderNotificationSwitchOn = await AppController().readBool("diaryReminderNotificationSwitchOn");}catch(e){}
    try{ chooseIndex = await AppController().readInt("selectedIndex");}catch(e){}
  }

  @override
  Widget build(BuildContext context) {
    notificationTitle.toColor;
    return Scaffold(
      backgroundColor: brightBackgroundColor,
        body: SafeArea(
            child: FutureBuilder(
              future:  checkSwitchButton(),
              builder: (context, snapshot) =>
               SizedBox(
                height: double.maxFinite,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            IconButton(
                              splashRadius: 0.001,
                              alignment: Alignment.centerLeft,
                              iconSize: 30,
                              padding: EdgeInsets.only(right: 14,left: 10,),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon:  const Icon(Icons.arrow_back,),
                            ),
                            const Text(
                              "Notify",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Padding(
                           padding:  EdgeInsets.only(left: 15.0.px),
                           child: const Text("Pin reminders to notification bar",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 17)),
                         ),
                         Switch(value: pinReminderNotificationSwitchOn, onChanged: (value) async{
                           setState(()  {pinReminderNotificationSwitchOn = !pinReminderNotificationSwitchOn;});
                           await AppController().setValueBool("pinReminderNotificationSwitchOn", value);
                           if(pinReminderNotificationSwitchOn) {
                             AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
                               if (!isAllowed) {
                                 AwesomeNotifications().requestPermissionToSendNotifications();
                               }
                               else{
                                 await _showPinReminderNotification();
                               }
                             });
                           }
                           else{
                               AwesomeNotifications().cancel(0);
                           }
                         },)
                       ],
                     ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:  EdgeInsets.only(left: 15.0.px),
                                child: const Text("Diary Reminder",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 17)),
                              ),
                              Padding(
                                padding:  EdgeInsets.only(left: 15.0.px),
                                child: const Text("Turn on reminders to avoid forgetting to journal",style: TextStyle(fontSize: 15)),
                              ),
                            ],
                          ),
                          Switch(
                            value: diaryReminderNotificationSwitchOn,
                            onChanged: (value) async{
                              setState(()  {
                                diaryReminderNotificationSwitchOn = !diaryReminderNotificationSwitchOn;
                              });
                              await AppController().setValueBool("diaryReminderNotificationSwitchOn", value);
                              if (diaryReminderNotificationSwitchOn) {
                                AwesomeNotifications().createNotification(
                                  schedule: chooseIndex == 0
                                      ? NotificationAndroidCrontab.minutely(
                                    referenceDateTime: DateTime.now(),
                                    allowWhileIdle: true,
                                  )
                                      : chooseIndex == 1
                                      ? NotificationAndroidCrontab.workweekDay(
                                    referenceDateTime: DateTime.now(),
                                    allowWhileIdle: true,
                                  )
                                      : chooseIndex == 2
                                      ? NotificationAndroidCrontab.weekendDay(
                                    referenceDateTime: DateTime.now(),
                                    allowWhileIdle: true,
                                  )
                                      : chooseIndex == 3
                                      ? NotificationAndroidCrontab.weekly(
                                    referenceDateTime: DateTime.now(),
                                    allowWhileIdle: true,
                                  )
                                      : NotificationAndroidCrontab.monthly(
                                    referenceDateTime: DateTime.now(),
                                    allowWhileIdle: true,
                                  ),
                                  content: NotificationContent(
                                    id: 1,
                                    channelKey: 'key',
                                    body: 'Hey!! Write a diary now??',
                                    autoDismissible: false,
                                  ),
                                  actionButtons: [
                                    NotificationActionButton(
                                      key: "open",
                                      label: "Write diary.",
                                    ),
                                  ],
                                );
                              } else {
                                // You can choose not to cancel the notification when the switch is turned off
                                AwesomeNotifications().cancel(id);
                              }
                            },
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              int selectedIndex = chooseIndex; // Initialize selectedIndex with the initial value
                              return AlertDialog(
                                contentPadding: EdgeInsets.only(top: 5),
                                insetPadding: EdgeInsets.all(40),
                                title: Text("Reminder interval"),
                                content: StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) {
                                    return SizedBox(
                                      width: double.maxFinite,
                                      height: 30.h,
                                      child: ListView.builder(
                                        itemCount: selectedDays.length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) => Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ListTile(
                                              leading: Radio(
                                                value: index,
                                                groupValue: selectedIndex,
                                                onChanged: (int? value) {
                                                  setState(() {
                                                    selectedIndex = value!;
                                                  });
                                                },
                                              ),
                                              title: Text(selectedDays[index]),
                                            ),
                                            Divider(height: 2, color: Colors.black, thickness: 1,indent: 15,endIndent: 15),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      setState(() {chooseIndex = selectedIndex;});
                                      await AppController().setValueInt("selectedIndex", selectedIndex);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Choose"),
                                  )
                                ],
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding:  EdgeInsets.only(top: 8.0.px),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.only(left: 15.0.px),
                                    child: const Text("Reminder time",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 17)),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(left: 15.0.px),
                                    child:  Text( selectedDays[chooseIndex],style: TextStyle(fontSize: 15)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    ]),
              ),
            )));
  }

  Future<void> _showPinReminderNotification() async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'key',
        body: 'Hey!! Write a diary now??',
        locked: true,
      ),
      actionButtons: [
        NotificationActionButton(
          key: "open",
          label: "Write diary.",
          enabled: true,
          autoDismissible: false,
        ),
      ],
    );
  }

}
Future<String> convertAssetImageToBase64Image(String assetImagePath) async {
  Uint8List image = (await rootBundle.load(assetImagePath))
      .buffer
      .asUint8List();
  final String base64Image = base64Encode(image.buffer.asUint8List());

  return base64Image;
}

