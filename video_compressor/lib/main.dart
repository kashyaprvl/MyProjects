import 'package:VideoCompress/screen/VideoHistoryController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:VideoCompress/screen/home_screen.dart';
import 'package:VideoCompress/screen/splash_acreen.dart';
import 'package:VideoCompress/utlis/colors.dart';
import 'package:VideoCompress/utlis/uiUtils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
// import 'package:better_player/better_player.dart';
import 'model/hivedatamodel.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(VideoHistoryAdapter());
  // Get.lazyPut<VideoHistoryController>(() => VideoHistoryController(),fenix: true);
  UIUtils.boxSaveData = await Hive.openBox<VideoHistory>('VideoHistoryBox');
  runApp(MyApp());
}

String? videoPath = "";


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
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: AppBarTheme(
                backgroundColor: AppColor.appBarColors
            ),
            primarySwatch:Colors.blue,
          ),
        )
    );
  }
}

/// for show video thumbnail instead of full video
//video_thumbnail