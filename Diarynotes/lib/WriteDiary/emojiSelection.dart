import 'package:diarynotes/Data_Manager/Constant.dart';
import 'package:diarynotes/main.dart';
import 'package:flutter/material.dart';

import '../Data_Manager/ObjectBoxDataModel.dart';

class emojiSelection extends StatefulWidget {
  const emojiSelection({super.key});

  @override
  State<emojiSelection> createState() => _emojiSelectionState();
}

class _emojiSelectionState extends State<emojiSelection> {
  bool selectEmojis = false;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    checkSelectedIndex();
  }

  checkSelectedIndex() async {
    final emojiIndex = objectBox.store.box<EmojiIndex>();
    try {
      selectedIndex = (emojiIndex.getAll().last.emojiSelectedIndex)!;
      print("here i am---->$selectedIndex");
    } catch (e) {
      print("nothing happen bro..");
    }
  }

  @override
  Widget build(BuildContext context) {
    final emojiIndex = objectBox.store.box<EmojiIndex>();
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context, selectedIndex);
                      },
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: Text(
                        "Mood Style",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.85,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child:  ListView.builder(
                            itemCount: constant.emojiTextWhichSelected.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                    emojiIndex.put(EmojiIndex(emojiSelectedIndex: index));
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(constant
                                            .emojiTextWhichSelected[index]),
                                        const Spacer(),
                                        Icon(selectedIndex == index
                                            ? Icons.radio_button_on
                                            : Icons.circle_outlined),
                                      ],
                                    ),
                                    _buildEmojiGrid(index),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
  Widget _buildEmojiGrid(int index) {
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
      default:
        emojiList = constant.CatEmoji;
        break;
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: emojiList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        return Image.asset(
          emojiList[index],
          scale: 2.0,
        );
      },
    );
  }
}
