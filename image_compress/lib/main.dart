import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_compress/screen/home_screen.dart';
import 'package:image_compress/screen/splash_acreen.dart';
import 'package:image_compress/utlis/colors.dart';
import 'package:image_compress/utlis/uiUtils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:get/get.dart';

import 'model/hivedatamodel.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(ImageHistoryAdapter());
  boxSaveData = await Hive.openBox<ImageHistory>('imageHistoryBox');
  runApp(MyApp());
}

class ConversionHistory {
  String originalImagePath;
  String compressedImagePath;
  String originalSize;
  String compressedSize;

  ConversionHistory({
    required this.originalImagePath,
    required this.compressedImagePath,
    required this.originalSize,
    required this.compressedSize,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder : (context,_) =>GetMaterialApp(
          debugShowCheckedModeBanner: false,
          // home: HomeScreen(),
          // home: ImageSelectionScreen(),
          routes: {
            '/': (context) => const SplashScreen(),
            "/home": (context) =>   HomeScreen()
          },
          initialRoute: "/",
          // home: SplashScreen(),
          theme: ThemeData(
            appBarTheme: AppBarTheme(
                backgroundColor: AppColor.appBarColors
            ),
            primarySwatch:Colors.blue,
          ),
        )

    );
  }
}
