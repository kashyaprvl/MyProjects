import 'package:diarynotes/Data_Manager/Constant.dart';
import 'package:diarynotes/Data_Manager/CreateStoreForObjectBox.dart';
import 'package:diarynotes/Data_Manager/ObjectBoxDataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../main.dart';

class TagScreen extends StatefulWidget {
  const TagScreen({super.key});

  @override
  State<TagScreen> createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> {
  @override
  Widget build(BuildContext context) {
    var tagData = objectBox.store.box<TagDataEntity>().getAll();
    return Scaffold(
      backgroundColor: brightBackgroundColor,
        body: SafeArea(
            child: SizedBox(
              height: double.maxFinite,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0,left: 17),
                      child: Row(
                        children: [
                          IconButton(
                            splashRadius: 0.001,
                            alignment: Alignment.centerLeft,
                            iconSize: 30,
                            padding: EdgeInsets.only(right: 7),
                            onPressed: () {
                              Navigator.popAndPushNamed(context,"/SettingScreen");
                            },
                            icon:  const Icon(Icons.arrow_back,),
                          ),
                          const Text(
                            "Tags",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    tagData.isEmpty ? Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 450.px,child: const Center(child: Text("THERE ARE CURRENTLY NO TAGS"))),
                          ],
                        ),
                      ),
                    ) : Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ListView.builder(
                          itemCount: tagData.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("#${tagData[index].strings.first.value}",textAlign: TextAlign.left),
                                const Divider(thickness: 1,)
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ]),
            )));
  }
}
