import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_compress/screen/image_compreess_details_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import '../../widget/appbar.dart';
import '../utlis/colors.dart';
import '../utlis/uiUtils.dart';
import 'history_screen.dart';
import 'package:video_compress/video_compress.dart';

class ImageSelectionScreen extends StatefulWidget {
  List<File>? selectedImages = [];
  ImageSelectionScreen({super.key,this.selectedImages});

  @override
  _ImageSelectionScreenState createState() => _ImageSelectionScreenState();
}

class _ImageSelectionScreenState extends State<ImageSelectionScreen> {
  // List<File> _selectedImages = [];
  double _quality = 50; // Compression quality
  int totalSize = 0;


  VideoQuality _videoQuality = VideoQuality.DefaultQuality;
  late List<VideoPlayerController> _videoPlayer;
  late Subscription _subscription;


  @override
  void initState() {
    super.initState();
      // print("Selected images ${element.path}");
      _videoPlayer = List.generate(widget.selectedImages!.length, (index) => VideoPlayerController.file(File(widget.selectedImages![index].path))..initialize());
      // _videoPlayer =  VideoPlayerController.file(File(element)..initialize().then((value) { setState(() {});});
      _subscription = VideoCompress.compressProgress$.subscribe((event) { });
        calculateTotalSize();
  }


  Future<void> calculateTotalSize() async {
    int calculatedSize = 0;

    for (File file in widget.selectedImages!) {
      int fileSize = await file.length();
      calculatedSize += fileSize;
    }

    setState(() {
      totalSize = calculatedSize;
    });
  }

  Future<XFile?> compressAndConvertToXFile(Uint8List imageBytes) async {
    // Compress the image (adjust parameters as needed)

    // Create a temporary file
    final tempDir = await getTemporaryDirectory();
    final tempFile = await File('${tempDir.path}/compressed_image${DateTime.now()}.MP4').writeAsBytes(imageBytes);

    // Convert the File to XFile
    XFile? file = XFile(tempFile.path);

    return file;
  }
  Future<XFile?> _compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    MediaInfo? result = await VideoCompress.compressVideo(file.path,deleteOrigin: false,quality: _videoQuality,includeAudio: true);
    Uint8List uint8list = result!.file!.readAsBytesSync();
    XFile? temp = await compressAndConvertToXFile(uint8list)  ;
    return temp;
  }

  void _compressAllImages() async {
    showDialog(context: context,useSafeArea: true,barrierDismissible: false, builder: (context) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           CircularProgressIndicator(),
          SizedBox(height: 20,),
          Text("Please wait....",style: TextStyle(color: Colors.black,decoration: TextDecoration.none,fontSize: 16),textAlign: TextAlign.center),
        ],
      );
    },);
    List<String> originalImagePaths = [];
    List<String> compressedImagePaths = [];
    List<String> originalSizes = [];
    List<String> compressedSizes = [];

    for (var image in widget.selectedImages!) {
      var compressedImage = await _compressImage(image);
      originalImagePaths.add(image.path);
      compressedImagePaths.add(compressedImage!.path);
      originalSizes.add(_formatFileSize(image.lengthSync()));
      compressedSizes.add(_formatFileSize(File(compressedImage.path).lengthSync()));
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageDetailsScreen(
          originalImagePaths: originalImagePaths,
          compressedImagePaths: compressedImagePaths,
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
  void dispose() {
    _subscription.unsubscribe();
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
          _subscription.unsubscribe();
          Navigator.pop(context);
          _videoPlayer.every((element) { element.pause(); return true; });
        },
        rightIconPath: "assets/svg/download_svg.svg",
        rightOnPressed: (){
          _subscription.unsubscribe();
          _videoPlayer.every((element) { element.pause(); return true; });
          Navigator.push(context, MaterialPageRoute(builder: (context) => ImageHistoryList()));
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
                  /// multipleimage Compress code
                if(widget.selectedImages!.length > 1)...[
                Flexible(
                  flex: 2,
                  child:

                  Column(

                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: UIUtils.appHeight(context) * 0.48,
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
                            Container(
                              height: UIUtils.appHeight(context) * 0.3,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: widget.selectedImages!.length,
                                itemBuilder: (context,index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: DottedBorder(
                                      // borderPadding: EdgeInsets.symmetric(h: 25.w),
                                      padding: EdgeInsets.all(5),
                                      color: AppColor.cardBackgroungDarkColor,
                                      child: Container(
                                        height: UIUtils.appHeight(context) * 0.35,
                                        width: UIUtils.appWidth(context) * 0.52,
                                        child: AspectRatio(
                                          aspectRatio: _videoPlayer[index].value.aspectRatio,
                                          child: GestureDetector(
                                            onTap: (){
                                              _videoPlayer[index].value.isPlaying ?  _videoPlayer[index].pause() : _videoPlayer[index].play() ;
                                              setState(() {});
                                            },
                                            child: VideoPlayer(_videoPlayer[index]),
                                          ),
                                        )
                                        // Image.file(
                                        //   widget.selectedImages![index],
                                        //   // fit: BoxFit.contain,
                                        // ),
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

                                Text("${widget.selectedImages!.length} Videos",style: GoogleFonts.mulish(
                                  textStyle: TextStyle(fontWeight:  FontWeight.w600,fontSize: 18)
                                ),),
                                Text('${ UIUtils.formatFileSize(totalSize)}',style: GoogleFonts.mulish(
                                    textStyle: TextStyle(fontWeight:  FontWeight.w600,fontSize: 16)),
                                 )



                              ],
                            ),



                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        height: UIUtils.appHeight(context) * 0.22,
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

                            SizedBox(height: 10,),
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
                                  if (_quality >= 1 && _quality <= 10) {
                                    _videoQuality = VideoQuality.DefaultQuality;
                                    print("object 10");
                                  } else if (_quality >= 11 && _quality <= 20) {
                                    _videoQuality = VideoQuality.DefaultQuality;
                                    print("object 20");
                                  } else if (_quality >= 21 && _quality <= 30) {
                                    // Add more ranges as needed
                                    _videoQuality = VideoQuality.Res960x540Quality;
                                    print("object 30");
                                  } else if (_quality >= 31 && _quality <= 40) {
                                    // Add more ranges as needed
                                    _videoQuality = VideoQuality.Res960x540Quality;
                                    print("object 40");
                                  } else if (_quality >= 41 && _quality <= 50) {
                                    // Add more ranges as needed
                                    _videoQuality = VideoQuality.MediumQuality;
                                    print("object 50");
                                  } else if (_quality >= 51 && _quality <= 60) {
                                    // Add more ranges as needed
                                    _videoQuality = VideoQuality.MediumQuality;
                                    print("object 60");
                                  } else if (_quality >= 60 && _quality <= 70) {
                                    // Add more ranges as needed
                                    _videoQuality = VideoQuality.Res640x480Quality;
                                    print("object  70");
                                  } else if (_quality >= 71 && _quality <= 80) {
                                    // Add more ranges as needed
                                    _videoQuality = VideoQuality.Res640x480Quality;
                                    print("object 80");
                                  } else if (_quality >= 81 && _quality <= 90) {
                                    // Add more ranges as needed
                                    _videoQuality = VideoQuality.LowQuality;
                                    print("object 90");
                                  } else {
                                    // Default values if quality doesn't match any range
                                    _videoQuality = VideoQuality.LowQuality;
                                    print("object default");
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
                        // padding: EdgeInsets.only(left: 15,right: 15),
                        child: InkWell(
                          onTap: _compressAllImages,
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

                /// If Single Image That Design

                if(widget.selectedImages!.length == 1)...[
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
                          // padding: EdgeInsets.only(left: 25,top: 5,bottom: 10,right: 25),
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
                                      // borderRadius: BorderRadius.circular(15),
                                      color: AppColor.cardBackgroungDarkColor,

                                    ),
                                    height: 35,
                                    width: 35,
                                    child: Padding(
                                      // padding:   EdgeInsets.symmetric(vertical: 8.w,horizontal: 7.h),
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
                                padding: EdgeInsets.all(5),
                                color: AppColor.cardBackgroungDarkColor,
                                child: Container(
                                  // height: UIUtils.appHeight(context) * 0.48,
                                  // width: UIUtils.appWidth(context) * 0.8,
                                  height: UIUtils.appHeight(context) * 0.35,
                                  width: UIUtils.appWidth(context) * 0.52,
                                  // width: 250,
                                  // decoration: BoxDecoration(
                                  //   // borderRadius: BorderRadius.circular(15),
                                  //     image: DecorationImage(
                                  //       image: FileImage(widget.selectedImages!.first),
                                  //       fit: BoxFit.contain,
                                  //       alignment: Alignment.center
                                  //
                                  //     )
                                  // ),
                                  child: AspectRatio(
                                    aspectRatio: _videoPlayer.last.value.aspectRatio,
                                     child : GestureDetector(
                                        onTap: (){
                                          _videoPlayer.last.value.isPlaying ?  _videoPlayer.last.pause() : _videoPlayer.last.play() ;
                                          setState(() {});
                                        },
                                    child: VideoPlayer(_videoPlayer.last),
                                      )
                                  )
                                ),
                              ),
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0,right: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: 150,
                                        child: Text("${widget.selectedImages!.length} Video",style: GoogleFonts.mulish(fontSize: 16,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,maxLines: 2,)),
                                    Container(width: UIUtils.appWidth(context) * 0.3,padding:EdgeInsets.only(right: 23.w),child: Text("${_formatFileSize(widget.selectedImages!.first.lengthSync())}",style: GoogleFonts.mulish(fontSize: 16,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,maxLines: 2,textAlign: TextAlign.end,))
                                  ],
                                ),
                              )

                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          height: 180.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromRGBO(255, 255, 255, 1),
                              boxShadow: [BoxShadow(
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
                                      // borderRadius: BorderRadius.circular(15),
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
                                      if (_quality >= 1 && _quality <= 10) {
                                        _videoQuality = VideoQuality.DefaultQuality;
                                        print("object 10");
                                      } else if (_quality >= 11 && _quality <= 20) {
                                        _videoQuality = VideoQuality.DefaultQuality;
                                        print("object 20");
                                      } else if (_quality >= 21 && _quality <= 30) {
                                        // Add more ranges as needed
                                        _videoQuality = VideoQuality.Res960x540Quality;
                                        print("object 30");
                                      } else if (_quality >= 31 && _quality <= 40) {
                                        // Add more ranges as needed
                                        _videoQuality = VideoQuality.Res960x540Quality;
                                        print("object 40");
                                      } else if (_quality >= 41 && _quality <= 50) {
                                        // Add more ranges as needed
                                        _videoQuality = VideoQuality.MediumQuality;
                                        print("object 50");
                                      } else if (_quality >= 51 && _quality <= 60) {
                                        // Add more ranges as needed
                                        _videoQuality = VideoQuality.MediumQuality;
                                        print("object 60");
                                      } else if (_quality >= 60 && _quality <= 70) {
                                        // Add more ranges as needed
                                        _videoQuality = VideoQuality.Res640x480Quality;
                                        print("object  70");
                                      } else if (_quality >= 71 && _quality <= 80) {
                                        // Add more ranges as needed
                                        _videoQuality = VideoQuality.Res640x480Quality;
                                        print("object 80");
                                      } else if (_quality >= 81 && _quality <= 90) {
                                        // Add more ranges as needed
                                        _videoQuality = VideoQuality.LowQuality;
                                        print("object 90");
                                      } else {
                                        // Default values if quality doesn't match any range
                                        _videoQuality = VideoQuality.LowQuality;
                                        print("object default");
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
                            onTap: _compressAllImages,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColor.cardBackgroungDarkColor,
                              ),
                              height: 45,
                              // padding: EdgeInsets.symmetric(vertical: 69.w,horizontal: 14.h),
                              width: double.infinity,
                              child: Center(
                                child: Text("Compress Image".toUpperCase(),style: GoogleFonts.mulish(fontWeight: FontWeight.w700,fontSize: 18.sp,color: Colors.white),),
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
