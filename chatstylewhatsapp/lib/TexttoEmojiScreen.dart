import 'package:chatstylewhatsapp/Constant.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'dart:ui' as ui;
import 'package:share_plus/share_plus.dart';

class TextToEmojiScreen extends StatefulWidget {
  const TextToEmojiScreen({super.key});

  @override
  State<TextToEmojiScreen> createState() => _TextToEmojiScreenState();
}

class _TextToEmojiScreenState extends State<TextToEmojiScreen> {
  bool emojiShowing = false;
  List<String> savetext = [];
  bool valid = false;
  String _emojiPattern = '';
  String _CopyemojiPattern = '';
  var getEmoji;

  final Map<String, dynamic> pixelMapping = {
    'x': ' ',
    ' ': ' ',
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool validtext = false;
  bool validemoji = false;
  TextEditingController _TextController = TextEditingController();
  TextEditingController _EmojiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!
            .unfocus(disposition: UnfocusDisposition.previouslyFocusedChild);
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Image.asset("asset/images/left-chevron.png", height: 25),
            ),
            centerTitle: true,
            title: const Text("Text To Emoji",
                style: TextStyle(
                    fontFamily: "Baloo",
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(
                      255,
                      251,
                      246,
                      250,
                    ))),
            backgroundColor: const Color.fromARGB(255, 40, 159, 72),
          ),
          body: SizedBox(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 1.0,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, right: 15.00, left: 15.00, bottom: 10),
                  child: TextFormField(
                    controller: _TextController,
                    decoration: InputDecoration(
                      hintText: "Enter Text",
                      hintStyle: const TextStyle(
                          leadingDistribution:
                              TextLeadingDistribution.proportional),
                      errorText: validtext ? "Please Fill Text" : null,
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, right: 15.00, left: 15.00, bottom: 10),
                  child: TextFormField(
                    onChanged: (v) {
                      setState(() {});
                    },
                    controller: _EmojiController,
                    readOnly: true,
                    decoration: InputDecoration(
                      errorText: validemoji ? "Please Select Emoji" : null,
                      hintText: "Select Emoji",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _EmojiController.clear();
                        },
                      ),
                      prefixIcon: SizedBox(
                        height: 40,
                        width: 40,
                        child: IconButton(
                          icon: Image.asset("asset/images/emoji.png"),
                          onPressed: () {
                            FocusManager.instance.primaryFocus!.unfocus();
                            setState(() {
                              emojiShowing = !emojiShowing;
                              if (emojiShowing == true) {
                                openEmojiBox();
                              }
                            });
                          },
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, right: 15.00, left: 15.00, bottom: 10),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        style: BorderStyle.solid,
                        width: 1,
                      ),
                    ),
                    child: SingleChildScrollView(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(valid ? _emojiPattern : '',
                          style: TextStyle(fontSize: 24,textBaseline: TextBaseline.ideographic),
                          textAlign: TextAlign.left),
                    )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 4,
                                backgroundColor:
                                    Color.fromARGB(255, 201, 249, 213)),
                            onPressed: () {
                              setState(() {
                                if (_TextController.text.isNotEmpty &&
                                    _EmojiController.text.isNotEmpty) {
                                  _generateEmojiPattern();
                                  valid = true;
                                }
                                _TextController.text.isEmpty
                                    ? validtext = true
                                    : validtext = false;
                                _EmojiController.text.isEmpty
                                    ? validemoji = true
                                    : validemoji = false;
                              });
                            },
                            child: const Text(
                              "Generate",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "poppins",
                                  color: Color.fromARGB(
                                    255,
                                    40,
                                    159,
                                    72,
                                  )),
                            )),
                      ),
                      SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 4,
                                backgroundColor:
                                    const Color.fromARGB(255, 201, 249, 213)),
                            onPressed: () {
                              setState(() {
                                     if(_CopyemojiPattern.characters.first.startsWith(" ")){
                                       _CopyemojiPattern = "\u00A0" + _CopyemojiPattern;
                                     }
                                  Share.share(
                                    _CopyemojiPattern,
                                  );
                                _TextController.text.isEmpty
                                    ? validtext = true
                                    : validtext = false;
                                _EmojiController.text.isEmpty
                                    ? validemoji = true
                                    : validemoji = false;
                              });
                            },
                            child: const Text(
                              "Share",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "poppins",
                                  color: Color.fromARGB(
                                    255,
                                    40,
                                    159,
                                    72,
                                  )),
                            )),
                      ),
                    ],
                  ),
                ),
              ]))),
    );
  }

  void updatePixelMappingWithEmoji(String emoji) {
    setState(() {
      pixelMapping['x'] = emoji;
    });
  }

  void _generateEmojiPattern() {
    var text = _TextController.text;
    List<String> lines = [];

    for (int i = 0; i < text.length; i++) {
      int consecutiveSpaces = 0;
      if (getConstant().letterPatterns.containsKey(text[i])) {
        List<String> pattern = getConstant().letterPatterns[text[i]]!;
        // print("pattern is $pattern");
        // print("length : ${pattern.length}");
        for (int i = 0; i < pattern.length; i++) {
          String line = '';
          for (int j = 0; j < pattern[i].length; j++) {
            String pixel;
            pixel = pattern[i][j];
            if (pixel == "x") {
              line += pixelMapping[pixel];
              consecutiveSpaces = 0; // Reset consecutive spaces count
            } else if (pixel == " ") {
              consecutiveSpaces++;
            } else if (pixel == "\t") {
              line += "\t";
              consecutiveSpaces = 0; // Reset consecutive spaces count
            } else {
              // Handle other characters
              line += pixelMapping["\u0020"];
              consecutiveSpaces = 0;
            }
            // Append consecutive spaces if any
            if (consecutiveSpaces > 0) {
              line += pixelMapping[" "] *
                  consecutiveSpaces; // Use space from pixelMapping
            }
          }
          lines.add(line);
        }
        lines.add("\n");
      } else {
        lines.add('Letter pattern not available\n');
      }

      setState(() {
        _emojiPattern = lines.join('\n');
        _CopyemojiPattern = _emojiPattern;
      });
    }
  }

  void openEmojiBox() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      builder: (context) {
        return Container(
          height: 270,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                setState(() {
                  _EmojiController.text = emoji.emoji;
                  emojiShowing = !emojiShowing;
                  updatePixelMappingWithEmoji(emoji.emoji);
                });
              },
              config: const Config(
                columns: 7,
                emojiSizeMax: 32,
                verticalSpacing: 0,
                horizontalSpacing: 0,
                gridPadding: EdgeInsets.zero,
                initCategory: Category.RECENT,
                bgColor: Color(0xFFF2F2F2),
                indicatorColor: Colors.blue,
                iconColor: Colors.grey,
                iconColorSelected: Colors.blue,
                backspaceColor: Colors.blue,
                skinToneDialogBgColor: Colors.white,
                skinToneIndicatorColor: Colors.grey,
                enableSkinTones: true,
                recentTabBehavior: RecentTabBehavior.RECENT,
                recentsLimit: 28,
                noRecents: Text(
                  'No Recents',
                  style: TextStyle(fontSize: 20, color: Colors.black26),
                  textAlign: TextAlign.center,
                ),
                loadingIndicator: SizedBox.shrink(),
                tabIndicatorAnimDuration: kTabScrollDuration,
                categoryIcons: CategoryIcons(),
                buttonMode: ButtonMode.CUPERTINO,
              )),
        );
      },
    );
  }
}
