import 'dart:io';
import 'package:diarynotes/Data_Manager/AppController.dart';
import 'package:diarynotes/Data_Manager/Constant.dart';
import 'package:diarynotes/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class AudioFiles extends StatefulWidget {
  const AudioFiles({Key? key}) : super(key: key);

  @override
  State<AudioFiles> createState() => _AudioFilesState();
}

class _AudioFilesState extends State<AudioFiles> {

  AudioPlayer audioPlayer = AudioPlayer();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool _hasPermission = false;
  Directory? getDirectory;
  List<String> checkAudioFiles = [];
  List<String> selectedAudioFiles = [];
  List<FileSystemEntity> files = [];

  @override
  void initState() {
    checkAndRequestPermissions();
    super.initState();
  }

  checkAndRequestPermissions({bool retry = false}) async {
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    _hasPermission ? setState(() {}) : null;
     getDirectory = await getExternalStorageDirectory();

    final directory = await getDownloadsDirectory();
    if (await directory!.exists()) {
      files = directory.listSync()
          .where((item) => item.path.endsWith('.aac'))
          .map((item) => item)
          .toList();
    }
    // print("file path is ${files.last.path}");
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: brightBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                  ),
                  const Text(
                    "AudioFile",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async{
                      Navigator.pop(context,selectedAudioFiles);
                      await AppController().setStringList("AudioList", selectedAudioFiles);
                    },
                    icon: const Icon(Icons.check),
                  ),
                ],
              ),
              Center(
                child: FutureBuilder<List<SongModel>>(
                  future: _hasPermission
                      ? _audioQuery.querySongs(
                    uriType: UriType.EXTERNAL,
                    sortType: null,
                    orderType: OrderType.ASC_OR_SMALLER,
                    ignoreCase: false,
                  )
                      : Future.value([]),
                  builder: (context, item) {
                    if (item.hasError) {
                      return Text(item.error.toString());
                    }
                    if (item.data == null) {
                      return const CircularProgressIndicator();
                    }
                    return SingleChildScrollView(
                      child: SizedBox(
                        height: Device.height * 0.9,
                        child: ListView(
                          physics: AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: [
                            ListView.builder(
                              itemCount: files.length,
                              shrinkWrap: true,
                               physics: NeverScrollableScrollPhysics(),
                               itemBuilder: (context, index) {
                                 String fileName = File(files[index].path).uri.pathSegments.last;
                                 return ListTile(
                                   onTap: () {
                                     setState(() {
                                       String audioTitle = fileName;
                                       String? audioUri = files[index].path;
                                       print("Audio uri is $audioUri");
                                       if (checkAudioFiles.contains(audioTitle)) {
                                         checkAudioFiles.remove(audioTitle);
                                       } else {
                                         checkAudioFiles.add(audioTitle);
                                       }
                                       if (selectedAudioFiles.contains(audioUri)) {
                                         selectedAudioFiles.remove(audioUri);
                                       } else {
                                         selectedAudioFiles.add(audioUri);
                                       }
                                     });
                                   },
                                   title: Text(fileName),
                                   subtitle: const Text("Diary recorder"),
                                   trailing: checkAudioFiles.contains(fileName)
                                       ? const Icon(Icons.check_circle)
                                       : const Icon(Icons.circle_outlined),
                                 );
                               },
                            ),
                            ListView.builder(
                              itemCount: item.data!.length,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    setState(() {
                                      String audioTitle = item.data![index].title;
                                      String? audioUri = item.data![index].data;
                                      print("Audio uri is $audioUri");
                                      if (checkAudioFiles.contains(audioTitle)) {
                                        checkAudioFiles.remove(audioTitle);
                                      } else {
                                        checkAudioFiles.add(audioTitle);
                                      }
                                      if (selectedAudioFiles.contains(audioUri)) {
                                        selectedAudioFiles.remove(audioUri);
                                      } else {
                                        selectedAudioFiles.add(audioUri);
                                      }
                                    });
                                  },
                                  title: Text(item.data![index].title),
                                  subtitle: Text(item.data![index].size.toString()),
                                  trailing: checkAudioFiles.contains(item.data![index].title)
                                      ? const Icon(Icons.check_circle)
                                      : const Icon(Icons.circle_outlined),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}