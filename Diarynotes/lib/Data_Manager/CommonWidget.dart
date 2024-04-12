import 'package:diarynotes/Data_Manager/Constant.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../Connectivity/CheckInternetConnctivity.dart';
import '../WriteDiary/WriteDiary.dart';
import '../main.dart';

class CommonWidgets{

  Widget buildImage(int index, int selectedIndex) {
    List<String> emojiList;
    switch (index) {
      case 0:
        emojiList = constant.StickerEmoji;
        break;
      case 1:
        emojiList = constant.tiktokemoji;
        break;
      case 2:
        emojiList = constant.UnicornEmoji;
        break;
      case 3:
        emojiList = constant.PikachuEmoji;
        break;
      case 4:
        emojiList = constant.CatEmoji;
      default:
        emojiList =  constant.tiktokemoji;
        break;
    }
    // print(" emojiList[selectedIndex] ${ emojiList[selectedIndex]}");
    return Image.asset(
      emojiList[selectedIndex],
      scale:  2.0,
    );
  }
}

class BottomAppBarCreate{

  Widget floatingActionButton(BuildContext context){
    return FloatingActionButton(
      isExtended: true,
      backgroundColor: floatingActionButtonColor,
      onPressed: () {
        Navigator.pushNamed(context, "/WriteDiary",arguments: WriteDiary(mood: 0,));
      },
      child:  Icon(Icons.add,size: 0.55.inches,color: isDarkMode ? Colors.white : Colors.black),
    );
  }
}

class CustomToolBar {

  static toolBar() async{
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(onPressed: (){ }, icon: Icon(Icons.format_bold)),
        IconButton(onPressed: (){ }, icon: Icon(Icons.format_italic)),
        IconButton(onPressed: (){ }, icon: Icon(Icons.format_underline)),
        IconButton(onPressed: (){ }, icon: Icon(Icons.format_bold)),
      ],
    );
  }

}

class BuildGridViewForTabView extends StatefulWidget {
  int? index;
  String? bgImage;
  bool? connectToInternet;
  final Function(String)? callBack;

  BuildGridViewForTabView({Key? key, this.index, this.bgImage, this.connectToInternet,this.callBack}) : super(key: key);

  @override
  _BuildGridViewForTabViewState createState() => _BuildGridViewForTabViewState();
}


class _BuildGridViewForTabViewState extends State<BuildGridViewForTabView> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() async{
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    widget.connectToInternet = await ConnectivityService.isInternetAvailable();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
          stream: ConnectivityServicetwo.isInternetAvailable(),
          builder: (context, snapshot) {
            widget.connectToInternet = snapshot.data ?? false;
            if( widget.connectToInternet == true) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 20,
                  mainAxisExtent: 110,
                ),
                itemCount: constant().tabViewImagesString[widget.index!].length,
                padding: const EdgeInsets.all(10),
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, gridViewIndex) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {});
                      print("this is widget ${widget.bgImage}");
                      String newBgImage = constant().tabViewImagesString[widget
                          .index!][gridViewIndex];
                      widget.callBack?.call(newBgImage);
                    },
                    child: SizedBox(
                      child: gridViewIndex == 0
                          ? Image.asset(
                          "assets/images/Original-cancelImage.jpg",
                          fit: BoxFit.cover)
                          : Image.network(
                          constant().tabViewImagesString[widget
                              .index!][gridViewIndex],
                          fit: BoxFit.cover),
                    ),
                  );
                },
              );
            }else{
              return Center(
                child: Image.asset(
                  "assets/images/wi-fi.gif",
                  scale: 1,
                ),
              );
            }
          }
        );
  }

}

class BulletListBottomSheet extends StatefulWidget {

  bool isClickOnListStyle;
  String bulletSelected;
  Function(String) callBullet;
  Function(bool) callOff;
  BulletListBottomSheet({super.key,required this.isClickOnListStyle,required this.bulletSelected,required this.callBullet,required this.callOff});

  @override
  _bulletListBottomSheetState createState() {
    return _bulletListBottomSheetState();
  }
}

class _bulletListBottomSheetState extends State<BulletListBottomSheet>{
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        height: 40.h,
        decoration:  BoxDecoration(
            color: brightBackgroundColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40))),
        child: Column(children: [
          SizedBox(
            height: 6.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 15.w),
                const Center(
                  child: Text('List Style',
                      style: TextStyle(fontSize: 18)),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        widget.isClickOnListStyle = false;
                        widget.callOff(widget.isClickOnListStyle);
                      });
                    },
                    icon: const Icon(Icons.check)),
              ],
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Flexible(
            child: GridView.builder(
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 18,
                  mainAxisExtent: 80,
                  mainAxisSpacing: 10),
              itemCount: constant.bulletListImage.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      setState(() {});
                      widget.bulletSelected =
                      constant.bulletListIcon[index];
                      widget.callBullet(widget.bulletSelected);
                    },
                    child: Center(
                        child: Image.asset(
                          constant.bulletListImage[index],
                          fit: BoxFit.cover,
                        )));
              },
            ),
          )
        ]));
  }

}

class TextStyleBottomSheet extends StatefulWidget {
  bool? isClickOnTextStyle;
  Function(bool,String)? updateStyleCallback;
  Function(String)? callFontFamily;
  Function(bool)? callBool;
   TextStyleBottomSheet({
    Key? key,
    required this.isClickOnTextStyle,
    required this.updateStyleCallback,
     required this.callFontFamily,
     required this.callBool,
  }) : super(key: key);

  @override
  _TextStyleBottomSheetState createState() => _TextStyleBottomSheetState();
}

class _TextStyleBottomSheetState extends State<TextStyleBottomSheet> {
  bool fontStyleBold = false;
  bool fontStyleItalic = false;
  bool fontStyleUnderline = false;
  bool fontAlignJustify = false;
  bool fontAlignCenter = false;
  bool fontAlignLeft = false;
  bool fontAlignRight = false;
  String fontFamilyIs = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      height: 40.h,
      decoration: BoxDecoration(
        color: brightBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          buildHeader(),
          buildIconButtons(),
          const Divider(thickness: 2),
          buildFontGrid(),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return SizedBox(
      height: 6.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 15.w),
          const Center(
              child: Text('TextStyle', style: TextStyle(fontSize: 18))),
          IconButton(
            onPressed: () =>
                setState(() {
                  widget.isClickOnTextStyle = false;
                  widget.callBool!(widget.isClickOnTextStyle!);
                }),
            icon: const Icon(Icons.check),
          ),
        ],
      ),
    );
  }

  Widget buildIconButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildIconButton(Icons.format_bold, () {
            fontStyleBold = !fontStyleBold;
            return fontStyleBold;
          }, "bold"),
          buildIconButton(Icons.format_italic, () {
            fontStyleItalic = !fontStyleItalic;
            return fontStyleItalic;
          }, "italic"),
          buildIconButton(Icons.format_underline, () {
            fontStyleUnderline = !fontStyleUnderline;
            return fontStyleUnderline;
          }, "underline"),
          buildIconButton(Icons.format_align_justify, () {
            fontAlignJustify = !fontAlignJustify;
            fontAlignCenter = fontAlignLeft = fontAlignRight = false;
            return fontAlignJustify;
          }, "justify"),
          buildIconButton(Icons.format_align_center, () {
            fontAlignCenter = !fontAlignCenter;
            fontAlignLeft = fontAlignRight = fontAlignJustify = false;
            return fontAlignCenter;
          }, "center"),
          buildIconButton(Icons.format_align_left, () {
            fontAlignLeft = !fontAlignLeft;
            fontAlignCenter = fontAlignRight = fontAlignJustify = false;
            return fontAlignLeft;
          }, "left"),
          buildIconButton(Icons.format_align_right, () {
            fontAlignRight = !fontAlignRight;
            fontAlignCenter = fontAlignLeft = fontAlignJustify = false;
            return fontAlignRight;
          }, "right"),
        ],
      ),
    );
  }

  Widget buildIconButton(IconData icon, Function() toggleState,
      String styleType) {
    return IconButton(
      onPressed: () {
        bool newState = toggleState(); // Get the new state
        setState(() {});
        widget.updateStyleCallback!(
            newState, styleType); // Pass the new state and style type back
      },
      icon: Icon(icon),
    );
}

  Widget buildFontGrid() {
    return Flexible(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 18,
          mainAxisExtent: 50,
          mainAxisSpacing: 10,
        ),
        itemCount: constant.Fonts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                fontFamilyIs = constant.Fontfomily[index];
                widget.callFontFamily!(fontFamilyIs);
              });
            },
            child: Container(
              color: lightBackgroundColor,
              child: Center(
                child: Text(
                  constant.Fonts[index],
                  style: TextStyle(
                    fontFamily: constant.Fontfomily[index],
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
