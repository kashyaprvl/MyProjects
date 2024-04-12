import 'dart:convert';
import 'package:diarynotes/Data_Manager/Constant.dart';
import 'package:diarynotes/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ObjectBoxDataModel.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class AppController {
  late SharedPreferences pref;

  Future<void> setValueBool(String key, bool value) async {
    pref = await SharedPreferences.getInstance();
    pref.setBool(key, value);
  }

  Future<bool> readBool(String key) async {
    pref = await SharedPreferences.getInstance();
    dynamic obj = pref.getBool(key);
    return obj;
  }

  Future<void> setValueInt(String key, int value) async {
    pref = await SharedPreferences.getInstance();
    pref.setInt(key, value);
  }

  Future<int> readInt(String key) async {
    pref = await SharedPreferences.getInstance();
    dynamic obj = pref.getInt(key);
    return obj;
  }

  Future<void> setValueString(String key, String value) async {
    pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }

  Future<String> readString(String key) async {
    pref = await SharedPreferences.getInstance();
    dynamic obj = pref.getString(key);
    return obj;
  }

  Future<void> setValueInEnum(String key, var value) async {
    pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }

  Future<dynamic> readEnum(String key) async {
    pref = await SharedPreferences.getInstance();
    dynamic obj = pref.getString(key);
    return obj;
  }

  Future<void> setIntList(String key, List<int> value) async {
    pref = await SharedPreferences.getInstance();
    final String intListJson = jsonEncode(
        value); // Encode the list, not the SharedPreferences instance
    pref.setString(key, intListJson);
  }

  Future<List<int>> readIntList(String key) async {
    pref = await SharedPreferences.getInstance();
    String? intListJson = pref.getString(key);
    if (intListJson != null) {
      final List<int> intList = List<int>.from(jsonDecode(intListJson));
      return intList;
    } else {
      return [];
    }
  }

  Future<void> setStringList(String key, List<String> value) async {
    pref = await SharedPreferences.getInstance();
    pref.setStringList(key, value);
  }

  Future<List<String>> readStringList(key) async {
    pref = await SharedPreferences.getInstance();
    dynamic obj = pref.getStringList(key);
    return obj ?? [];
  }

  DateTime getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  DateTime getEndOfWeek(DateTime date) {
    return date.add(Duration(days: 7 - date.weekday));
  }

  double parsePercentage(String percentageString) {
    String numericPart = percentageString.replaceAll('%', '').trim();
    return double.parse(numericPart) / 100;
  }


  Future<bool> requestStoragePermission() async {
    final DeviceInfoPlugin info = DeviceInfoPlugin(); // import 'package:device_info_plus/device_info_plus.dart';
    final AndroidDeviceInfo androidInfo = await info.androidInfo;
    debugPrint('releaseVersion : ${androidInfo.version.release}');
    final int androidVersion = int.parse(androidInfo.version.release);
    bool havePermission = false;

    if (androidVersion >= 13) {
      final request = await [
        Permission.videos,
        Permission.photos,
        Permission.manageExternalStorage,
        //..... as needed
      ].request();

      havePermission = request.values.every((status) => status == PermissionStatus.granted);
    } else {
      final status = await Permission.storage.request();
      havePermission = status.isGranted;
    }

    if (!havePermission) {
      await openAppSettings();
    }

    return havePermission;
  }

  int checkDaysOfThisMonth() {
    int thisMonthTimeStamp = DateTime.timestamp().month;
    switch (thisMonthTimeStamp){
      case 1 :
        return daysOfMonth = 31;
      case 2 :
        return daysOfMonth = 29;
      case 3 :
        return daysOfMonth = 30;
      case 4 :
        return daysOfMonth = 30;
      case 5 :
        return daysOfMonth = 31;
      case 6 :
        return daysOfMonth = 30;
      case 7 :
        return daysOfMonth = 31;
      case 8 :
        return daysOfMonth = 31;
      case 9 :
        return daysOfMonth = 30;
      case 10 :
        return daysOfMonth = 31;
      case 11 :
        return daysOfMonth = 30;
      case 12 :
        return daysOfMonth = 31;
      default :
        return 0;
    }
  }

  Future<Color> loadBackgroundBrightColorScreenTheme(int index) async{
    switch (index) {
      case 0 :
       return brightBackgroundColor = Color.fromARGB(255, 13, 19, 33);
      case 1 :
        return brightBackgroundColor = Color.fromARGB(255, 250, 187, 82);
      case 2 :
        return brightBackgroundColor = Color.fromARGB(255, 227, 241, 255);
      case 3:
        return  brightBackgroundColor = Color.fromARGB(255, 34, 16, 32);
      case 4 :
        return  brightBackgroundColor = Color.fromARGB(255, 6, 31, 62);
      case 5 :
        return  brightBackgroundColor = Color.fromARGB(255, 8, 65, 16);
      case 6 :
        return  brightBackgroundColor = Color.fromARGB(255, 248, 196, 81);
      case 7 :
        return  brightBackgroundColor = Color.fromARGB(255, 44, 20, 38);
      case 8 :
        return  brightBackgroundColor = Color.fromARGB(255, 28, 36, 83);
      case 9 :
        return   brightBackgroundColor = Color.fromARGB(255, 25, 43, 53);
      default:
        return Colors.transparent;
    }
  }

  Future<Color> loadBackgroundLightColorScreenTheme(int index) async{
    switch (index) {
      case 0 :
       return lightBackgroundColor = Color.fromARGB(255, 29, 42, 68);
      case 1 :
        return lightBackgroundColor = Color.fromARGB(255, 255, 211, 148);
      case 2 :
        return lightBackgroundColor = Color.fromARGB(255, 170, 213, 249);
      case 3:
        return lightBackgroundColor = Color.fromARGB(255, 63, 31, 61);
      case 4 :
        return lightBackgroundColor = Color.fromARGB(255, 15, 66, 112);
      case 5 :
        return lightBackgroundColor = Color.fromARGB(255, 29, 119, 35);
      case 6 :
        return lightBackgroundColor = Color.fromARGB(255, 255, 218, 142);
      case 7 :
        return  lightBackgroundColor = Color.fromARGB(255, 76, 37, 68);
      case 8 :
        return  lightBackgroundColor = Color.fromARGB(255, 47, 63, 130);
      case 9 :
        return  lightBackgroundColor = Color.fromARGB(255, 52, 89, 102);
      default:
        return Colors.transparent;
    }
  }

  navigatorFloatingActionButtonColor(int index){
    switch (index) {
      case 0 :
        return brightBackgroundColor = Color.fromARGB(255, 182, 77, 96);
      case 1 :
        return brightBackgroundColor = Color.fromARGB(255,255, 211, 148);
      case 2 :
        return brightBackgroundColor = Color.fromARGB(255, 29, 95, 146);
      case 3:
        return  brightBackgroundColor = Color.fromARGB(255, 208, 107, 171);
      case 4 :
        return  brightBackgroundColor = Color.fromARGB(255, 114, 203, 233);
      case 5 :
        return  brightBackgroundColor = Color.fromARGB(255, 30, 119, 35);
      case 6 :
        return  brightBackgroundColor = Color.fromARGB(255, 248, 196, 81);
      case 7 :
        return  brightBackgroundColor = Color.fromARGB(255, 219, 130, 61);
      case 8 :
        return  brightBackgroundColor = Color.fromARGB(255, 255, 201, 126);
      case 9 :
        return   brightBackgroundColor = Color.fromARGB(255, 137, 194, 167);
      default:
        return Color.fromARGB(255, 182, 77, 96);
    }
  }

   loadBackgroundImageTheme(int index){
    switch (index) {
      case 0 :
        return backgroundImage = "assets/ThemeImage/Daily diary Theme-01.jpg";
      case 1 :
        return backgroundImage = "assets/ThemeImage/Daily diary Theme-02.jpg";
      case 2 :
        return backgroundImage = "assets/ThemeImage/Daily diary Theme-03.jpg";
      case 3:
        return backgroundImage = "assets/ThemeImage/Daily diary Theme-04.jpg";
      case 4 :
        return backgroundImage = "assets/ThemeImage/Daily diary Theme-05.jpg";
      case 5 :
        return  backgroundImage = "assets/ThemeImage/Daily diary Theme-06.jpg";
      case 6 :
        return backgroundImage = "assets/ThemeImage/Daily diary Theme-07.jpg";
      case 7 :
        return backgroundImage = "assets/ThemeImage/Daily diary Theme-08.jpg";
      case 8 :
        return backgroundImage = "assets/ThemeImage/Daily diary Theme-09.jpg";
      case 9 :
        return backgroundImage = "assets/ThemeImage/Daily diary Theme-10.jpg";
    }
  }

  String getEmojiAsset(int emojiSelectionIndexCopy,
      int fileOpenListIndexArguments,int index,
      List<fileCreate> fileOpeningData) {
    String emojiAssetPath;
    List<String> emojiList =
    emojiSelectionIndexCopy == 0 || emojiSelectionIndexCopy == -1
        ? constant.StickerEmoji
        : emojiSelectionIndexCopy == 1
        ? constant.tiktokemoji
        : emojiSelectionIndexCopy == 2
        ? constant.UnicornEmoji
        : emojiSelectionIndexCopy == 3
        ? constant.PikachuEmoji
        : constant.CatEmoji;
    int emojiIndex = index;
    emojiAssetPath = emojiList[emojiIndex];
    return emojiAssetPath;
  }
}

class KeyboardUnFocus {

  keyboardOff(BuildContext context){
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

}


class GallerySelectedImageInfo{
  String? id;
  double? height;
  double? width;

  GallerySelectedImageInfo({this.id, this.height, this.width});
}

