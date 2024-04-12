import 'dart:io';
import 'package:diarynotes/Data_Manager/AppController.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:archive/archive.dart';

class ZipFile{


  Future<String> storeDataToZipFile(BuildContext context) async {
   String nowTime = DateFormat("yyyyMMdd_HHmmss").format(DateTime.now());
   bool hasPermission = await AppController().requestStoragePermission();
   final storagePath = Directory("/storage/emulated/0/Download/MyDiaryNotes");
   String res;

   if (hasPermission) {
    if (await storagePath.exists()) {
     res = storagePath.path;
    } else {
     final Directory appDocNewFolder = await storagePath.create(
         recursive: true);
     res = appDocNewFolder.path;
    }

    const path = "/data/data/com.example.diarynotes/app_flutter/data.mdb";
    final bytes = await File(path).readAsBytes();
    final archiveFile = ArchiveFile(
        "DiaryNote$nowTime.mdb", bytes.length, bytes);
    final archive = Archive();
    archive.addFile(archiveFile);
    print("this is archive data ${archive.last.size}");
    final zipEncoder = ZipEncoder();
    final encodeArchive = zipEncoder.encode(archive);
    await File("$res/DiaryNote$nowTime.zip").writeAsBytes(encodeArchive!);

    return '$res/DiaryNote$nowTime.zip';
   }
   else{
    print("Permission denied");
    return "";
   }
  }


  Future<void> restoreDataFromZipFile(BuildContext context, String zipFilePath) async {
   try {
    final bytes = await File(zipFilePath).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    for (var file in archive) {
     List<int> fileData = file.content;
     print("this is fileData is ${file.size}");
     String path = '/data/data/com.example.diarynotes/app_flutter/data.mdb';
     await File(path).writeAsBytes(fileData);
    }
   } catch (e) {
    print('An error occurred while restoring: $e');
   }
  }


}