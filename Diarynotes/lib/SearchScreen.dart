import 'package:diarynotes/Data_Manager/Constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'Data_Manager/AppController.dart';
import 'Data_Manager/CreateStoreForObjectBox.dart';
import 'Data_Manager/ObjectBoxDataModel.dart';
import 'WriteDiary/WriteDiary.dart';
import 'main.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchController = TextEditingController();
  List<fileCreate> fileCreateData = [];
  int emojiSelectedIndexFromWriteDiary = -1;

  @override
  void initState() {
    checkEmojiSelection();
    super.initState();
  }

  checkEmojiSelection() async{
    emojiSelectedIndexFromWriteDiary = await AppController().readInt("setEmojiSelection");
  }

  @override
  Widget build(BuildContext context) {
    var objectBox = Provider.of<ObjectBox>(context);
    var tagData = objectBox.store.box<TagDataEntity>().getAll();
    fileCreateData.clear();
    List<fileCreate> checkFileList = userBox.getAll();
    checkFileList.forEach((element) {
      String searchText = searchController.text.trim();
      if(element.title.startsWith(searchText) || element.title == searchText){
         fileCreateData.add(element);
      }
    });
    return Scaffold(
       body: SafeArea(
         child: SingleChildScrollView(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisSize: MainAxisSize.max,
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               Padding(
                 padding: const EdgeInsets.only(right:  8.0),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     IconButton(onPressed: (){ Navigator.pop(context); }, icon: Icon(Icons.arrow_back_ios_rounded)),
                     Expanded(child: TextField(onChanged: (v){
                       setState(() {

                       });
                     },controller: searchController,textAlign: TextAlign.start,decoration: InputDecoration(border: UnderlineInputBorder( borderSide: BorderSide(color: Colors.black)),focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black))),))
                   ],
                 ),
               ),
               SingleChildScrollView(
                 child: Padding(
                   padding: const EdgeInsets.only(right: 8.0,left: 8.0,top: 12),
                   child: SizedBox(
                     child: searchController.text.isEmpty ? Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         const Padding(
                           padding: EdgeInsets.only(left: 8.0,top: 8),
                           child: Text("Tag hot",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                         ),
                         const SizedBox(height: 20),
                         Padding(
                           padding: const EdgeInsets.only(left: 10.0,right: 20,bottom: 10),
                           child: ListView.builder(
                             itemCount: tagData.length,
                             shrinkWrap: true,
                             itemBuilder: (context, index) {
                               return Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 mainAxisSize: MainAxisSize.min,
                                 children: [
                                   Padding(
                                     padding: const EdgeInsets.only(bottom: 8.0),
                                     child: Container( padding: EdgeInsets.all(10),decoration : BoxDecoration(border: Border.all(width: 0.8),color : Colors.white,borderRadius: BorderRadius.circular(8)),
                                         child: Text("#${tagData[index].strings.first.value}",textAlign: TextAlign.left)),
                                   ),
                                 ],
                               );
                             },
                           ),
                         ),
                       ],
                     ) :  SizedBox(
                       height: MediaQuery.sizeOf(context).height * 0.9,
                       child: ListView.builder(
                         padding: EdgeInsets.symmetric(horizontal: 0.15.inches),
                         itemCount: fileCreateData.length,
                         shrinkWrap: true,
                         physics: const ScrollPhysics(),
                         itemBuilder: (context, index) {
                           var date= fileCreateData[index].dateTime;
                           var formattedDate = DateFormat("dd MMM").format(DateTime.parse(date.toString()));
                           return Padding(
                             padding: EdgeInsets.only(bottom: 0.1.inches),
                             child: GestureDetector(
                               onTap: (){
                                 Navigator.pushNamed(context, "/WriteDiary",arguments: WriteDiary(openListOfFileIndex: index,));
                               },
                               child: SizedBox(
                                 height: 12.h,
                                 child: Card(
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(8),
                                   ),
                                   child: Padding(
                                     padding: EdgeInsets.symmetric(
                                         horizontal: 0.08.inches,
                                         vertical: 0.12.inches),
                                     child: Row(
                                       mainAxisSize: MainAxisSize.max,
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         Column(
                                           mainAxisAlignment:
                                           MainAxisAlignment.spaceAround,
                                           children: [
                                             RichText(
                                               text: TextSpan(
                                                 children: <TextSpan>[
                                                   TextSpan(
                                                     text: formattedDate.substring(0,3), // Extract the first three characters
                                                     style: const TextStyle(
                                                       fontWeight: FontWeight.bold,
                                                       textBaseline: TextBaseline.alphabetic,
                                                       fontSize: 18,
                                                       color: Colors.black,
                                                     ),
                                                   ),
                                                   TextSpan(
                                                     text: formattedDate.substring(3), // The rest of the date
                                                     style: const TextStyle(
                                                         color: Colors.black
                                                     ),
                                                   ),
                                                 ],
                                               ),
                                             ),
                                             CircleAvatar(
                                               minRadius: 15,
                                               backgroundColor: Colors.transparent,
                                               foregroundColor: null,
                                               maxRadius: 15,
                                               child: Image.asset(
                                                 emojiSelectedIndexFromWriteDiary == 1 || emojiSelectedIndexFromWriteDiary == -1  ? constant.tiktokemoji[fileCreateData[index].emoji!] : constant.loosetiktokemoji[fileCreateData[index].emoji!],
                                                 fit: BoxFit.cover,
                                               ),
                                             ),
                                           ],
                                         ),
                                         const VerticalDivider(
                                             indent: 2, endIndent: 2, thickness: 1),
                                         Column(
                                           mainAxisAlignment: MainAxisAlignment.start,
                                           crossAxisAlignment:
                                           CrossAxisAlignment.start,
                                           children: [
                                             Padding(
                                               padding: const EdgeInsets.only(top: 4.0),
                                               child: Text(fileCreateData[index].title,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w600)),
                                             ),
                                             SizedBox(
                                               width: MediaQuery.of(context).size.width * 0.65,
                                               child: Padding(
                                                 padding: const EdgeInsets.only(top: 5.0),
                                                 child: Text(fileCreateData[index].detailsController.first.value,
                                                     style:  const TextStyle(overflow: TextOverflow.ellipsis)),
                                               ),
                                             ),
                                           ],
                                         )
                                       ],
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                           );
                         },
                       ),
                     )
                   ),
                 ),
               ),
             ],
           ),
         ),
       ),
    );
  }
}
