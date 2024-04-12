import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'dart:io';
import '../model/hivedatamodel.dart';
import '../utlis/colors.dart';
import '../utlis/uiUtils.dart';
import '../widget/appbar.dart';
import 'home_screen.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'image_compreess_details_screen.dart'; // For groupBy

class ImageHistoryList extends StatefulWidget {
  @override
  State<ImageHistoryList> createState() => _ImageHistoryListState();
}


class _ImageHistoryListState extends State<ImageHistoryList> {
  late Future<List<ImageHistory>> _imageHistories;
  List<ImageHistory> currentSameDateData = [];
    final ScrollController _controller = ScrollController();

  late List<VideoPlayerController> _videoPlayerControllerOriginalVideo;
  late List<VideoPlayerController> _videoPlayerControllerCompressVideo;

  // UIUtils ui = Get.find();

  @override
  void initState() {
    super.initState();
    _imageHistories = UIUtils.getAllImageHistories();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showIcon: true,
        leftIconPath: "assets/svg/back_arrow_svg.svg",
        leftOnPressed: () {
          Navigator.pop(context);
        },
        rightIconPath: "assets/svg/home.svg",
        rightOnPressed: (){
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen()
              ),
              ModalRoute.withName("/Home")
          );        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child:  FutureBuilder<List<ImageHistory>>(
          future: _imageHistories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if(snapshot.data!.isEmpty)
              {
                return Container();
              }else {
              print('This is snapshot data of compress video ${snapshot.data!.length} && ${snapshot.data!.last.compressedPath}');
              print('This is snapshot data of original video ${snapshot.data!.length} && ${snapshot.data!.last.originalPath}');
              _videoPlayerControllerOriginalVideo = List.generate(snapshot.data!.length, (index) => VideoPlayerController.file(File(snapshot.data![index].originalPath))..initialize());
              _videoPlayerControllerCompressVideo = List.generate(snapshot.data!.length, (index) => VideoPlayerController.file(File(snapshot.data![index].compressedPath))..initialize());
              List<ImageHistory>? imageHistories = snapshot.data;
              return _buildImageHistoryList(imageHistories);
            }
          },
        ),
      ),
    );
  }

  void _navigateToDetailScreen(List<ImageHistory> imageHistories) {
    List<String> compressedImagePaths = [];
    List<String> compressedSizes = [];
    List<String> originalImagePaths = [];
    List<String> originalSizes = [];
    for (int i = 0; i < imageHistories.length; i++) {
      compressedImagePaths.add(imageHistories[i].compressedPath);
      originalImagePaths.add(imageHistories[i].originalPath);
      compressedSizes.add(UIUtils.formatFileSize(File(imageHistories[i].compressedPath).lengthSync()));
      originalSizes.add(UIUtils.formatFileSize(File(imageHistories[i].originalPath).lengthSync()));
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageDetailsScreen(
          compressedImagePaths: compressedImagePaths,
          compressedSizes: compressedSizes,
          originalImagePaths: originalImagePaths,
          originalSizes: originalSizes,
        ),
      ),
    );
  }

  Widget _buildImageHistoryList(List<ImageHistory>? imageHistories) {
    if (imageHistories!.isEmpty) {
      return Center(child: Text("No Data Available At that Time".toUpperCase()));
    }

    final groupedHistories = groupBy(
        imageHistories, (history) => DateFormat('dd-MM-yyyy H:mm:ss').format(history.timestamp));

    return ListView(
      children: [
        ListView.builder(
          physics: BouncingScrollPhysics(),
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
                        ? _navigateToDetailScreen(currentSameDateData)
                        : null; // Pass data for selected date
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: (currentSameDateData.length > 1)
                        ? Text("Multiple Videos", style: GoogleFonts.mulish(fontWeight: FontWeight.w600,fontSize: 16))
                        : Text("Single Video", style: GoogleFonts.mulish(fontWeight: FontWeight.w600,fontSize: 16)),
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
                        ? currentSameDateData.map((history) => _buildImageHistoryItem(history, index, Colors.grey, currentSameDateData.length)).toList()
                        : currentSameDateData.map((history) => _buildImageHistoryItem(history, index, Colors.grey, 1)).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildImageHistoryItem(ImageHistory history, int index, Color color, int length) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: UIUtils.appHeight(context) * 0.52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color.fromRGBO(255, 255, 255, 1),
          boxShadow: const [BoxShadow(
        color: Color.fromRGBO(233, 233, 233, 0.35),
          blurRadius: 24,
          spreadRadius: 0,
          blurStyle: BlurStyle.solid

      )]
        ),
        padding: EdgeInsets.only(left: 25, top: 10, bottom: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
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
                                Text("Compress Video",style: GoogleFonts.mulish(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700
                                ),),
                              ],
                            ),
                          ),

                        ],
                      ),
                      Container(
                        width: UIUtils.appWidth(context) * 0.3,
                        // color: Colors.grey,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: (){
                                Fluttertoast.showToast(msg: "Download Start ...",);
                                List<String> temp = [];
                                temp.add(history.compressedPath);
                                UIUtils.appImageSaveDownload(temp);
                              },
                              child:Container(
                                height: 45,
                                width: 45,
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child:  SvgPicture.asset(
                                  "assets/svg/downloadinhistory.svg",
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            InkWell(
                             onTap: (){

                               // UIUtils ui = Get.find();
                               UIUtils.deleteImageHistory(index).then((value) {
                                   _imageHistories = UIUtils.getAllImageHistories();
                                 Fluttertoast.showToast(msg: "Delete Successfully..");
                               });
                             },
                             child: Container(
                               height: 45,
                               width: 45,
                               padding: EdgeInsets.all(5),
                               decoration: const BoxDecoration(
                                 // color: AppColor.appRedColor,
                                 shape: BoxShape.circle,
                               ),
                               child:  SvgPicture.asset(
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
            SizedBox(height: 15,),
            Row(
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    if (length > 1) {
                      // Pass a list of image paths if there are multiple images
                      UIUtils.showImagePopup(context, currentSameDateData.map((history) => history.originalPath).toList(), "Details: Add your details here");
                    } else {
                      // Pass a single image path if there is only one image
                      UIUtils.showImagePopup(context, history.originalPath, "Details: Add your details here");
                    }
                    // UIUtils.showImagePopup(context, currentSameDateData.map((history) => history.originalPath).toList(), "Details: Add your details here");
                  },
                  child: DottedBorder(
                    padding: EdgeInsets.all(5),
                    color: AppColor.cardBackgroungDarkColor,
                    child: Container(
                      height: UIUtils.appHeight(context) * 0.32,
                      width: UIUtils.appWidth(context) * 0.37,
                        child : AspectRatio(
                          aspectRatio: _videoPlayerControllerOriginalVideo[index].value.aspectRatio,
                          child: VideoPlayer(
                            _videoPlayerControllerOriginalVideo[index],
                          ),
                        )
                    ),
                  ),
                ),
                SizedBox(width: 15),
                InkWell(
                  splashColor: Colors.teal,
                  onTap: () {
                    if (length > 1) {
                      // Pass a list of image paths if there are multiple images
                      UIUtils.showImagePopup(context, currentSameDateData.map((history) => history.compressedPath).toList(), "Details: Add your details here");
                    } else {
                      // Pass a single image path if there is only one image
                      UIUtils.showImagePopup(context, history.compressedPath, "Details: Add your details here");
                    }
                    // UIUtils.showImagePopup(context, currentSameDateData.map((history) => history.compressedPath).toList(), "Details: Add your details here");
                  },
                  child: DottedBorder(
                      padding: EdgeInsets.all(5),
                      color: AppColor.cardBackgroungDarkColor,
                      child: Container(
                        height: UIUtils.appHeight(context) * 0.32,
                        width: UIUtils.appWidth(context) * 0.37,
                        color: Colors.indigo,
                        child : AspectRatio(
                          aspectRatio: _videoPlayerControllerCompressVideo[index].value.aspectRatio,
                          child: VideoPlayer(
                            _videoPlayerControllerCompressVideo[index],
                          ),
                        )
                      ),
                    // ),
                ),
                  ),
              ],
            ),
            Row(
              children: [
                Container(
                  height: 50,
                  width: UIUtils.appWidth(context) * 0.37,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Before",style: GoogleFonts.mulish(fontWeight: FontWeight.w500,fontSize: 16),),
                      Text("${UIUtils.formatFileSize(File(history.originalPath).lengthSync())}",style: GoogleFonts.mulish(fontWeight: FontWeight.w500,fontSize: 16,color: Color.fromRGBO(161, 161, 161, 1)),)
                    ],
                  ),
                ),

                SizedBox(width: 15,),

                Container(
                  height: 50,
                  width: UIUtils.appWidth(context) * 0.37,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("After",style: GoogleFonts.mulish(fontWeight: FontWeight.w500,fontSize: 16),),
                      Text("${UIUtils.formatFileSize(File(history.compressedPath).lengthSync())}",style: GoogleFonts.mulish(fontWeight: FontWeight.w500,fontSize: 16,color: Color.fromRGBO(161, 161, 161, 1)),)
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
