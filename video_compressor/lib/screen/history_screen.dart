import 'dart:typed_data';

import 'package:VideoCompress/main.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:io';
import '../model/hivedatamodel.dart';
import '../utlis/colors.dart';
import '../utlis/uiUtils.dart';
import '../widget/appbar.dart';
import 'VideoHistoryController.dart';
import 'home_screen.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoHistoryList extends StatefulWidget {
  @override
  State<VideoHistoryList> createState() => _VideoHistoryListState();
}

class _VideoHistoryListState extends State<VideoHistoryList> {

  final videoHistoryController = Get.put(VideoHistoryController());
  List<Uint8List> originalBytes = [];
  List<Uint8List> compressBytes = [];
  List<VideoHistory> currentSameDateData = [];
  final ScrollController _controller = ScrollController();
  int tempIntValue = 0;

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  initializeData() async {

    await videoHistoryController.getAllVideoHistories();

    print("This is length of ${videoHistoryController.videoHistories.length}");

    for(int i=0;i<videoHistoryController.videoHistories.length;i++){
      print("This is path of ${ videoHistoryController.videoHistories[i].originalPath}");
      final thumbnailBytes  = await VideoThumbnail.thumbnailData(video: videoHistoryController.videoHistories[i].originalPath,imageFormat: ImageFormat.JPEG);
      originalBytes.add(thumbnailBytes!);
    }

    for(int i=0;i< videoHistoryController.videoHistories.length;i++) {
      print("This is path of ${ videoHistoryController.videoHistories[i]
          .compressedPath}");
      final thumbnailBytes = await VideoThumbnail.thumbnailData(
          video: videoHistoryController.videoHistories[i].compressedPath,
          imageFormat: ImageFormat.JPEG);
      compressBytes.add(thumbnailBytes!);
    }
    setState(() {});
  }

  @override
  void dispose() {
    print("i am in dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          showIcon: true,
          leftIconPath: "assets/svg/back_arrow_svg.svg",
          leftOnPressed: () {
            // videoHistoryController.onDelete();
            Navigator.pop(context);
          },
          rightIconPath: "assets/svg/home.svg",
          rightOnPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                ModalRoute.withName("/Home"));
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Obx((){
            if(videoHistoryController.videoHistories.length != compressBytes.length){
               return const Center(child: CircularProgressIndicator(),);
            }else {
              return _buildVideoHistoryList(
                  videoHistoryController.videoHistories);
            }
          }),
        )
    );
  }

  Widget _buildVideoHistoryList(List<VideoHistory>? VideoHistories) {
    print("I am in  _buildVideoHistoryList");
    if (VideoHistories!.isEmpty) {
      return Center(
          child: Text("No Data Available At that Time".toUpperCase()));
    }

    tempIntValue = -1;

    final groupedHistories = groupBy(
        VideoHistories,
            (history) =>
            DateFormat('dd-MM-yyyy H:mm:ss').format(history.timestamp));
    // tempIntValue = -1;
    return ListView(
      children: [
        ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          reverse: true,
          itemCount: groupedHistories.entries.length,
          itemBuilder: (context, index) {
            var entry = groupedHistories.entries.elementAt(index);
            currentSameDateData = entry.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    (currentSameDateData.length > 1)
                        ? UIUtils().navigateToDetailsScreen(
                        context, currentSameDateData)
                        : UIUtils().navigateToDetailsScreen(
                        context, currentSameDateData);
                    // : null; // Pass data for selected date
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: (currentSameDateData.length > 1)
                        ? Text("Multiple Videos",
                        style: GoogleFonts.mulish(
                            fontWeight: FontWeight.w600, fontSize: 16))
                        : Text("Single Video",
                        style: GoogleFonts.mulish(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                ),
                SingleChildScrollView(
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: (currentSameDateData.length > 1)
                          ? currentSameDateData
                          .asMap()
                          .entries
                          .map((entry) {
                        var history = entry.value;
                        tempIntValue++;
                        int currentDataIndex = tempIntValue;
                        return _buildVideoHistoryItem(history, index,
                            currentDataIndex, Colors.grey,
                            currentSameDateData.length);
                      }).toList()
                          : currentSameDateData
                          .asMap()
                          .entries
                          .map((entry) {
                        var history = entry.value;
                        tempIntValue++;
                        int currentDataIndex = tempIntValue;
                        return _buildVideoHistoryItem(history, index,
                            currentDataIndex, Colors.grey, 1);
                      }).toList()),
                )
              ],
            );
          },
        )
      ],
    );
  }

  Widget _buildVideoHistoryItem(VideoHistory history, int index,
      int currentDataIndex, Color color, int length) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color.fromRGBO(255, 255, 255, 1),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromRGBO(233, 233, 233, 0.35),
                  blurRadius: 24,
                  spreadRadius: 0,
                  blurStyle: BlurStyle.solid)
            ]),
        padding: const EdgeInsets.only(
            left: 25, top: 10, bottom: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: UIUtils.appWidth(context) * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColor.cardBackgroungDarkColor,
                            ),
                            height: 35,
                            width: 35,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                "assets/svg/image_logo.svg",
                                color: Colors.white,
                                width: 150,
                                height: 150,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Compress Video",
                                  style: GoogleFonts.mulish(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: UIUtils.appWidth(context) * 0.3,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Fluttertoast.showToast(
                                  msg: "Download Start ...",
                                );
                                List<String> temp = [];
                                temp.add(history.compressedPath);
                                UIUtils.appVideoSaveDownload(temp);
                              },
                              child: Container(
                                height: 45,
                                width: 45,
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: SvgPicture.asset(
                                  "assets/svg/downloadinhistory.svg",
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                               InkWell(
                                onTap: () async {
                                  await UIUtils.deleteVideoHistory(
                                      currentDataIndex).then((value) async {
                                        await videoHistoryController.removeHistoryAtIndex(index);
                                        originalBytes.removeAt(index);
                                        compressBytes.removeAt(index);
                                  });
                                  },
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset(
                                    "assets/svg/delete.svg",
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    if (length > 1) {
                      print("hi $currentDataIndex");
                      UIUtils.showVideoPopup(
                          context,
                          history.originalPath,
                          true,
                          "Details: Add your details here", currentDataIndex);
                    } else {
                      UIUtils.showVideoPopup(
                          context,
                          history.originalPath,
                          true,
                          "Details: Add your details here", currentDataIndex);
                    }
                  },
                  child: DottedBorder(
                    padding: const EdgeInsets.all(5),
                    color: AppColor.cardBackgroungDarkColor,
                    child: SizedBox(
                        height: UIUtils.appHeight(context) * 0.32,
                        width: UIUtils.appWidth(context) * 0.37,
                        child: Image.memory(originalBytes[currentDataIndex],fit: BoxFit.fill,)
                          ),
                        )
                ),
                const SizedBox(width: 15),
                InkWell(
                    splashColor: Colors.teal,
                    onTap: () {
                      if (length > 1) {
                        // print(
                        //     "This is index $index and value is ${videoHistoryController
                        //         .videoPlayerControllerCompressVideo[index]
                        //         .dataSource}");
                        UIUtils.showVideoPopup(
                            context,
                            history.compressedPath,
                            false,
                            "Details: Add your details here",
                            currentDataIndex
                        );
                      } else {
                        UIUtils.showVideoPopup(
                            context,
                            history.compressedPath,
                            false,
                            "Details: Add your details here",
                            currentDataIndex
                        );
                      }
                    },
                    child: DottedBorder(
                      padding: const EdgeInsets.all(5),
                      color: AppColor.cardBackgroungDarkColor,
                      child: Container(
                        height: UIUtils.appHeight(context) * 0.32,
                        width: UIUtils.appWidth(context) * 0.37,
                        color: Colors.indigo,
                        child: Image.memory(compressBytes[currentDataIndex],fit: BoxFit.fill,)
                      ),
                    ))
              ],
            ),
            Row(
              children: [
                SizedBox(
                  height: 50,
                  width: UIUtils.appWidth(context) * 0.37,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Before",
                        style: GoogleFonts.mulish(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      Text(
                        UIUtils.formatFileSize(
                            File(history.originalPath).lengthSync()),
                        style: GoogleFonts.mulish(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: const Color.fromRGBO(161, 161, 161, 1)),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                  height: 50,
                  width: UIUtils.appWidth(context) * 0.37,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "After",
                        style: GoogleFonts.mulish(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      Text(
                        UIUtils.formatFileSize(
                            File(history.compressedPath).lengthSync()),
                        style: GoogleFonts.mulish(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: const Color.fromRGBO(161, 161, 161, 1)),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
