import 'dart:io';
import 'package:VideoCompress/screen/video_compreess_details_screen.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../model/hivedatamodel.dart';
import '../utlis/uiUtils.dart';

class VideoHistoryController extends GetxController {

   late RxList<VideoHistory> videoHistories;

   @override
  void onClose() async{
    // TODO: implement onClose
    //  for (var controller in videoPlayerControllerOriginalVideo) {
    //    await controller.dispose();
    //  }
    //  for (var controller in videoPlayerControllerCompressVideo) {
    //    await controller.dispose();
    //  }
     print("i am in dispose in onClose");
    super.onClose();
  }

  @override
  void onInit() async{
    videoHistories = <VideoHistory>[].obs;
    print("i am in init");
    await getAllVideoHistories();
    super.onInit();
  }


  Future<List<VideoHistory>> getAllVideoHistories() async {
    videoHistories = <VideoHistory>[].obs;

    print("This is length of history ---${videoHistories.length}");

    videoHistories.assignAll(await UIUtils.getAllVideoHistories());

    return videoHistories;
  }

  Future<List<VideoHistory>> removeHistoryAtIndex(int index) async {
     videoHistories.removeAt(index);
     print("This is length of history 3 --${videoHistories.length}");
     return videoHistories;
  }

  void navigateToDetailScreen(List<VideoHistory> videoHistories) {
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

    Get.to(() => VideoDetailsScreen(
      compressedVideoPaths: compressedVideoPaths,
      compressedSizes: compressedSizes,
      originalVideoPaths: originalVideoPaths,
      originalSizes: originalSizes,
    ));
  }


// Add other logic as needed
}
