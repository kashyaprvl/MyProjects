import 'dart:io';
import 'package:diarynotes/Data_Manager/CreateStoreForObjectBox.dart';
import 'package:diarynotes/Data_Manager/ZipFile.dart';
import 'package:diarynotes/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'Data_Manager/AppController.dart';
import 'Data_Manager/ObjectBoxDataModel.dart';
import 'objectbox.g.dart';

class RestoreZipFileScreen extends StatefulWidget {

  RestoreZipFileScreen({super.key,/*this.box*/});

  @override
  State<RestoreZipFileScreen> createState() => _RestoreZipFileScreenState();
}

class _RestoreZipFileScreenState extends State<RestoreZipFileScreen> {

  List<String> zipFileName = [];
  List<FileSystemEntity> files = [];
  List<String> newFileName = [];
  late Directory directory;

  @override
  void initState() {
    checkDirectory();
    super.initState();
  }

  checkDirectory() async*{
    bool hasPermission = await AppController().requestStoragePermission();
    if(hasPermission) {
      directory = Directory("/storage/emulated/0/Download/MyDiaryNotes/");
      var hey  = directory.uri.fragment;
      print("hey $hey");
      if (await directory.exists()) {
        files = directory
            .listSync(recursive: true)
            .where((item) => item.path.endsWith('.zip'))
            .map((item) => item)
            .toList();
      }
      print("this is files $files");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brightBackgroundColor,
      body: SafeArea(
        child: StreamBuilder(
          stream: checkDirectory(),
          builder: (context, snapshot) =>
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                splashRadius: 0.001,
                alignment: Alignment.centerLeft,
                iconSize: 30,
                padding: EdgeInsets.only(left: 20,top: 25),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon:  const Icon(Icons.arrow_back,),
              ),
                  if(files.isNotEmpty)...{
                     Container(
                      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                              child: ListView.builder(
                                itemCount: files.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  String fileName = File(files[index].path).uri.pathSegments.last;
                                  return ListTile(leading: Icon(Icons.file_open,size: 30),minLeadingWidth: 30,title: Text(fileName,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400)),subtitle: Text("Click to restore Data"),
                                  onTap: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return  AlertDialog(
                                          backgroundColor: brightBackgroundColor,
                                          content: const Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CircularProgressIndicator(),
                                              SizedBox(height: 8),
                                              Text("Restoring data..."),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                    final zipFile = ZipFile();
                                    objectBox.store.close();
                                    final directory = await getApplicationDocumentsDirectory();
                                    await ObjectBoxDataManage().deleteFile(dir: directory);
                                    zipFile.restoreDataFromZipFile(context,files[index].path);
                                    store = openStore(directory: (directory.path));
                                    objectBox =  ObjectBox.create(store);
                                    final temporaryBox =  objectBox.store.box<fileCreate>();
                                    themeManager = objectBox.store.box<ThemeSet>();
                                    objectBox.store.box<PasswordManger>();
                                    try{indexOfTheme = themeManager.getAll().last.selectedTheme!;}catch(e){}
                                     final temp =  temporaryBox.getAll();
                                     temporaryBox.removeAll();
                                    temp.forEach((element) {
                                      element.id = 0;
                                      temporaryBox.put(element);
                                      print("this is element ${element.id}");
                                    });
                                    userBox =  temporaryBox;
                                    await Future.delayed(Duration(seconds: 3));
                                    Navigator.of(context).pop();
                                    Fluttertoast.showToast(
                                        backgroundColor: lightBackgroundColor,
                                        msg: "Restore your data Successfully...."
                                    );
                                  },
                                  );
                                },
                              )
                          ),
                        ],
                      ),
                    )
                  }
                  else...{
                  Container(alignment: Alignment.center,child: Text("Ooops! No Restore Files.."))
                }
            ],
          ),
        ),
      ),
    );
  }
}
