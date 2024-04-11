import 'package:chatstylewhatsapp/Constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:share_whatsapp/share_whatsapp.dart';

class TextStyleScreen extends StatefulWidget {
  const TextStyleScreen({super.key});

  @override
  State<TextStyleScreen> createState() => _TextStyleScreenState();
}

class _TextStyleScreenState extends State<TextStyleScreen> {


  List<String> convertedTextList = [];
  var Convertto;
  TextEditingController _MsjController = TextEditingController();


  List<String> changedText = [];

  @override
  void initState() {
    super.initState();
    changeTextToOthers();
    // convertString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus!.unfocus(disposition: UnfocusDisposition.previouslyFocusedChild);
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(onPressed: (){
              Navigator.of(context).pop();
            }, icon: Image.asset("asset/images/left-chevron.png",height: 25),),
            centerTitle: true,
            title: const Text("Text Style",
                style: TextStyle(
                    fontFamily: 'Baloo',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(
                      255,
                      251,
                      246,
                      250,
                    ))),
            backgroundColor: Color.fromARGB(255, 40, 159, 72),
          ),
          body: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 20.00, bottom: 10.00, right: 20.00),
                      child: SizedBox(
                          height: 55,
                          width: MediaQuery.of(context).size.width * 1.0,
                          child: TextFormField(
                            controller: _MsjController,
                            onChanged: (v) {
                              setState(() {
                                // convertString();
                                changeTextToOthers();
                              });
                            },
                            decoration: InputDecoration(
                                hintText: "Enter Your Text Here",
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _MsjController.clear();
                                      changeTextToOthers();
                                    });
                                  },
                                  icon: Icon(Icons.close),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide:
                                  BorderSide(style: BorderStyle.solid, width: 4),
                                )),
                          )),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 8.0, right: 20.0,left: 20.00,bottom: 5),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          width: double.maxFinite,
                          child: ListView.builder(
                            itemCount: changedText.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 4.0),
                                child: Container(
                                  width: double.maxFinite,
                                  constraints: BoxConstraints.loose(Size.infinite),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        width: 1,
                                        style: BorderStyle.solid,
                                      ),
                                      // color : Colors.transparent
                                      color: const Color.fromARGB(
                                        255,
                                          201, 249, 213
                                      )
                                    ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.only(top: 10.0),
                                          child: SingleChildScrollView(
                                            child: Text(changedText[index],textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 19)),
                                          )),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                            height : 40,
                                            width: 40,
                                            child: IconButton(
                                              onPressed: () {
                                                ShareWhatsapp().shareText(
                                                  // type: WhatsApp.standard,
                                                    changedText[index]);
                                              },
                                              icon: Image.asset("asset/images/whatsapp.png",fit: BoxFit.contain),
                                            ),
                                          ),
                                          SizedBox(
                                            height : 40,
                                            width: 40,
                                            child: IconButton(
                                              onPressed: () {
                                                Clipboard.setData(ClipboardData(
                                                    text: changedText[index]));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  behavior: SnackBarBehavior.floating,
                                                  clipBehavior:  Clip.hardEdge,
                                                  elevation: 6,
                                                  // width: MediaQuery.of(context).size.width * 0.25,
                                                  content: const Text("Copied",
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                  margin: const EdgeInsets.only(
                                                      bottom: 100,
                                                    left: 155,
                                                    right: 155,
                                                  ),
                                                  backgroundColor: Colors.white,
                                                  dismissDirection: DismissDirection.horizontal,
                                                  shape: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(13),
                                                      borderSide:
                                                      BorderSide(width: 0.1)),
                                                  duration:
                                                  Duration(milliseconds: 2000),
                                                ));
                                              },
                                              icon: Image.asset("asset/images/copy.png",fit: BoxFit.contain),
                                            ),
                                          ),
                                          SizedBox(
                                            height : 40,
                                            width: 40,
                                            child: IconButton(
                                              onPressed: () {
                                                Share.share(changedText[index]);
                                              },
                                              icon: Image.asset("asset/images/share.png",fit: BoxFit.contain),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ]))),
    );
  }

  void changeTextToOthers() {
    changedText.clear();
    String dataValue = _MsjController.text.isEmpty ? "Text Style" :_MsjController.text.trim();
    String s = "";
    print("datavalue--->$dataValue");
    String Heartstyle = "";
    String Manually = "";
    String Manually2 = "";
    String Manually3 = "";
    String Manually4 = "";
    String Manually5 = "";
    String Horizontailblackwhite = "";
    String CurvedAngle = "";
    String SignLine = "";
    String Flowerpot = "";
    String Birthdaytext = "";

    for(var text in dataValue.characters) {
      if(text.trim().startsWith('r\\u') == false) {
        if(!text.contains(" ")) {
          CurvedAngle += "\u29FC" + text + "\u033C\u29FD";
        }
        else {}
          Manually5 += text + "\u0337\u0337";
          Manually3 += text + "\u0366";
      }
      else {
        CurvedAngle += text;
        Manually5 += text;
        Manually3 += text;
        print("hello");
      }
      if (!text.contains(" ")) {
        Heartstyle += "\u2665" + text;
        Manually4 += "\u3010$text\u3011";
        Horizontailblackwhite += text + "\u22B6";
        SignLine += text + "\u223F";
      }
      Manually = '\u2605\u5F61\u005B${dataValue}\u005D\u5F61\u2605';
      Manually2 += text + "\u0489";
      Flowerpot = '\u{1F33C}\u{1F33C}${dataValue}\u{1F33C}\u{1F33C}';
      Birthdaytext = '\u{1F382}\u{1F973}\u30DF\u{1F496}${dataValue}\u{1F496}\u5F61';
    }
    Heartstyle += "\u2665";
    int lengthOfvalue = getConstant().getAllLanguagecode.values.first.length;
    print(lengthOfvalue);
      for(int i=0;i<lengthOfvalue;i++){
        String transValue = '';
        dataValue.split('').toList().every((element) {
          if(getConstant().getAllLanguagecode["$element"] != null) {
            s = String.fromCharCode(int.parse(
                getConstant().getAllLanguagecode["$element"]![i].toString(),
                radix: 16),);
          }
          else{
            s = element;
          }
          transValue+=s;
          return true;
        });
        if(i==3){
          transValue = "\u{1F380}$transValue\u{1F380}";
        }
        if(i==5){
          transValue = "\u{1F60E}\u{1F412}$transValue\u{1F42F}\u{1F525}";
        }
        if(i==19) {
          transValue = "\u{1F341}\u{1F341}$transValue\u{1F341}\u{1F341}";
        }
        if(i==13){
          transValue =  "\u{1F338}\u{1F338}$transValue\u{1F338}\u{1F338}";
        }
        if(i==18){
          transValue = "\u4E00\u2550\u30C7\uFE3B\u0020$transValue\u0020\uFE3B\u30C7\u2550\u4E00";
        }
        changedText.add(transValue);
    }
    setState(() {
      changedText;
      changedText.add(Manually);
      changedText.add(Flowerpot);
      changedText.add(Manually2);
      changedText.add(SignLine);
      changedText.add(Horizontailblackwhite);
      changedText.add(Manually3);
      changedText.add(Birthdaytext);
      changedText.add(Manually4);
      changedText.add(CurvedAngle);
      changedText.add(Manually5);
      changedText.add(Heartstyle);
    });
    // dataValue.replaceAll(dataValue.split('').toList().every((element) => false), replace)
  }

}