import 'dart:io';
import 'package:VideoCompress/main.dart';
import 'package:VideoCompress/screen/VideoHistoryController.dart';
// import 'package:better_player/better_player.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:VideoCompress/utlis/colors.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../model/hivedatamodel.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:video_player/video_player.dart';
import '../screen/video_compreess_details_screen.dart';

class UIUtils {

  static late Box<VideoHistory> boxSaveData;

  static Box<VideoHistory> get BoxSaveData => boxSaveData;

  // late VideoHistory videoHistory;

  // static late VideoPlayerController videoControllers;

  static set BoxSaveData(Box<VideoHistory> value) {
    boxSaveData = value;
  }

  static double appHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double appWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static Future<List<VideoHistory>> getAllVideoHistories() async {
    boxSaveData = await Hive.openBox<VideoHistory>('VideoHistoryBox');
    return boxSaveData.values.toList();
  }

  static Future<void> saveVideoHistory(List<VideoHistory> history) async {
    try {
      if (!BoxSaveData.isOpen) {
        BoxSaveData = await Hive.openBox<VideoHistory>('VideoHistoryBox');
      }

      for (VideoHistory videoHistory in history) {
        await BoxSaveData.add(videoHistory);
      }

      Fluttertoast.showToast(msg: "All files saved successfully.");
    } catch (error) {
      print("Error saving Video histories: $error");
      Fluttertoast.showToast(msg: "Error saving files.");
    }
  }

  static Future<void> deleteVideoHistory(int index) async {
    if (!BoxSaveData.isOpen) {
      BoxSaveData = await Hive.openBox<VideoHistory>('VideoHistoryBox');
    }

    await BoxSaveData.deleteAt(index);
  }

  static String formatFileSize(int bytes) {
    const kilobyte = 1024;
    const megabyte = 1024 * kilobyte;

    if (bytes >= megabyte) {
      return '${(bytes / megabyte).toStringAsFixed(2)} MB';
    } else if (bytes >= kilobyte) {
      return '${(bytes / kilobyte).toStringAsFixed(2)} KB';
    } else {
      return '$bytes bytes';
    }
  }

  static String appDateTimeFormat(DateTime dateTime) {
    final dateFormat = DateFormat('dd-MM-yyyy H:mm:ss');
    final formattedDate = dateFormat.format(dateTime);
    return formattedDate;
  }

  static Future<void> appVideoSaveDownload(List<String> VideoPath) async {
    Permission.storage.request();

    for (String singleVideotpath in VideoPath) {
      await GallerySaver.saveVideo(singleVideotpath).then((value) {
        Fluttertoast.showToast(msg: "Download SuccessFully ... ");
      });
    }
  }

  static Future<void> shareVideo(dynamic VideoPath) async {
    try {
      if (VideoPath is String) {
        VideoPath = [VideoPath]; // Convert single path to list
      }
      List<String> filesToShare = [];
      for (String path in VideoPath) {
        File file = File(path);
        if (await file.exists()) {
          filesToShare.add(file.path);
        } else {
          Fluttertoast.showToast(
              msg: 'Error sharing Video: File $path does not exist.');
        }
      }

      if (filesToShare.isNotEmpty) {
        await Share.shareFiles(filesToShare, text: 'Check out this Video!');
      }
    } catch (e) {
      print('Error sharing Video: $e');
    }
  }

  navigateToDetailsScreen(BuildContext context,List<VideoHistory> videoHistories) {
    List<String> compressedVideoPaths = [];
    List<String> compressedSizes = [];
    List<String> originalVideoPaths = [];
    List<String> originalSizes = [];

    for (int i = 0; i < videoHistories.length; i++) {
      compressedVideoPaths.add(videoHistories[i].compressedPath);
      originalVideoPaths.add(videoHistories[i].originalPath);
      compressedSizes.add(UIUtils.formatFileSize(File(videoHistories[i].compressedPath).lengthSync()));
      originalSizes.add(UIUtils.formatFileSize(File(videoHistories[i].originalPath).lengthSync()));
    }
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
        VideoDetailsScreen(originalVideoPaths: originalVideoPaths, compressedVideoPaths: compressedVideoPaths,
          originalSizes: originalSizes, compressedSizes: compressedSizes,),), (route) => false);
  }

   static showVideoPopup(BuildContext context,String videoPath,bool boolValue,String value,int index){
       return showDialog(context: context,builder: (context) =>  VideoPop(path: videoPath,index : index,value : boolValue));
   }
}

class VideoPop extends StatefulWidget{

  String path = "";
  int index = 0;
  bool value = false;
  VideoPop({Key? key, required this.path,required this.index,required this.value}):super(key: key);

  @override
  VideoPopScreen createState() {
    return VideoPopScreen();
  }
}

class VideoPopScreen extends State<VideoPop> {

 late VideoPlayerController controller;



  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<VideoPlayerController> initializeData() async{
    controller = VideoPlayerController.file(File(widget.path))..initialize();
    return controller;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return  Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
    child: FutureBuilder<VideoPlayerController>(
    future: initializeData(),
    builder: (context, snapshot) {
      print("In video pop initialized check ${controller.value.isPlaying}");
      if (snapshot.hasData) {
        print("snapshot value ${snapshot.data?.value.isPlaying}");
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DottedBorder(
                      padding: const EdgeInsets.all(5),
                      color: AppColor.cardBackgroungDarkColor,
                      child:SizedBox(
                          height: UIUtils.appHeight(context) * 0.5,
                          width: double.maxFinite,
                          child:
                            /*child:*/ ClipRRect(
                              borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(35)),
                              child:
                                   GestureDetector(onTap: () {
                                controller.value.isPlaying
                                    ? controller.pause()
                                    : controller.play();
                              }
                                  , child: AspectRatio(
                                         aspectRatio: controller.value.aspectRatio,
                                    child: VideoPlayer(/*controller:*/ controller,
                                      // aspectRatio: controller.value.aspectRatio,
                                    ),
                                  ))

                            ),

                        ),
                      ),
                    ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColor.cardBackgroungDarkColor,
                          shape: BoxShape.circle
                      ),
                      child: IconButton(
                        icon: Icon(Icons.close,
                          color: AppColor.cardBackgroungLightColor,),
                        onPressed: () {
                          print("It is in uiUtils initialized ${controller.value.aspectRatio}");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: UIUtils.appHeight(context) * 0.09,
                    right: 10,
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColor.cardBackgroungDarkColor,
                          shape: BoxShape.circle
                      ),
                      child: IconButton(
                        icon: Icon(Icons.share,
                          color: AppColor.cardBackgroungLightColor,),
                        onPressed: () {
                          UIUtils.shareVideo(widget.path);
                        },
                      ),
                    ),
                  ),
              const SizedBox(height: 10),
              const Padding(padding: EdgeInsets.all(10.0))
           ])]);
      }else if(snapshot.connectionState == ConnectionState.waiting){
        return const Center(child: CircularProgressIndicator(),);
      }
      else
      {
        return const Center(child: CircularProgressIndicator(),);
      }
    }));
  }

}
