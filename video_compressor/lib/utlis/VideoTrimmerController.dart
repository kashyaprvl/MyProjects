// // import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
// import 'package:get/get.dart';
// import 'package:video_trimmer/video_trimmer.dart';
//
// import '../main.dart';
//
// class videoTrimmerController extends GetxController{
//
//   Trimmer trimmer = Trimmer();
//   var startValue = 0.0..obs;
//   var endValue = 0.0..obs;
//   var isPlaying = false.obs;
//   var progressVisibility = false.obs;
//
//   @override
//   void onInit() {
//     // TODO: implement onInit
//     super.onInit();
//   }
//
//   @override
//   void onClose() {
//     // TODO: implement onClose
//     super.onClose();
//   }
//
//   @override
//   void onReady() {
//     // TODO: implement onReady
//     super.onReady();
//   }
//
//   // Future<void> convertVideo(String inputPath) async {
//   //   // final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
//   //   //
//   //   // int rc = await _flutterFFmpeg.execute(
//   //   //   '-i $inputPath -c:v libx264 -c:a aac -strict experimental -b:a 192k $outputPath',
//   //   // );
//   //   //
//   //   // print("FFmpeg process exited with rc $rc");
//   /*  FFmpegKit.execute('-i $inputPath -c:v mpeg4').then((session) async {
//       final returnCode = await session.getReturnCode();
//
//       if (ReturnCode.isSuccess(returnCode)) {
//            print("success return code is $returnCode");
//         // SUCCESS
//
//       } else if (ReturnCode.isCancel(returnCode)) {
//         print("cancel session code $returnCode");
//         // CANCEL
//
//       } else {
//         print('error $returnCode');
//         // ERROR
//
//       }
//     });
//   }
// */
//  saveVideo() async{
//    progressVisibility.value = true;
//    // String? o;
//
//    await trimmer.saveTrimmedVideo(startValue: startValue, endValue: endValue, applyVideoEncoding: true, ffmpegCommand:
//    '-filter:v "crop=320:150"',
//        customVideoFormat: '.mp4',onSave: (outputPath) {
//      videoPath = outputPath;
//      print("p is $videoPath");
//       // print(result);
//      // return videoPath;
//    },).then((b) {
//      Future.delayed(Duration(seconds: 2));
//      print("j is $videoPath");
//    });
//    // await convertVideo(videoPath!);
//
//   }
// }
