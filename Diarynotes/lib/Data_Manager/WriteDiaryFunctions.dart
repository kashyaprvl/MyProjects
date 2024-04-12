import 'dart:io';
import 'package:diarynotes/Data_Manager/MediaScanner.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class WriteDiaryFunctions {

  Future<void> startRecording(bool recordingReady,FlutterSoundRecorder recorder) async {
    const status =  Permission.manageExternalStorage;
    print("this is $status");
    if (!recordingReady) return;
    String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    Directory? directory = await getDownloadsDirectory();
    String saveAudioName = '${directory?.path}/DiaryNotes$timestamp.aac'; // Use .aac extension
    try {
      await recorder.startRecorder(
        toFile: '$saveAudioName',
        codec: Codec.aacADTS,
      );
      await MediaScanner.scanFile(saveAudioName);
    } catch (e) {
      print("Error starting recorder: $e");
    }
  }

  Future<List<String>> stopRecording(bool recordingReady,FlutterSoundRecorder recorder) async {
    if(!recordingReady) return [];
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    print("audio path is $audioFile");
    return [audioFile.path];
  }
}
