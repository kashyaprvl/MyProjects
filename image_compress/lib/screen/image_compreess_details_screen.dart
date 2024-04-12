import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_compress/utlis/uiUtils.dart';
import 'package:image_compress/widget/appbar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../model/hivedatamodel.dart';
import '../utlis/colors.dart';
import 'history_screen.dart';

class ImageDetailsScreen extends StatefulWidget {
  final List<String> originalImagePaths;
  final List<String> compressedImagePaths;
  final List<String> originalSizes;
  final List<String> compressedSizes;

  ImageDetailsScreen({
    required this.originalImagePaths,
    required this.compressedImagePaths,
    required this.originalSizes,
    required this.compressedSizes,
  });

  @override
  State<ImageDetailsScreen> createState() => _ImageDetailsScreenState();
}

class _ImageDetailsScreenState extends State<ImageDetailsScreen> {
  int totalSize = 0;

  late List<VideoPlayerController> _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = List.generate(widget.compressedImagePaths.length, (index) => VideoPlayerController.file(File(widget.compressedImagePaths[index]))..initialize().then((value) { setState(() {});}));
    calculateTotalSize();
  }

  Future<void> calculateTotalSize() async {
    List<File> imageFiles = [];
    for (String tempStrin in  widget.compressedImagePaths ){
      imageFiles.add(File(tempStrin));
    }
    int calculatedSize = 0;

    for (File file in imageFiles) {
      int fileSize = await file.length();
      calculatedSize += fileSize;
    }

    setState(() {
      totalSize = calculatedSize;
    });
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
            _videoPlayerController.every((element) { element.pause(); return true; });
        },
        rightIconPath: "assets/svg/download_svg.svg",
        rightOnPressed: (){
            print("object my work is clicked");
            _videoPlayerController.every((element) { element.pause(); return true; });
            Navigator.push(context, MaterialPageRoute(builder: (context) => ImageHistoryList()));
        },
      ),
      body:
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),

          child: Padding(
            padding:   EdgeInsets.symmetric(horizontal: 30.w,vertical:  30.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              if( widget.originalImagePaths.length > 1)...[
                Column(
                  children: [
                    Container(
                      height: UIUtils.appHeight(context) * 0.6,
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
                                child: Text("${widget.compressedImagePaths.length} Videos",style: GoogleFonts.mulish(fontWeight: FontWeight.w600,color: AppColor.borderWhiteColors,),)
                              )
                            ],
                          ),

                          const  SizedBox(height: 10,),
                          SizedBox(
                            height: UIUtils.appHeight(context) * 0.45,
                            child: ListView.builder(
                                 scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: widget.compressedImagePaths.length ,
                                itemBuilder: (context,index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DottedBorder(
                                      padding: EdgeInsets.all(5),
                                      color: AppColor.cardBackgroungDarkColor,
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                height: UIUtils.appHeight(context) * 0.35,
                                                width: UIUtils.appWidth(context) * 0.3,// width: 250,
                                                // width: 250,
                                                // decoration: BoxDecoration(
                                                //     // borderRadius: BorderRadius.circular(15),
                                                //     image: DecorationImage(
                                                //       image: FileImage(File(widget.compressedImagePaths![index])),
                                                //     )
                                                // ),
                                              child: AspectRatio(
                                                aspectRatio: _videoPlayerController[index].value.aspectRatio,
                                                child: GestureDetector(
                                                  onTap: (){
                                                    setState(() {});
                                                    _videoPlayerController[index].value.isPlaying ? _videoPlayerController[index].pause() : _videoPlayerController[index].play();
                                                  },
                                                  child: VideoPlayer(
                                                    _videoPlayerController[index],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: UIUtils.appWidth(context) * 0.4,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      text: 'Compress Size:',
                                                      style: GoogleFonts.mulish(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),
                                                      children: [
                                                        TextSpan(
                                                          text: ' ${UIUtils.formatFileSize(File(widget.compressedImagePaths[index]).lengthSync())}',
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
                                                          text: ' ${UIUtils.formatFileSize(File(widget.originalImagePaths[index]).lengthSync())}',
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
                                    ),
                                  );
                                }
                            ),
                          ),

                        ],
                      ),
                    ),

                    SizedBox(height: 15,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Save Tap  Single image Code

                        Container(
                          width: UIUtils.appWidth(context) * 0.4,
                          height: 35,
                          decoration: BoxDecoration(
                              color: AppColor.cardBackgroungDarkColor,
                              borderRadius: BorderRadius.circular(35)

                          ),
                          child: InkWell(
                            onTap: ()async{
                              print("object multiple path is ${widget.originalImagePaths}");
                              List<ImageHistory> newHistory = [];

                              for(int i = 0 ;i < widget.compressedImagePaths.length;i++) {
                                newHistory.add(ImageHistory(
                                  originalPath: widget.originalImagePaths[i],
                                  compressedPath: widget.compressedImagePaths[i],
                                  timestamp: DateTime.now(),
                                ));
                              }

                              // Save the ImageHistory
                              await UIUtils.saveImageHistory(newHistory);

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
                          /// Share Single Image Tap Code
                          child: InkWell(
                            onTap: (){
                              UIUtils.shareImage(widget.compressedImagePaths);
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
                    /// Download Single Image  Tap Code
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
                          UIUtils.appImageSaveDownload(widget.compressedImagePaths);
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
              if(widget.originalImagePaths.length == 1)...[
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.h,vertical: 20.h),
                      height: UIUtils.appHeight(context) * 0.52,
                      width: UIUtils.appWidth(context) ,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color.fromRGBO(255, 255, 255, 1),
                          boxShadow: [
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
                                  // borderRadius: BorderRadius.circular(15),
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
                                padding: EdgeInsets.all(5),
                                color: AppColor.cardBackgroungDarkColor,
                                child: Container(
                                  height: UIUtils.appHeight(context) * 0.3,
                                  width: UIUtils.appWidth(context) * 0.33,
                                  // height: 150,
                                  // width: UIUtils.appWidth(context) * 0.37,
                                  child: AspectRatio(
                                    aspectRatio: _videoPlayerController.last.value.aspectRatio,
                                    child: GestureDetector(
                                      onTap: (){
                                        setState(() {});
                                        _videoPlayerController.last.value.isPlaying ? _videoPlayerController.last.pause() : _videoPlayerController.last.play();
                                      },
                                      child: VideoPlayer(
                                        _videoPlayerController.last,
                                      ),
                                    ),
                                  ),
                                ),

                              ),

                              SizedBox(width: 8,),
                              DottedBorder(
                                padding: EdgeInsets.all(5),
                                color: AppColor.cardBackgroungDarkColor,
                                child: Container(
                                  height: UIUtils.appHeight(context) * 0.3,
                                  width: UIUtils.appWidth(context) * 0.33,
                                  // decoration: BoxDecoration(
                                  //   // borderRadius: BorderRadius.circular(15),
                                  //   image: DecorationImage(
                                  //     image:  FileImage(File(widget.compressedImagePaths.first)),fit: BoxFit.contain
                                  //   )
                                  // ),
                                  child: AspectRatio(
                                    aspectRatio: _videoPlayerController.last.value.aspectRatio,
                                    child: GestureDetector(
                                      onTap: (){
                                        setState(() {});
                                        _videoPlayerController.last.value.isPlaying ? _videoPlayerController.last.pause() : _videoPlayerController.last.play();
                                      },
                                      child: VideoPlayer(
                                        _videoPlayerController.last,
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
                              Container(
                                height: 50,
                                width: UIUtils.appWidth(context) * 0.33,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Before",style: GoogleFonts.mulish(fontWeight: FontWeight.w500,fontSize: 16.sp),),
                                    Text("${UIUtils.formatFileSize(File(widget.originalImagePaths.first).lengthSync())}",style: GoogleFonts.mulish(fontWeight: FontWeight.w500,fontSize: 16.sp,color: Color.fromRGBO(161, 161, 161, 1)),)
                                  ],
                                ),
                              ),

                              SizedBox(width: 15,),

                              Container(
                                height: 50,
                                width: UIUtils.appWidth(context) * 0.33,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("After",style: GoogleFonts.mulish(fontWeight: FontWeight.w500,fontSize: 16.sp),),
                                    Text("${UIUtils.formatFileSize(File(widget.compressedImagePaths.first).lengthSync())}",style: GoogleFonts.mulish(fontWeight: FontWeight.w500,fontSize: 16.sp,color: Color.fromRGBO(161, 161, 161, 1)),)
                                  ],
                                ),
                              ),

                            ],
                          )



                        ],
                      ),
                    ),

                    SizedBox(height: 15,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Save Tap  Single image Code

                        Container(
                          width: UIUtils.appWidth(context)  *0.4,
                          height: 35,
                          decoration: BoxDecoration(
                            color: AppColor.cardBackgroungDarkColor,
                            borderRadius: BorderRadius.circular(35)

                          ),
                          child: InkWell(
                            onTap: ()async{
                              List<ImageHistory> newHistory = [];

                              for(int i = 0 ;i < widget.compressedImagePaths.length;i++) {
                                newHistory.add(ImageHistory(
                                  originalPath: '${widget.originalImagePaths[i]}',
                                  compressedPath: '${widget
                                      .compressedImagePaths[i]}',
                                  timestamp: DateTime.now(),
                                ));
                              }


                              // Save the ImageHistory
                              await UIUtils.saveImageHistory(newHistory);

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
                          /// Share Single Image Tap Code
                          child: InkWell(
                            onTap: (){
                              UIUtils.shareImage(widget.compressedImagePaths);
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
                    /// Download Single Image  Tap Code
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

                            UIUtils.appImageSaveDownload(widget.compressedImagePaths);

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
