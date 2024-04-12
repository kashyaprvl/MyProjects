import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart' as fp;
import 'package:VideoCompress/widget/appbar.dart';
import 'package:image_picker/image_picker.dart';
import '../screen/video_compress_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<File>? selectedVideos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showIcon: false,
        leftIconPath: "assets/svg/camera_svg.svg",
        leftOnPressed: (){
         pickVideo().then((value) {
            if (value != null) {
                List<File>  temp = [];
                temp.add(value);
                Navigator.push(context, MaterialPageRoute(builder: (context) => VideoSelectionScreen(selectedVideos: temp,) ));
            }
          });
        },
        rightIconPath: "assets/svg/download_svg.svg",
        rightOnPressed: (){
          // Navigator.push(context, MaterialPageRoute(builder: (context)=> VideoHostoryWithSetState()));
          Navigator.push(context, MaterialPageRoute(builder: (context)=> VideoHistoryList()));
        },
      ),

      body: Padding(
        padding:   EdgeInsets.only(left: 29.w,right: 29.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 55.h,),
            Padding(
              padding:   EdgeInsets.zero,
              child: Center(
                child: Container(
                  padding:    EdgeInsets.symmetric(vertical: 65.w,horizontal: 48.h),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.transparent),
                    boxShadow: const [
                      BoxShadow(
                      color: Color.fromRGBO(233, 233, 233, 0.70),
                      blurRadius: 24,
                      spreadRadius: 0,
                      blurStyle: BlurStyle.solid

                    )]

                  ),
                  child: Image.asset('assets/splashLogo.png', fit: BoxFit.contain,
                    height: 135.h,
                    width: 135.w,),
                ),
              ),
            ),

            SizedBox(height: 108.h,),
            DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(20),
              dashPattern: const [10, 5, 10, 5, 10, 5],
              color: const Color.fromRGBO(199, 199, 199, 1),
              child: Padding(
                padding:   EdgeInsets.symmetric(vertical: 32.w,horizontal: 121.h),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: (){
                      pickVideos().then((value) {
                        if(value!.isNotEmpty){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => VideoSelectionScreen(selectedVideos: value,) ));
                        }
                      });
                    },
                    child: Column(
                      children: [
                        Center(
                          child: SvgPicture.asset(
                            "assets/svg/filter_logo.svg",
                            width: 45,
                            height: 45,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text("Upload video", style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w600, fontSize: 14.sp))
                      ],
                    ),
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  pickVideo() async{
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      File files = File(pickedFile.path);
      return files;
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You have not select video")));
    }

    return null;
  }

  Future<List<File>?> pickVideos() async {
   try{
     final fp.FilePickerResult? pickedFiles = await fp.FilePicker.platform.pickFiles(type: fp.FileType.video,withData: true,allowMultiple: true);
     if (pickedFiles != null) {
       setState(() {
         selectedVideos = pickedFiles.files.map((file) => File(file.path!)).toList();
       });
       List<File> xFileList = await convertXFilesToFiles(pickedFiles);
       return  xFileList;
     }else{
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sorry path not found")));
     }
   }catch(e){
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sorry path not found")));
   }
  }
  Future<List<File>> convertXFilesToFiles(fp.FilePickerResult xFiles) async {
    List<File> files = [];
    xFiles.files.map((e) {
      String file  = e.path!;
      File _File = File(file);
      files.add(_File);
    }).toList();
    return files;
  }

}