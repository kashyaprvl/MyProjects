import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart' as fp;
import 'package:image_compress/widget/appbar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../screen/image_compress_screen.dart';
import 'history_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  // List<String> originalImagePaths = [];
  // List<String> compressedImagePaths = [];
  // List<String> originalSizes = [];
  // List<String> compressedSizes = [];
  List<File>? selectedImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showIcon: false,
        leftIconPath: "assets/svg/camera_svg.svg",
        leftOnPressed: (){
          getImage("Cemera").then((value) {
            if (value != null) {
              // if(originalImagePaths.isNotEmpty && compressedImagePaths.isNotEmpty && originalSizes.isNotEmpty && compressedSizes.isNotEmpty){
              List<File>  temp = [];
              temp.add(value);
              print("Object of temp value to store in List $temp");
              Navigator.push(context, MaterialPageRoute(builder: (context) => ImageSelectionScreen(selectedImages: temp,) ));
              // }

            }
          });
        },
        rightIconPath: "assets/svg/download_svg.svg",
        rightOnPressed: (){
          print("object");
          Navigator.push(context, MaterialPageRoute(builder: (context)=> ImageHistoryList()));
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
                    boxShadow: [BoxShadow(
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
              radius: Radius.circular(20),
              dashPattern: [10, 5, 10, 5, 10, 5],
              color: Color.fromRGBO(199, 199, 199, 1),
              child: Padding(
                padding:   EdgeInsets.symmetric(vertical: 32.w,horizontal: 121.h),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: (){
                      pickImages().then((value) {
                        if(value!.isNotEmpty && value != null){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ImageSelectionScreen(selectedImages: value,) ));

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
                        SizedBox(height: 10,),
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

  Future<File?> getImage(String type) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(
      source: (type == 'gallery') ? ImageSource.gallery : ImageSource.camera,
    );

    if (pickedFile != null) {
      File? croppedFile = await cropImage(pickedFile.path);
      if (croppedFile != null) {
        setState(() {
          _image = croppedFile;
        });
        print("object  On Camera  ${_image}");
        print("object  getImage On Camera  ${_image!.path}");
        return _image;
      }
    }

    return null;
  }

  Future<List<File>?> pickImages() async {

    // final List<XFile> pickedFiles = await FilePicker.platform.pickFiles(type: FileType.video,withData: true,allowMultiple: true);
    final fp.FilePickerResult? pickedFiles = await fp.FilePicker.platform.pickFiles(type: fp.FileType.video,withData: true,allowMultiple: true);
    if (pickedFiles != null) {
      setState(() {
        selectedImages = pickedFiles.files.map((file) => File(file.path!)).toList();
      });
      // List<File> files = [];

      print("object selecteimage lenth is ${selectedImages!.length}");
      List<File> xFileList = await convertXFilesToFiles(pickedFiles);
      print('xFileList is ${xFileList.last.path}');
      return  xFileList;
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



  Future<File> cropImage(String imagePath) async {
    // originalImagePaths.clear();
    // compressedImagePaths.clear();
    // originalSizes.clear();
    // compressedSizes.clear();
    CroppedFile ? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,


        uiSettings: [

        AndroidUiSettings(
          toolbarColor: Color.fromRGBO(4, 91, 121, 1),
          toolbarWidgetColor: Color.fromRGBO(255, 255, 255, 1),
          // cropGridColor: Color,
          toolbarTitle: 'Crop Image',
          statusBarColor: Color.fromRGBO(4, 91, 121, 1),
          backgroundColor: Color.fromRGBO(4, 91, 121, 1),
          activeControlsWidgetColor: Color.fromRGBO(4, 91, 121, 1),
          // hideBottomControls: true
        ),
        IOSUiSettings(
    title: 'Cropper',
    ),
      ],
      aspectRatioPresets: [
        CropAspectRatioPreset.original,

        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
    );

    return File(croppedFile!.path);
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
}