import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:VideoCompress/utlis/uiUtils.dart';
import 'package:VideoCompress/widget/appbar.dart';
import '../model/hivedatamodel.dart';
import 'package:video_player/video_player.dart';
import '../utlis/colors.dart';
import 'history_screen.dart';

class VideoDetailsScreen extends StatefulWidget {
  final List<String> originalVideoPaths;
  final List<String> compressedVideoPaths;
  final List<String> originalSizes;
  final List<String> compressedSizes;

  VideoDetailsScreen({
    required this.originalVideoPaths,
    required this.compressedVideoPaths,
    required this.originalSizes,
    required this.compressedSizes,
  });

  @override
  State<VideoDetailsScreen> createState() => _VideoDetailsScreenState();
}

class _VideoDetailsScreenState extends State<VideoDetailsScreen> {
  int totalSize = 0;

  late List<VideoPlayerController> _videoPlayerControllerOriginal;
  late List<VideoPlayerController> _videoPlayerControllerCompressed;
  GlobalKey UniqueKey2 = GlobalKey();
  GlobalKey UniqueKey1 = GlobalKey();

  @override
  void initState() {
    super.initState();
    _videoPlayerControllerOriginal = List.generate(widget.originalVideoPaths.length, (index) =>
        VideoPlayerController.file(File(widget.originalVideoPaths[index]))..initialize());
    _videoPlayerControllerCompressed = List.generate(widget.compressedVideoPaths.length, (index) =>
        VideoPlayerController.file(File(widget.compressedVideoPaths[index]))..initialize());
    calculateTotalSize();
  }

  Future<void> calculateTotalSize() async {
    List<File> VideoFiles = [];
    for (String tempString in  widget.compressedVideoPaths ){
      VideoFiles.add(File(tempString));
    }
    int calculatedSize = 0;

    for (File file in VideoFiles) {
      int fileSize = await file.length();
      calculatedSize += fileSize;
    }

    setState(() {
      totalSize = calculatedSize;
    });
  }

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
  }

  @override
  void dispose() async{
    for (var controller in _videoPlayerControllerOriginal) {
       controller.dispose();
    }
    for (var controller in _videoPlayerControllerCompressed) {
       controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:CustomAppBar(
          showIcon: true,
        leftIconPath: "assets/svg/back_arrow_svg.svg",
        leftOnPressed: (){
            Navigator.pop(context);
        },
        rightIconPath: "assets/svg/download_svg.svg",
        rightOnPressed: (){
            // _videoPlayerController.every((element) { element.dispose(); return true; });
          _videoPlayerControllerOriginal.forEach((element) {  element.value.isPlaying == true ? element.pause() : null;});
          _videoPlayerControllerOriginal.forEach((element) {  element.value.isPlaying == true ? element.pause() : null;});
            Navigator.push(context, MaterialPageRoute(builder: (context) => VideoHistoryList()));
            // Navigator.push(context, MaterialPageRoute(builder: (context) => VideoHostoryWithSetState()));
        },
      ),
      body:
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding:   EdgeInsets.symmetric(horizontal: 30.w,vertical:  30.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              if( widget.originalVideoPaths.length > 1)...[
                Column(
                  children: [
                    Container(
                      // height: UIUtils.appHeight(context) * 0.6,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          boxShadow:   [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              spreadRadius: 0,
                              blurRadius: 1,
                            )
                          ]

                      ),
                      padding: EdgeInsets.symmetric(vertical: 25.w,horizontal: 18.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
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
                                    child: Text("Result Video",style: GoogleFonts.mulish(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500
                                    ),),
                                  ),
                                ],
                              ),
                              Container(
                               padding: EdgeInsets.symmetric(vertical: 5.w,horizontal: 15.h),
                                decoration: BoxDecoration(
                                  color: AppColor.cardBackgroungDarkColor,
                                  boxShadow:const [BoxShadow(
                                      color: Color.fromRGBO(233, 233, 233, 0.35),
                                      blurRadius: 24,
                                      spreadRadius: 0,
                                      blurStyle: BlurStyle.solid
                                  )],
                                  borderRadius: BorderRadius.circular(35)
                                ),
                                child: Text("${widget.compressedVideoPaths.length} Videos",style: GoogleFonts.mulish(fontWeight: FontWeight.w600,color: AppColor.borderWhiteColors,),)
                              )
                            ],
                          ),
                          const  SizedBox(height: 10,),
                          SizedBox(
                            height: UIUtils.appHeight(context) * 0.45,
                            child: ListView.builder(
                                 scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: widget.compressedVideoPaths.length ,
                                itemBuilder: (context,index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DottedBorder(
                                      padding: const EdgeInsets.all(5),
                                      color: AppColor.cardBackgroungDarkColor,
                                      child: Column(
                                        // crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                              height: UIUtils.appHeight(context) * 0.35,
                                              width: UIUtils.appWidth(context) * 0.3,// width: 250,
                                            child: InkWell(
                                                onTap: (){
                                                  setState(() {
                                                    _videoPlayerControllerOriginal[index].value.isPlaying ? _videoPlayerControllerOriginal[index].pause() : _videoPlayerControllerOriginal[index].play();
                                                  print("play");
                                                });},
                                              child: AspectRatio(
                                                aspectRatio: _videoPlayerControllerOriginal[index].value.aspectRatio,
                                                child: VideoPlayer(
                                                  /*controller:*/ _videoPlayerControllerOriginal[index],
                                                  // aspectRatio:  _videoPlayerControllerOriginal[index].value.aspectRatio,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            // width: UIUtils.appWidth(context) * 0.4,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'Compress Size:',
                                                    style: GoogleFonts.mulish(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),
                                                    children: [
                                                      TextSpan(
                                                        text: ' ${UIUtils.formatFileSize(File(widget.compressedVideoPaths[index]).lengthSync())}',
                                                        style: GoogleFonts.mulish(color: Colors.grey.shade400,fontWeight: FontWeight.w600,fontSize: 12),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'Original  Size:',
                                                    style: GoogleFonts.mulish(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),
                                                    children: [
                                                      TextSpan(
                                                        text: ' ${UIUtils.formatFileSize(File(widget.originalVideoPaths[index]).lengthSync())}',
                                                        style: GoogleFonts.mulish(color: Colors.grey.shade400,fontWeight: FontWeight.w600,fontSize: 12),
                                                      ),

                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }
                            ),
                          ),

                        ],
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Save Tap  Single Video Code
                        Container(
                          width: UIUtils.appWidth(context) * 0.4,
                          height: 35,
                          decoration: BoxDecoration(
                              color: AppColor.cardBackgroungDarkColor,
                              borderRadius: BorderRadius.circular(35)
                          ),
                          child: InkWell(
                            onTap: ()async{
                              List<VideoHistory> newHistory = [];
                              for(int i = 0 ;i < widget.compressedVideoPaths.length;i++) {
                                newHistory.add(VideoHistory(
                                  originalPath: widget.originalVideoPaths[i],
                                  compressedPath: widget.compressedVideoPaths[i],
                                  timestamp: DateTime.now(),
                                ));
                              }
                              print("This is newHistroy video $newHistory");
                              await UIUtils.saveVideoHistory(newHistory);
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/save_file.svg",
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(width: 8.w,),
                                Text("SAVE",style: GoogleFonts.mulish(textStyle: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500,color: Colors.white)),)
                              ],
                            ),
                          ),
                        ),

                        Container(
                          width: UIUtils.appWidth(context) * 0.4,
                          height:35,
                          decoration: BoxDecoration(
                              color: AppColor.cardBackgroungLightColor,
                              borderRadius: BorderRadius.circular(35)

                          ),
                          /// Share Single Video Tap Code
                          child: InkWell(
                            onTap: (){
                              UIUtils.shareVideo(widget.compressedVideoPaths);
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/share.svg",
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(width: 8.w,),
                                Text("SHARE",style: GoogleFonts.mulish(textStyle: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500,color: AppColor.appBlackColor)),)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    /// Download Single Video  Tap Code
                    SizedBox(height: UIUtils.appHeight(context) * 0.05,),
                    Container(
                      width: UIUtils.appWidth(context) * 0.89,
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColor.cardBackgroungDarkColor,
                          borderRadius: BorderRadius.circular(35)
                      ),
                      child: InkWell(
                        onTap: (){
                          UIUtils.appVideoSaveDownload(widget.compressedVideoPaths);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("download Video".toUpperCase(),style: GoogleFonts.mulish(textStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: AppColor.borderWhiteColors)),)
                          ],
                        ),
                      ),
                    )

                  ],
                ),
              ],
              if(widget.originalVideoPaths.length == 1)...[
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.h,vertical: 20.h),
                      width: UIUtils.appWidth(context) ,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromRGBO(233, 233, 233, 0.70),
                                blurRadius: 24,
                                spreadRadius: 1,
                                blurStyle: BlurStyle.solid
                            )]
                      ),
                      // color: Colors.red,
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
                                  color: AppColor.cardBackgroungDarkColor,
                                ),
                                height: 35,
                                width: 35,
                                child: Padding(
                                  padding:   EdgeInsets.symmetric(vertical: 10.w,horizontal: 9.h),
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
                                child: Text("Compress Video",style: GoogleFonts.mulish(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500
                                ),),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h,),
                          Row(
                            children: [
                              DottedBorder(
                                padding: const EdgeInsets.all(5),
                                color: AppColor.cardBackgroungDarkColor,
                                child: SizedBox(
                                  height: UIUtils.appHeight(context) * 0.3,
                                  width: UIUtils.appWidth(context) * 0.33,
                                  child: InkWell(
                                    onTap: (){
                                      setState(() {
                                        _videoPlayerControllerOriginal.last.value.isPlaying ? _videoPlayerControllerOriginal.last.pause() : _videoPlayerControllerOriginal.last.play();
                                        print("pause");
                                      });
                                      },
                                    child: AspectRatio(
                                      aspectRatio: _videoPlayerControllerOriginal.last.value.aspectRatio,
                                      child: VideoPlayer(
                                        /*controller:*/ _videoPlayerControllerOriginal.last,
                                        // aspectRatio: _videoPlayerControllerOriginal.last.value.aspectRatio,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8,),
                              DottedBorder(
                                padding: const EdgeInsets.all(5),
                                color: AppColor.cardBackgroungDarkColor,
                                child: SizedBox(
                                  height: UIUtils.appHeight(context) * 0.3,
                                  width: UIUtils.appWidth(context) * 0.33,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _videoPlayerControllerCompressed.last.value.isPlaying ? _videoPlayerControllerCompressed.last.pause() : _videoPlayerControllerCompressed.last.play();
                                        print("play");
                                      });},
                                    child: AspectRatio(
                                      aspectRatio: _videoPlayerControllerCompressed.last.value.aspectRatio,
                                      child: VideoPlayer(
                                       /* controller:*/ _videoPlayerControllerCompressed.last,
                                        // aspectRatio: _videoPlayerControllerCompressed.last.value.aspectRatio,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 8.w,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 50,
                                width: UIUtils.appWidth(context) * 0.33,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Before",style: GoogleFonts.mulish(fontWeight: FontWeight.w500,fontSize: 16.sp),),
                                    Text(UIUtils.formatFileSize(File(widget.originalVideoPaths.first).lengthSync()),style: GoogleFonts.mulish(fontWeight: FontWeight.w500,fontSize: 16.sp,color: Color.fromRGBO(161, 161, 161, 1)),)
                                  ],
                                ),
                              ),
                              const SizedBox(width: 15,),
                              SizedBox(
                                height: 50,
                                width: UIUtils.appWidth(context) * 0.33,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("After",style: GoogleFonts.mulish(fontWeight: FontWeight.w500,fontSize: 16.sp),),
                                    Text(UIUtils.formatFileSize(File(widget.compressedVideoPaths.first).lengthSync()),style: GoogleFonts.mulish(fontWeight: FontWeight.w500,fontSize: 16.sp,color: Color.fromRGBO(161, 161, 161, 1)),)
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Save Tap  Single Video Code
                        Container(
                          width: UIUtils.appWidth(context)  *0.4,
                          height: 35,
                          decoration: BoxDecoration(
                            color: AppColor.cardBackgroungDarkColor,
                            borderRadius: BorderRadius.circular(35)
                          ),
                          child: InkWell(
                            onTap: ()async{
                              List<VideoHistory> newHistory = [];
                              for(int i = 0 ;i < widget.compressedVideoPaths.length;i++) {
                                newHistory.add(VideoHistory(
                                  originalPath: widget.originalVideoPaths[i],
                                  compressedPath: widget.compressedVideoPaths[i],
                                  timestamp: DateTime.now(),
                                ));
                              }
                              // Save the VideoHistory
                              print(newHistory.last.originalPath);
                              await UIUtils.saveVideoHistory(newHistory);
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/save_file.svg",
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(width: 8.w,),
                                Text("SAVE",style: GoogleFonts.mulish(textStyle: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500,color: Colors.white)),)
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: UIUtils.appWidth(context) * 0.4,
                          height: 35,
                          decoration: BoxDecoration(
                            color: AppColor.cardBackgroungLightColor,
                            borderRadius: BorderRadius.circular(35)
                          ),
                          /// Share Single Video Tap Code
                          child: InkWell(
                            onTap: (){
                              UIUtils.shareVideo(widget.compressedVideoPaths);
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/share.svg",
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(width: 8.w,),
                                Text("SHARE",style: GoogleFonts.mulish(textStyle: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500,color: AppColor.appBlackColor)),)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    /// Download Single Video  Tap Code
                   SizedBox(height: 66.h),
                    Padding(
                      padding:   EdgeInsets.symmetric(horizontal: 28.h),
                      child: Container(
                        width: UIUtils.appWidth(context) * 0.89,
                        height: 50,
                        decoration: BoxDecoration(
                            color: AppColor.cardBackgroungDarkColor,
                            borderRadius: BorderRadius.circular(35)
                        ),
                        child: InkWell(
                          onTap: (){
                            UIUtils.appVideoSaveDownload(widget.compressedVideoPaths);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("download Video".toUpperCase(),style: GoogleFonts.mulish(textStyle: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w600,color: AppColor.borderWhiteColors)),)
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ]
            ],),
          ),
        )

    );
  }
}
