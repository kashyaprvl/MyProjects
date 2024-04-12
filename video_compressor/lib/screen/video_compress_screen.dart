import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:VideoCompress/screen/video_compreess_details_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import '../../widget/appbar.dart';
import '../main.dart';
import '../utlis/colors.dart';
import '../utlis/uiUtils.dart';
import 'history_screen.dart';
import 'package:video_compress/video_compress.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class VideoSelectionScreen extends StatefulWidget {
  List<File>? selectedVideos = [];
  VideoSelectionScreen({super.key,this.selectedVideos});

  @override
  _VideoSelectionScreenState createState() => _VideoSelectionScreenState();
}

class _VideoSelectionScreenState extends State<VideoSelectionScreen> {
  // List<File> _selectedVideos = [];
  double _quality = 50; // Compression quality
  int totalSize = 0;
  int scale = 580;
  String bitrate = "500k";

  late List<VideoPlayerController> _videoPlayer;
  late Subscription _subscription;


  @override
  void initState() {
    super.initState();
      _videoPlayer = List.generate(widget.selectedVideos!.length, (index) => VideoPlayerController.file(File(widget.selectedVideos![index].path))..initialize());
      _subscription = VideoCompress.compressProgress$.subscribe((event) { });
        calculateTotalSize();
  }


  Future<void> calculateTotalSize() async {
    int calculatedSize = 0;

    for (File file in widget.selectedVideos!) {
      int fileSize = await file.length();
      calculatedSize += fileSize;
    }

    setState(() {
      totalSize = calculatedSize;
    });
  }

  Future<XFile?> compressAndConvertToXFile(Uint8List VideoBytes) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = await File('${tempDir.path}/compressed_Video${DateTime.now()}.MP4').writeAsBytes(VideoBytes);
    XFile? file = XFile(tempFile.path);

    return file;
  }

  Future<XFile?> _compressVideo(File file) async {
    final tempDir = await getTemporaryDirectory();
    try {
      final ffmpeg = FlutterFFmpeg();
      final outputPath =
          "${tempDir.path}/compressed_video${DateTime.now()}.mp4";

      final command =
          "-i '${file.path}' -vf scale=$scale:-2 -r 24 -b:v 3k '$outputPath'";
      try {
        await ffmpeg
            .execute(command)
            .then((rc) => print("FFmpeg process exited with rc $rc"));
      } catch (e) {
        print("here to show error $e");
      }
      XFile? temp = XFile(outputPath);
      return temp;
    } catch (e) {
      print("this is error in catch $e");
    }
  }

  void _compressAllVideos() async {
    showDialog(context: context,useSafeArea: true,barrierDismissible: false, builder: (context) {
      return  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
           CircularProgressIndicator(),
          SizedBox(height: 20,),
          // Text("Please wait",style: TextStyle(color: Colors.black,decoration: TextDecoration.none,fontSize: 16),textAlign: TextAlign.center),
        ],
      );
    },);
    List<String> originalVideoPaths = [];
    List<String> compressedVideoPaths = [];
    List<String> originalSizes = [];
    List<String> compressedSizes = [];

    for (var video in widget.selectedVideos!) {
      var compressedVideo = await _compressVideo(video);
      originalVideoPaths.add(video.path);
      compressedVideoPaths.add(compressedVideo!.path);
      File compressedFile = File(compressedVideo.path);
      if (compressedFile.existsSync()) {
        print("File exists.");
        print("File size: ${compressedFile.lengthSync()}");
      } else {
        print("File does not exist.");
      }
      originalSizes.add(_formatFileSize(video.lengthSync()));
      compressedSizes.add(_formatFileSize(File(compressedVideo.path).lengthSync()));
    }
    //
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoDetailsScreen(
          originalVideoPaths: originalVideoPaths,
          compressedVideoPaths: compressedVideoPaths,
          originalSizes: originalSizes,
          compressedSizes: compressedSizes,
        ),
      ),
    ).whenComplete(() {
      _subscription.unsubscribe();
      Navigator.pop(context);
    });
  }

  String _formatFileSize(int bytes) {
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

  @override
  void dispose() async{
    _subscription.unsubscribe();
    for (var controller in _videoPlayer) {
       controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showIcon: true,
        leftIconPath: "assets/svg/back_arrow_svg.svg",
        leftOnPressed: (){
          // _subscription.unsubscribe();
          Navigator.pop(context);
          _videoPlayer.every((element) { element.pause(); return true; });
        },
        rightIconPath: "assets/svg/download_svg.svg",
        rightOnPressed: (){
          _videoPlayer.every((element) { element.pause(); return true; });
          Navigator.push(context, MaterialPageRoute(builder: (context) => VideoHistoryList()));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => VideoHostoryWithSetState()));
        },
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
                   padding: EdgeInsets.only(top: 0.0, left: 30.w, right: 30.w),
          height: UIUtils.appHeight(context),
          child: Padding(
            // padding : EdgeInsets.only(top: UIUtils.appHeight(context)  *0.02,left: 10,right: 10),
            padding: EdgeInsets.only(top: 30.h),
            child: Column(
              children: [
                  /// multipleVideo Compress code
                if(widget.selectedVideos!.length > 1)...[
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromRGBO(255, 255, 255, 1),
                            boxShadow:   const [BoxShadow(
                                color: Color.fromRGBO(233, 233, 233, 0.35),
                                blurRadius: 24,
                                spreadRadius: 1,
                                blurStyle: BlurStyle.solid
                            )]
                        ),
                        padding: EdgeInsets.symmetric(vertical: 25.w,horizontal: 18.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    // borderRadius: BorderRadius.circular(15),
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
                                  child: Text("Original Videos",style: GoogleFonts.mulish(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500
                                  ),),
                                ),
                              ],
                            ),
                           const  SizedBox(height: 10,),
                            SizedBox(
                              height: UIUtils.appHeight(context) * 0.3,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: widget.selectedVideos!.length,
                                itemBuilder: (context,index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: DottedBorder(
                                      // borderPadding: EdgeInsets.symmetric(h: 25.w),
                                      padding: const EdgeInsets.all(5),
                                      color: AppColor.cardBackgroungDarkColor,
                                      child: SizedBox(
                                        height: UIUtils.appHeight(context) * 0.35,
                                        width: UIUtils.appWidth(context) * 0.52,
                                        child: InkWell(   onTap: (){ setState(() {
                                          _videoPlayer.last.value.isPlaying ? _videoPlayer.last.pause() : _videoPlayer.last.play();
                                          print("play");
                                        });},child: AspectRatio(
                                          aspectRatio: _videoPlayer[index].value.aspectRatio,
                                          child: VideoPlayer(/*controller:*/ _videoPlayer[index],
                                            // aspectRatio: _videoPlayer[index].value.aspectRatio,
                                          ),
                                        ))
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${widget.selectedVideos!.length} Videos",style: GoogleFonts.mulish(
                                  textStyle: const TextStyle(fontWeight:  FontWeight.w600,fontSize: 18)
                                ),),
                                Text(UIUtils.formatFileSize(totalSize),style: GoogleFonts.mulish(
                                    textStyle: const TextStyle(fontWeight:  FontWeight.w600,fontSize: 16)),
                                 )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        // height: UIUtils.appHeight(context) * 0.22,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromRGBO(255, 255, 255, 1),
                            boxShadow: const [BoxShadow(
                                color: Color.fromRGBO(233, 233, 233, 0.35),
                                blurRadius: 24,
                                spreadRadius: 1,
                                blurStyle: BlurStyle.solid
                            )]
                        ),
                        // color: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 25.w,horizontal: 18.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    // borderRadius: BorderRadius.circular(15),
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
                                  child: Text("Compress Videos",style: GoogleFonts.mulish(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500
                                  ),),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Center(
                              child:Text("${_quality.toInt()}",style: GoogleFonts.mulish(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500
                              ),),
                            ),
                            Slider(
                              value: _quality,
                              min: 0,
                              max: 100,
                              divisions: 100,
                              label: 'Quality: ${_quality.toInt()}',
                              onChanged: (double value) {
                                setState(() {
                                  _quality = value;
                                  if (_quality >= 0 && _quality <= 10) {
                                    scale = 650;
                                  } else if (_quality >= 11 && _quality <= 20) {
                                    scale = 600;
                                  } else if (_quality >= 21 && _quality <= 30) {
                                    scale = 550;
                                  } else if (_quality >= 31 && _quality <= 40) {
                                    scale = 500;
                                  } else if (_quality >= 41 && _quality <= 50) {
                                    scale = 450;
                                  } else if (_quality >= 51 && _quality <= 60) {
                                    scale = 400;
                                  } else if (_quality >= 60 && _quality <= 70) {
                                    scale = 350;
                                  } else if (_quality >= 71 && _quality <= 80) {
                                    scale = 300;
                                  } else if (_quality >= 81 && _quality <= 90) {
                                    scale = 250;
                                  } else {
                                    scale = 200;
                                  }
                                });
                              },
                              activeColor: AppColor.cardBackgroungDarkColor,
                              inactiveColor: AppColor.cardBackgroungColor,

                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 65.h,),
                      Padding(
                        padding: EdgeInsets.zero,
                        child: InkWell(
                          onTap: _compressAllVideos,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.cardBackgroungDarkColor,
                            ),
                            height: 45,
                            width: double.maxFinite,
                            child: Center(
                              child: Text("Compress Videos".toUpperCase(),style: GoogleFonts.mulish(fontWeight: FontWeight.w600,fontSize: 18.sp,color: Colors.white),),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ),
                ],
                if(widget.selectedVideos!.length == 1)...[
                  Flexible(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: UIUtils.appHeight(context) * 0.55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromRGBO(255, 255, 255, 1),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(233, 233, 233, 0.35),
                                blurRadius: 24,
                                spreadRadius: 1,
                                blurStyle: BlurStyle.solid
                            )]
                          ),
                          padding: EdgeInsets.only(left: 23.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding:   EdgeInsets.symmetric(vertical: 10.w,horizontal: 9.h),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColor.cardBackgroungDarkColor,
                                    ),
                                    height: 35,
                                    width: 35,
                                    child: Padding(
                                      padding: EdgeInsets.zero,
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
                                    padding:   EdgeInsets.only(left: 9.w,top: 7.h,bottom: 6.h),
                                    child: Text("Original video",style: GoogleFonts.mulish(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500
                                    ),),
                                  ),
                                ],
                              ),

                              SizedBox(height: 16.h,),
                              DottedBorder(
                                padding: const EdgeInsets.all(5),
                                color: AppColor.cardBackgroungDarkColor,
                                child: SizedBox(
                                  height: UIUtils.appHeight(context) * 0.35,
                                  width: UIUtils.appWidth(context) * 0.52,
                                  child: InkWell(
                                      onTap: (){ setState(() {
                                    _videoPlayer.last.value.isPlaying ? _videoPlayer.last.pause() : _videoPlayer.last.play();
                                  });},child: AspectRatio(
                                    aspectRatio: _videoPlayer.last.value.aspectRatio,
                                    child: VideoPlayer(/*controller: */_videoPlayer.last,
                                    ),
                                  ))
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0,right: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: 150,
                                        child: Text("${widget.selectedVideos!.length} Video",style: GoogleFonts.mulish(fontSize: 16,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,maxLines: 2,)),
                                    Container(width: UIUtils.appWidth(context) * 0.3,padding:EdgeInsets.only(right: 23.w),child: Text("${_formatFileSize(widget.selectedVideos!.first.lengthSync())}",style: GoogleFonts.mulish(fontSize: 16,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,maxLines: 2,textAlign: TextAlign.end,))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Container(
                          // height: 180.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color.fromRGBO(255, 255, 255, 1),
                              boxShadow: const [BoxShadow(
                                  color: Color.fromRGBO(233, 233, 233, 0.70),
                                  blurRadius: 24,
                                  spreadRadius: 1,
                                  blurStyle: BlurStyle.solid
                              )]
                          ),
                          // color: Colors.red,
                          padding:   EdgeInsets.symmetric(vertical: 23.w,horizontal: 23.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColor.cardBackgroungDarkColor,
                                    ),
                                    height: 35,
                                    width: 35,
                                    child: Padding(
                                      // padding: const EdgeInsets.all(8.0),
                                      padding:   EdgeInsets.symmetric(vertical: 10.w,horizontal: 9.h),
                                      child: SvgPicture.asset(
                                        "assets/svg/splashLogo.svg",
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:   EdgeInsets.only(left: 9.w),
                                    child: Text("Compress Video",style: GoogleFonts.mulish(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500
                                    ),),
                                  ),
                                ],
                              ),
                              SizedBox(height: 9.h,),
                              Center(child: Text("${(_quality.toInt())}",style: GoogleFonts.mulish(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700
                              ),),),
                              SizedBox(
                                width: double.infinity,
                                child: Slider(
                                  value: _quality,
                                  min: 0,
                                  max: 100,
                                  divisions: 100,
                                  label: 'Quality: ${_quality.toInt()}',
                                  onChanged: (double value) {
                                    setState(() {
                                      _quality = value;
                                      if (_quality >= 0 && _quality <= 10) {
                                        scale = 650;
                                      } else if (_quality >= 11 && _quality <= 20) {
                                        scale = 600;
                                      } else if (_quality >= 21 && _quality <= 30) {
                                        scale = 550;
                                      } else if (_quality >= 31 && _quality <= 40) {
                                        scale = 500;
                                      } else if (_quality >= 41 && _quality <= 50) {
                                        scale = 450;
                                      } else if (_quality >= 51 && _quality <= 60) {
                                        scale = 400;
                                      } else if (_quality >= 60 && _quality <= 70) {
                                        scale = 350;
                                      } else if (_quality >= 71 && _quality <= 80) {
                                        scale = 300;
                                      } else if (_quality >= 81 && _quality <= 90) {
                                        scale = 250;
                                      } else {
                                        scale = 200;
                                      }
                                    });
                                  },
                                  activeColor: AppColor.cardBackgroungDarkColor,
                                  inactiveColor: AppColor.cardBackgroungColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 60.h,),
                        Padding(
                          // padding: EdgeInsets.symmetric(horizontal: 28.h),
                          padding: EdgeInsets.zero,
                          child: InkWell(
                            onTap: _compressAllVideos,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColor.cardBackgroungDarkColor,
                              ),
                              height: 45,
                              width: double.infinity,
                              child: Center(
                                child: Text("Compress Video".toUpperCase(),style: GoogleFonts.mulish(fontWeight: FontWeight.w700,fontSize: 18.sp,color: Colors.white),),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
