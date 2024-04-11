import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'DirectChatScreen.dart';
import 'TextRepeatScreen.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

import 'TextStyleScreen.dart';
import 'TexttoEmojiScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  List texts = ["Direct Chat", "Text Repeater", "Text Style", "Text To Emoji"];

  List images = [
    "asset/images/navigation.png",
    "asset/images/repeat.png",
    "asset/images/text.png",
    "asset/images/smile.png"
  ];
  late AnimationController animationController;
  late SequenceAnimation sequenceAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 10000))
      ..repeat(reverse: true);
    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween<double>(begin: -200, end: 0),
            curve: Curves.easeOut,
            from: Duration(milliseconds: 100),
            to: Duration(milliseconds: 3500),
            tag: "move")
        .animate(animationController);
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        top: MediaQuery.of(context).size.aspectRatio * 110,
        child: Image.asset(
          "asset/images/StyleBk.jpg",
          scale: 0.1,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.contain,
        ),
      ),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Let's Chat",
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: "Baloo",
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(
                      255,
                      251,
                      246,
                      250,
                    ))),
            elevation: 10,
            backgroundColor: Color.fromARGB(255, 40, 159, 72),
          ),
          body: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Center(
                    child: SizedBox(
                      width: 304,
                      child: Text(
                          "You can now chat with our app easy and comfortable",
                          style: TextStyle(
                              fontFamily: "futura",
                              color: Color.fromARGB(255, 40, 159, 72),
                              fontSize: 20),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.75,
                    width: MediaQuery.of(context).size.width*0.8,
                    margin: EdgeInsets.only(top: 30),
                    child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                          return  Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: SizedBox(
                              height: 100,
                              child:  GestureDetector(
                               onTap: (){
                                 if (index == 0) {
                                   Navigator.of(context).push(
                                       MaterialPageRoute(
                                           builder: (context) =>
                                               SendMsgScreen()));
                                 } else if (index == 1) {
                                   Navigator.of(context).push(
                                       MaterialPageRoute(
                                           builder: (context) =>
                                               RepeatMsjScreen()));
                                 } else if (index == 2) {
                                   Navigator.of(context).push(
                                       MaterialPageRoute(
                                           builder: (context) =>
                                               TextStyleScreen()));
                                 } else if (index == 3) {
                                   Navigator.of(context).push(
                                       MaterialPageRoute(
                                           builder: (context) =>
                                               TextToEmojiScreen()));
                                 }
                               },
                                child: Card(
                                  color: Color.fromARGB(255,201, 249, 214,),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                           SizedBox(
                                             height: 50,
                                             child: Image.asset(images[index],fit: BoxFit.contain,color: Color.fromARGB(255,40, 159, 72)),
                                           ),
                                           // Padding(padding: const EdgeInsets.(8),
                                           //   child:
                                             AnimatedBuilder(
                                               builder: (context, child) {
                                                 return ClipRect(
                                                   child: Transform.translate(
                                                     offset: Offset(
                                                         sequenceAnimation["move"]
                                                             .value,
                                                         0),
                                                     child: Text(texts[index],
                                                         style: const TextStyle(
                                                             color: Color.fromARGB(
                                                                 255,
                                                                 40, 159, 72),
                                                             fontSize: 16,fontWeight: FontWeight.w600,fontFamily: "geoslab")),
                                                   ),
                                                 );
                                               },
                                               animation: animationController,
                                             ),
                                        ],
                                    ),
                                      ),
                                       Positioned(
                                        top: MediaQuery.of(context).size.aspectRatio * 55,
                                        left: MediaQuery.of(context).size.aspectRatio * 500,
                                          child: Container(
                                            height: 80,
                                            width: 80,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                colors: [Color.fromARGB(255,255, 255, 255),Color.fromARGB(51, 255, 255, 255)],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              )
                                            ),
                                          ))]
                                       ),
                                ),
                              ),
                            ),
                          );
                    },),
                  ),
                ),
              ])),
    ]);
  }
}
