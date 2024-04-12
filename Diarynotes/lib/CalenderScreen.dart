import 'dart:io';

import 'package:diarynotes/Data_Manager/CreateStoreForObjectBox.dart';
import 'package:diarynotes/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'Data_Manager/CommonWidget.dart';
import 'Data_Manager/ObjectBoxDataModel.dart';
import 'WriteDiary/WriteDiary.dart';

class CalenderScreen extends StatefulWidget {

  ObjectBox? box;
  CalenderScreen({super.key,this.box});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  bool showEvents = true;
  List<DateTime> fileCreateDateData = [];
  List<String> fileCreateTitle = [];
  List<String> fileCreateDescription = [];
  List<AssetEntity> galleryData = [];
  int imagePathLength = 0;
  int drawImageLength = 0;
  int emojiSelectedIndexFromWriteDiary = 0;
  String selectedDate = "";

  final List<NeatCleanCalendarEvent> _eventList = [];
  List<fileCreate> createdFileData = [];

  @override
  void initState() {
    selectedDate = DateFormat("y-MMM-dd").format(DateTime.now());
    _handleNewDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
    super.initState();
  }



  @override
  void didChangeDependencies() async{
    var createdFileData = userBox.getAll();
    final emojiIndex = objectBox.store.box<EmojiIndex>();
   try{ emojiSelectedIndexFromWriteDiary = emojiIndex.getAll().last.emojiSelectedIndex!;}catch(e){}
    for (var element in createdFileData) {
      fileCreateDateData.add(DateTime.parse(element.dateTime));
      fileCreateDescription.add(element.detailsController.first.value);
      fileCreateTitle.add(element.title);
    }
    for(int i=0;i<createdFileData.length;i++){
      _eventList.add(
          NeatCleanCalendarEvent(
              fileCreateTitle[i],
              startTime: fileCreateDateData[i],
              endTime:fileCreateDateData[i],
              color: Colors.purpleAccent
          )
      );
    }
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    final userBox = objectBox.store.box<fileCreate>();
    createdFileData = userBox.getAll();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: brightBackgroundColor,
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // bottomNavigationBar:  BottomAppBarCreate().bottomNavigationBar(context),
        // floatingActionButton: BottomAppBarCreate().floatingActionButton(context,),
        body: SafeArea(
          child: Column(
            children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 20),
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.8,
                    child: Calendar(
                      defaultDayColor: !isDarkMode ? Colors.black : Colors.white,
                      bottomBarColor: lightBackgroundColor,
                      eventListBuilder: (BuildContext context, List<NeatCleanCalendarEvent> selectedEvents) {
                        return Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.0.px),
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 0.15.inches),
                              itemCount: createdFileData.length,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemBuilder: (context, index) {
                                DateTime? date = DateTime.parse(createdFileData[index].dateTime);
                                String checkFileDateToConvertToString = DateFormat("y-MMM-dd").format(date);
                                String newFileCreatedDate = DateFormat("dd").format(date);
                                String newFileCreatedDay = DateFormat("EEE").format(date);
                                String newFileCreatedMonthYear = DateFormat("MMM y").format(date);
                                if(selectedDate == checkFileDateToConvertToString){
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 0.1.inches),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, "/WriteDiary",
                                            arguments: WriteDiary(
                                              openListOfFileIndex: index,
                                            ));
                                      },
                                      child: Card(
                                        color: lightBackgroundColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            children: [
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      right: 8.0, bottom: 8.0),
                                                  child: IntrinsicHeight(
                                                    child: Row(
                                                        mainAxisSize: MainAxisSize
                                                            .min,
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          SizedBox(width: 27,
                                                              child: Text(
                                                                  newFileCreatedDate,
                                                                  style: const TextStyle(
                                                                      fontSize: 24,
                                                                      fontWeight: FontWeight
                                                                          .w600))),
                                                          const VerticalDivider(
                                                              color: Colors
                                                                  .black,
                                                              thickness: 1,
                                                              indent: 0,
                                                              endIndent: 0),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .start,
                                                            mainAxisSize: MainAxisSize
                                                                .min,
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                newFileCreatedMonthYear,
                                                                style: const TextStyle(
                                                                    fontWeight: FontWeight
                                                                        .w400,
                                                                    fontSize: 14),),
                                                              Text(
                                                                newFileCreatedDay,
                                                                style: const TextStyle(
                                                                    fontWeight: FontWeight
                                                                        .w400,
                                                                    fontSize: 14),)
                                                            ],
                                                          ),
                                                          const Spacer(),
                                                          CircleAvatar(
                                                              minRadius: 22,
                                                              backgroundColor: Colors.transparent,
                                                              foregroundColor: null,
                                                              maxRadius: 22,
                                                              child: CommonWidgets().buildImage(
                                                                  emojiSelectedIndexFromWriteDiary,
                                                                  createdFileData[index]
                                                                      .emoji)
                                                          ),
                                                        ]),
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .start,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  mainAxisSize: MainAxisSize
                                                      .min,
                                                  children: [
                                                    imageFetch(index),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .start,
                                                        mainAxisSize: MainAxisSize
                                                            .min,
                                                        children: [
                                                          Text(
                                                              createdFileData[index].title,
                                                              style: const TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight: FontWeight
                                                                      .w600)),
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .only(right: 2),
                                                            child: Text(
                                                                createdFileData[index]
                                                                    .detailsController
                                                                    .first
                                                                    .value,
                                                                maxLines: 3,
                                                                style: const TextStyle(
                                                                    fontSize: 17,
                                                                    overflow: TextOverflow
                                                                        .ellipsis)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                else{
                                  return const SizedBox();
                                }
                              },
                            ),
                          ),
                        );
                      },
                      eventsList: _eventList,
                      eventTileHeight: 80,
                      isExpandable: true,
                      eventDoneColor: Colors.green,
                      selectedColor: Colors.pink,
                      selectedTodayColor: lightBackgroundColor.withRed(100),
                      eventColor: lightBackgroundColor,
                      dayOfWeekStyle: !isDarkMode ? TextStyle(color: Colors.black) : TextStyle(color: Colors.white),
                      isExpanded: true,
                      startOnMonday: true,
                      expandableDateFormat: 'EEEE, dd. MMMM yyyy',
                      onEventSelected: (value) {
                        print('Event selected ${value.summary}');
                      },
                      todayColor: lightBackgroundColor,
                      // displayMonthTextStyle: TextStyle(),
                      onDateSelected: (value) {
                        selectedDate = DateFormat("y-MMM-dd").format(value);
                        print("selected date is $value");
                        setState(() {});
                      },
                      onEventLongPressed: (value) {
                        print('Event long pressed ${value.summary}');
                      },
                      onMonthChanged: (value) {
                        print('Month changed $value');
                      },
                      onRangeSelected: (value) {
                        print('Range selected ${value.from} - ${value.to}');
                      },
                      datePickerType: DatePickerType.date,
                      showEvents: showEvents,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
   Navigator.pushNamed(context, "/MultiPageView");
    return Future.value(false);
  }


  Widget imageFetch(int index) {
    imagePathLength = createdFileData[index].imagePath.length;
    drawImageLength = createdFileData[index].drawImages.length;
    if (imagePathLength > 0) {
      return Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: SizedBox(
          height: 50,
          width: 50,
          child: Image.file(fit: BoxFit.cover,
              alignment: Alignment.center,
              File(createdFileData[index].imagePath.first.value)),
        ),
      );
        }
    else if(drawImageLength > 0){
      return Padding(padding: EdgeInsets.only(right: 6),
        child: SizedBox(
          height: 35,
          width: 35,
          child: Image.memory(
            createdFileData[index].drawImages.first.value,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return SizedBox();
  }

  void _handleNewDate(date) {
    print('Date selected: $date');
  }
}