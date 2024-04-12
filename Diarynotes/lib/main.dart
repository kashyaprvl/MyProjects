import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:diarynotes/Data_Manager/CreateStoreForObjectBox.dart';
import 'package:diarynotes/OpenApp/ChooseTheme.dart';
import 'package:diarynotes/SettingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'CalenderScreen.dart';
import 'Connectivity/CheckInternetConnctivity.dart';
import 'Data_Manager/ChangeThemeGlobally.dart';
import 'Data_Manager/Notification_Service.dart';
import 'Data_Manager/ObjectBoxDataModel.dart';
import 'Data_Manager/PageViewController.dart';
import 'Data_Manager/ThemeMode.dart';
import 'Drawer/DiaryLock/CheckPasscode.dart';
import 'Drawer/DiaryLock/DiaryLockScreen.dart';
import 'Drawer/DiaryLock/PatternLockScreen.dart';
import 'Drawer/DiaryLock/PinCodeScreen.dart';
import 'Drawer/NotifyScreen.dart';
import 'Drawer/TagsScreen.dart';
import 'HomeScreenWithFile.dart';
import 'InfomationScreen.dart';
import 'LocalBackUpScreen.dart';
import 'PasswordCheckScreen.dart';
import 'RestoreZipFileScreen.dart';
import 'SearchScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'OpenApp/SplashScreen.dart';
import 'StatisticsScreen.dart';
import 'WriteDiary/AudioFiles.dart';
import 'WriteDiary/DrawScreen.dart';
import 'WriteDiary/WriteDiary.dart';
import 'WriteDiary/emojiSelection.dart';
import 'objectbox.g.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'key',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);
  AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod);

  await ConnectivityService.init();
  await ConnectivityServicetwo.init();

  final directory = await getApplicationDocumentsDirectory();
  store = openStore(directory: p.join(directory.path));

  objectBox = ObjectBox.create(store);
  userBox = objectBox.store.box<fileCreate>();
  themeManager = objectBox.store.box<ThemeSet>();
  try{indexOfTheme = themeManager.getAll().last.selectedTheme ?? 0;}catch(e){ }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ChangeGloballyTheme>(
              create: (_) => ChangeGloballyTheme()),
          ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier()),
        ],
        child: MyApp(),
      ),
    );
  });
  // ObjectBox.create()
}

late Store store;
late ObjectBox objectBox;
late int daysOfMonth;
late  Box<fileCreate> userBox;
late  Box<ThemeSet> themeManager;
late String backgroundImage;
late Color brightBackgroundColor;
late Color lightBackgroundColor;
Color floatingActionButtonColor = const Color.fromARGB(255, 182, 77, 96);
bool isDarkMode = false;
late int indexOfTheme;

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  MyApp();

  int? fileOpenIndexArguments;
  int? selectedMood;
  int? selectTemplateScreen;
  bool? isSelectedFileOpen;
  bool? isNavigateWithDraw;
  bool? isComeToSameScreen;
  List<fileCreate> fileCreateData = [];
  var HomeScreen;
  var drawImage;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return ResponsiveSizer(
      builder: (p0, p1, p2) => MaterialApp(
        navigatorKey: MyApp.navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: themeNotifier.theme!,
        initialRoute: "/",
        onGenerateRoute: (setting) {
          if (setting.name == "/WriteDiary") {
            final args = setting.arguments as WriteDiary;
            fileOpenIndexArguments = args.openListOfFileIndex ?? -1;
            selectedMood = args.mood ?? 0;
            selectTemplateScreen = args.templateTextIndex ?? 0;
            isNavigateWithDraw = args.isNavigateWithDrawScreen ?? false;
            drawImage = args.Image;
          }
          return null;
        },
        routes: {
          "/": (context) => SplashScreen(),
          "/chooseTheme": (context) => ChooseTheme(),
          "/InfoScreen": (context) => InfoScreen(context),
          "/passwordCheckScreen": (context) => PasswordCheckScreen(),
          "/LocalBackupScreen": (context) => LocalBackupScreen(),
          "/NotifyScreen": (context) => NotifyScreen(),
          "/emojiSelection": (context) => emojiSelection(),
          "/DiaryLockScreen": (context) => DiaryLockScreen(),
          "/patternLock": (context) => SetPattern(),
          "/FileScreen": (context) => FileHomeScreen(),
          "/drawScreen": (context) => DrawScreen(),
          "/pinCodeScreen": (context) => PinCodeScreen(),
          "/CheckPasscode": (context) => CheckPasscode(),
          "/TagScreen": (context) => TagScreen(),
          "/SettingScreen": (context) => SettingScreen(),
          "/CalenderScreen": (context) => CalenderScreen(),
          "/StatisticsScreen": (context) => StatisticsScreen(),
          "/SearchScreen": (context) => SearchScreen(),
          "/AudioFile": (context) => AudioFiles(),
          "/restoreZipFileScreen": (context) => RestoreZipFileScreen(),
          "/MultiPageView" : (context) => MultiPageView(),
          "/WriteDiary": (context) => WriteDiary(
              mood: selectedMood,
              openListOfFileIndex: fileOpenIndexArguments,
              isNavigateWithDrawScreen: isNavigateWithDraw,
              Image: drawImage),
        },
      ),
    );
  }
}
