import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_compress/utlis/colors.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../model/hivedatamodel.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:path/path.dart' as path;
import 'package:video_player/video_player.dart';

late var boxSaveData;

class UIUtils extends GetxController{

 static RxList<ImageHistory> _ImageHistory  = <ImageHistory>[].obs;
  static late VideoPlayerController _videoPlayerController;

   UIUtils sd= Get.put(UIUtils());

  static  double appHeight(BuildContext context) {
    return  MediaQuery.of(context).size.height;
  }
  static  double appWidth(BuildContext context) {
    return  MediaQuery.of(context).size.width;
  }

   static Future<List<ImageHistory>> getAllImageHistories() async {
    var box = await Hive.openBox<ImageHistory>('imageHistoryBox');
    // return _ImageHistory.toList();
    return box.values.toList();
  }

/*  static Future<void> saveImageHistory(ImageHistory history) async {
    if (!boxSaveData.isOpen) {
      boxSaveData = await Hive.openBox<ImageHistory>('imageHistoryBox');
    }

    await boxSaveData.add(history).then((value) {
       Fluttertoast.showToast(msg: "File is Save Successfully..");
    });
  }*/
  static Future<void> saveImageHistory(List<ImageHistory> history) async {
    try {
      if (!boxSaveData.isOpen) {
        boxSaveData = await Hive.openBox<ImageHistory>('imageHistoryBox');
      }

      for (ImageHistory imageHistory in history) {
        await boxSaveData.add(imageHistory);
        _ImageHistory.add(imageHistory);
      }

      Fluttertoast.showToast(msg: "All files saved successfully.");
    } catch (error) {
      print("Error saving image histories: $error");
      Fluttertoast.showToast(msg: "Error saving files.");
    }
  }

  static Future<void> deleteImageHistory(int index) async {
    if (!boxSaveData.isOpen) {
      boxSaveData = await Hive.openBox<ImageHistory>('imageHistoryBox');
    }

    // _ImageHistory.removeAt(index);
    await boxSaveData.deleteAt(index);
  }

  static  String formatFileSize(int bytes) {
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
  static  String appDateTimeFormat(DateTime dateTime) {
    final dateFormat = DateFormat('dd-MM-yyyy H:mm:ss');

    final formattedDate = dateFormat.format(dateTime);

    print(formattedDate);
    return formattedDate;

  }

  static Future<void> appImageSaveDownload(List<String> imagePath)async {
    Permission.storage.request();

    for(String singleimagetpath in imagePath){
      await GallerySaver.saveImage(singleimagetpath).then((value) {
        print("object appDownload $value");
        Fluttertoast.showToast(msg: "Download SuccessFully ... ");
      });
    }
  }


  // static Future<void> shareImage(List<String> imagePath) async {
  //   try {
  //     List<File> temp = [];
  //   for(String listStringPaths in imagePath){
  //     temp.add(File(listStringPaths));
  //
  //
  //     if (await File(listStringPaths).exists()) {
  //       // Share the image using the share_plus package
  //       await Share.shareFiles(/*[imagePath]*/imagePath, text: 'Check out this image!');
  //     } else {
  //       Fluttertoast.showToast(msg: 'Error sharing image: File does not exist.');
  //     }
  //   }
  //
  //   } catch (e) {
  //     print('Error sharing image: $e');
  //   }
  // }


  static Future<void> shareImage(dynamic imagePath) async {
    try {
      if (imagePath is String) {
        imagePath = [imagePath]; // Convert single path to list
      }
       print('image path is $imagePath');
      List<String> filesToShare = [];
      for (String path in imagePath) {
        File file = File(path);
        if (await file.exists()) {
          filesToShare.add(file.path);
        } else {
          Fluttertoast.showToast(msg: 'Error sharing image: File $path does not exist.');
        }
      }

      if (filesToShare.isNotEmpty) {
        await Share.shareFiles(filesToShare, text: 'Check out this image!');
      }
    } catch (e) {
      print('Error sharing image: $e');
    }
  }


static void showImagePopup(BuildContext  context,dynamic imagePaths, String details) {
    print("This is image path====> $imagePaths");
   showDialog(
     context: context,
     barrierDismissible: false,
     builder: (BuildContext context) {
       _videoPlayerController = VideoPlayerController.file(File(imagePaths))..initialize();
       int i = 0;
       return Dialog(
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(15),
         ),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisSize: MainAxisSize.min,
           children: [
             Stack(
               children: [
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: DottedBorder(
                     padding: EdgeInsets.all(5),
                     color: AppColor.cardBackgroungDarkColor,
                     child: Container(
                       height: UIUtils.appHeight(context) * 0.5,
                       child: ClipRRect(
                         borderRadius: const BorderRadius.horizontal(left: Radius.circular(35)),
                         child: AspectRatio(
                           aspectRatio: _videoPlayerController.value.aspectRatio,
                           child: GestureDetector(onTap: () {
                             _videoPlayerController.value.isPlaying ? _videoPlayerController.pause() : _videoPlayerController.play();
                           },child: VideoPlayer(_videoPlayerController)),
                         ),
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
                       icon: Icon(Icons.close,color: AppColor.cardBackgroungLightColor,),
                       onPressed: () {
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
                       icon: Icon(Icons.share,color: AppColor.cardBackgroungLightColor,),
                       onPressed: () {
                         print("image path is ==> ${imagePaths}");
                         print("image path is ==");
                          UIUtils.shareImage(imagePaths);
                       },
                     ),
                   ),
                 ),
               ],
             ),
             SizedBox(height: 10),
            const Padding(padding: EdgeInsets.all(10.0))
            /* Padding(
               padding: const EdgeInsets.all(10.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text("Details:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                   Text('${UIUtils.formatFileSize(File(imagePaths).lengthSync()) }'),
                   Text("Name:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                   Text('${path.basename(imagePaths) }'),
                 ],
               ),
             ),*/
           ],
         ),
       );
     },
   );
 }



}