// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';
// import 'package:video_trimmer/video_trimmer.dart';
// import '../main.dart';
// import '../screen/video_compress_screen.dart';
// import 'VideoTrimmerController.dart';
//
// class videoEdit extends StatefulWidget {
//
//   final filePath;
//
//   videoEdit({super.key,this.filePath});
//
//   @override
//   State<videoEdit> createState() => VideoTrimmerView();
// }
//
// class VideoTrimmerView extends State<videoEdit> {
//
//   final videoTrimmerController controller = Get.put(videoTrimmerController());
//
//
//   @override
//   void dispose() {
//    controller.trimmer.dispose();
//    // controller.trimmer.videoPlayerController?.dispose();
//    // VideoFFmpegVideoEditorConfig(
//    //
//    // )
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     controller.trimmer.loadVideo(videoFile: widget.filePath);
//     // print("This is start video ${controller.startValue} && ${controller.trimmer}");
//     return  Scaffold(
//       appBar: AppBar(
//         title: Text("Video Trimmer"),
//       ),
//       body: Center(
//         child: Container(
//           padding: EdgeInsets.only(bottom: 30),
//           color: Colors.black,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.max,
//             children: [
//                  // Obx(() =>
//                  //    Visibility(
//                  //     visible: controller.progressVisibility.value,
//                  //       child: const LinearProgressIndicator(
//                  //         backgroundColor: Colors.red,
//                  //       )),
//                  // ),
//               ElevatedButton(
//                   onPressed: controller.progressVisibility.value ? null : () async{
//                     controller.trimmer.dispose();
//                  await controller.saveVideo();
//                  Future.delayed(Duration(seconds: 3)).then((value) {
//                    CircularProgressIndicator();
//                  });
//                    print("The data is $videoPath");
//                    if(videoPath != "" || videoPath != null) {
//                      String path = videoPath!;
//                      File file = File(videoPath!);
//                      // File inputFile = File(widget.filePath);
//                      if(await file.exists()){
//                        // await controller.convertVideo(widget.filePath,path);
//
//                        // final transcodedFile = await VideoEdi.convert(originalFile, targetFormat);
//                        Get.snackbar("Trim Video","Successfully trim video");
//                        Get.off(VideoSelectionScreen(selectedVideos: [file],));
//                      }else{
//                        print("file is not exist");
//                      }
//                    }
//                   },
//                   child: Text('Save Video')
//               ),
//               Expanded(
//                 child: VideoViewer(
//                   trimmer: controller.trimmer,
//                 ),
//               ),
//               Center(
//                 child: TrimViewer(
//                   trimmer: controller.trimmer,
//                   viewerHeight: 50,
//                   viewerWidth: Get.width,
//                    maxVideoLength: Duration(
//                      seconds: controller.trimmer.videoPlayerController!.value.duration.inSeconds),
//                   onChangeStart: (Value) {
//                     controller.startValue = Value;
//                   },
//                   onChangeEnd: (Value) {
//                     controller.endValue = Value;
//                   },
//                   onChangePlaybackState: (isPlaying) {
//                     controller.isPlaying.value = false;
//                   },
//                    ),
//                 ),
//               TextButton(
//                   onPressed: () async{
//                     bool playerBackState = await controller.trimmer.videoPlaybackControl(startValue: controller.startValue, endValue: controller.endValue);
//                    controller.isPlaying.value = playerBackState;
//                     },
//                   child: controller.isPlaying.value ?
//                   const Icon(Icons.pause,size: 80,color: Colors.white,) :
//                   const Icon(Icons.play_arrow,size: 80,color: Colors.white,)
//               )
//             ],
//           ),
//         ),
//       ),
//
//     );
//   }
// }
