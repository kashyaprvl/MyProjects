import 'dart:async';
import 'dart:io';
import 'package:diarynotes/Data_Manager/ObjectBoxDataModel.dart';
import 'package:diarynotes/WriteDiary/WriteDiary.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'Data_Manager/CommonWidget.dart';
import 'main.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';

class FileHomeScreen extends StatefulWidget {

   const FileHomeScreen({super.key});

  @override
  State<FileHomeScreen> createState() => _FileHomeScreenState();
}

class _FileHomeScreenState extends State<FileHomeScreen> {
  List<fileCreate> fileCreateData = [];
  int emojiSelectedIndexFromWriteDiary = 0;
  int imagePathLength = 0;
  int drawImageLength = 0;
  bool isSelected = false;
  List<int> currentIndex = [];
  List<fileCreate> originalFileCreateData = [];

  // PageController pageController = PageController();


  @override
  void initState() {
    super.initState();
    checkAlignSelected();
    checkDataBox();
  }

  checkDataBox() async{
    var data = userBox.getAll();
    data.sort((a, b) => a.sortData.compareTo(b.sortData));
    fileCreateData = data;
    List<fileCreate> pinnedItems = fileCreateData.where((item) => item.isPinned).toList();
    fileCreateData.removeWhere((item) => item.isPinned);
    fileCreateData.insertAll(0, pinnedItems);
    fileCreateData.forEach((element) {
      print("this data is ${element.title} and ${element.isPinned} ${element.sortData}");
    });
    for (int i = 0; i < fileCreateData.length; i++) {
      fileCreateData[i].sortData = i;
      userBox.put(fileCreateData[i]);
    }
    originalFileCreateData = List.from(fileCreateData);
  }

  void togglePin(int index) {
    setState(() {
      fileCreateData[index].isPinned = !fileCreateData[index].isPinned;
      userBox.put(fileCreateData[index]);
      fileCreateData = List.from(originalFileCreateData);
      List<fileCreate> pinnedItems = fileCreateData.where((item) => item.isPinned).toList();
      fileCreateData.removeWhere((item) => item.isPinned);
      fileCreateData.insertAll(0, pinnedItems);
      for (int i = 0; i < fileCreateData.length; i++) {
        fileCreateData[i].sortData = i;
        userBox.put(fileCreateData[i]);
      }
      var data = userBox.getAll();
      data.sort((a, b) => a.sortData.compareTo(b.sortData));
      data.forEach((element) {
        print("data is ${element.id} and is pinned ${element.isPinned}");
      });
    });
  }


  checkAlignSelected() async {
    final emojiIndex = objectBox.store.box<EmojiIndex>();
    try {
      emojiSelectedIndexFromWriteDiary = emojiIndex.getAll().last.emojiSelectedIndex!;
    } catch (e) {}
  }


  @override
  Widget build(BuildContext context) {
    checkAlignSelected();
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: brightBackgroundColor,
            // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            // floatingActionButton: BottomAppBarCreate().floatingActionButton(context),
            body:  SafeArea(
                  child:
                  // PageView.builder(
                  //   controller: pageController,
                  //   itemBuilder: (context, index) =>
                     Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(backgroundImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.all(14.0),
                              child: Text("Daily Diary", style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                            ),
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(top: 100.0.px),
                                child: ListView.builder(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 0.15.inches),
                                  itemCount: fileCreateData.length,
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    // print("filecreate Data ${fileCreateData[index].emoji}");
                                    GlobalKey newDismissibleKey = GlobalKey();
                                    var date = fileCreateData[index].dateTime;
                                    String newFileCreatedDate = DateFormat("dd")
                                        .format(DateTime.parse(date));
                                    String newFileCreatedDay = DateFormat("EEE")
                                        .format(DateTime.parse(date));
                                    String newFileCreatedMonthYear = DateFormat(
                                        "MMM y").format(DateTime.parse(date));
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 0.1.inches),
                                      child: GestureDetector(
                                        onTap: () {
                                          var dataIndex = fileCreateData[index]
                                              .sortData;
                                          print(
                                              "filecreate Data ${dataIndex} and  ${fileCreateData[index]
                                                  .title}");
                                          Navigator.pushNamed(
                                              context, "/WriteDiary",
                                              arguments: WriteDiary(
                                                openListOfFileIndex: dataIndex,
                                              ));
                                        },
                                        child: Dismissible(
                                          confirmDismiss: (
                                              DismissDirection direction) async {
                                            return await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  insetPadding: EdgeInsets
                                                      .symmetric(
                                                      vertical: MediaQuery
                                                          .sizeOf(context)
                                                          .height * 0.38,
                                                      horizontal: 40),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(8)),
                                                  actionsAlignment: MainAxisAlignment
                                                      .spaceEvenly,
                                                  backgroundColor: brightBackgroundColor,
                                                  title: const Center(
                                                      child: Text("Confirm",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight
                                                                .w800,))),
                                                  content: const Center(
                                                      child: Text(
                                                        "Are you sure to delete this item?",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight
                                                                .w100),)),
                                                  actions: <Widget>[
                                                    SizedBox(
                                                      height: 5.h,
                                                      width: 25.w,
                                                      child: TextButton(
                                                        clipBehavior: Clip
                                                            .antiAlias,
                                                        style: TextButton
                                                            .styleFrom(
                                                            backgroundColor: Colors
                                                                .transparent,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .circular(5),
                                                                side: BorderSide(
                                                                    color: lightBackgroundColor,
                                                                    width: 1))
                                                        ),
                                                        onPressed: () =>
                                                            Navigator.of(context)
                                                                .pop(
                                                                false),
                                                        child: const Text(
                                                            "CANCEL"),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                      width: 28.w,
                                                      child: TextButton(
                                                          clipBehavior: Clip
                                                              .antiAlias,
                                                          style: TextButton
                                                              .styleFrom(
                                                              backgroundColor: lightBackgroundColor,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius
                                                                      .circular(
                                                                      5),
                                                                  side: BorderSide(
                                                                      color: lightBackgroundColor,
                                                                      width: 1))
                                                          ),
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                  context)
                                                                  .pop(true),
                                                          child: const Text(
                                                              "DELETE")
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          onDismissed: (
                                              DismissDirection direction) {
                                            setState(() {
                                              if (direction ==
                                                  DismissDirection.endToStart) {
                                                int dataIndex = index;
                                                userBox.remove(
                                                    fileCreateData[dataIndex].id);
                                                print("new data is $index");
                                                fileCreateData.removeAt(
                                                    dataIndex);
                                              }
                                            });
                                          },
                                          background: Container(
                                            color: Colors.redAccent,
                                            padding: const EdgeInsets.all(20),
                                            margin: const EdgeInsets.all(2),
                                            child: const Icon(
                                                Icons.delete,
                                                color: Colors.white),
                                          ),
                                          // dragStartBehavior: DragStartBehavior.start,
                                          direction: DismissDirection.endToStart,
                                          key: newDismissibleKey,
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
                                                          right: 8.0,
                                                          bottom: 8.0),
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
                                                              IconButton(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                      right: 10),
                                                                  onPressed: () =>
                                                                      togglePin(
                                                                          index),
                                                                  iconSize: 25,
                                                                  icon: ImageIcon(
                                                                      const AssetImage(
                                                                          "assets/images/pin.png"),
                                                                      color: fileCreateData[index]
                                                                          .isPinned
                                                                          ? Colors
                                                                          .red
                                                                          : Colors
                                                                          .grey)),
                                                              CircleAvatar(
                                                                  minRadius: 22,
                                                                  backgroundColor: Colors
                                                                      .transparent,
                                                                  foregroundColor: null,
                                                                  maxRadius: 22,
                                                                  child: CommonWidgets()
                                                                      .buildImage(
                                                                      emojiSelectedIndexFromWriteDiary,
                                                                      fileCreateData[index]
                                                                          .emoji)
                                                              ),
                                                            ]),
                                                      )),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .only(
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
                                                                  fileCreateData[index]
                                                                      .title,
                                                                  style: const TextStyle(
                                                                      fontSize: 17,
                                                                      fontWeight: FontWeight
                                                                          .w600)),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .only(
                                                                    right: 2),
                                                                child: Text(
                                                                    fileCreateData[index]
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
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          ]),
                    ),
                  ),
                )
              // )
    );
  }


  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            backgroundColor: lightBackgroundColor,
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () =>  FlutterExitApp.exitApp(),// for ios iosForceExit
                child: const Text('Yes'),
              ),
            ],
          ),
    )) ??
        false;
  }

  Widget imageFetch(int index) {
    imagePathLength = fileCreateData[index].imagePath.length;
    drawImageLength = fileCreateData[index].drawImages.length;
    if (imagePathLength > 0) {
      return Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: SizedBox(
          height: 50,
          width: 50,
          child: Image.file(fit: BoxFit.cover,
              alignment: Alignment.center,
              File(fileCreateData[index].imagePath.first.value)),
        ),
      );
    }
    else if (drawImageLength > 0) {
      return Padding(padding: EdgeInsets.only(right: 6),
        child: SizedBox(
          height: 35,
          width: 35,
          child: Image.memory(
            fileCreateData[index].drawImages.first.value,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
