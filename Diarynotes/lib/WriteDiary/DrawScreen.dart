import 'dart:typed_data';
import 'package:diarynotes/Data_Manager/ObjectBoxDataModel.dart';
import 'package:diarynotes/WriteDiary/WriteDiary.dart';
import 'package:diarynotes/main.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:flutter_drawing_board/paint_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import '../Data_Manager/CreateStoreForObjectBox.dart';

class DrawScreen extends StatefulWidget {
  const DrawScreen({super.key});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {

  bool changeSizeOfContainer = false;
  final DrawingController _drawingController = DrawingController();
  double sizeOfEraser = 10;

  @override
  void dispose() {
    _drawingController.dispose();
    super.dispose();
  }

  List<String> brushImages = [
    "assets/images/DrawImages/pencil.png",
    "assets/images/DrawImages/pen.png",
    "assets/images/DrawImages/brush.png",
    "assets/images/DrawImages/eraser.png"
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: brightBackgroundColor,
        body: SafeArea(
            child:
                SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 2),
            child: Row(
              children: [
                IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back,size: 28,)),
                IconButton(
                      onPressed: () {
                        setState(() {
                          changeSizeOfContainer = !changeSizeOfContainer;
                        });
                        // _drawingController.turn();
                      },
                      icon: Icon(Icons.change_circle_outlined)),
                Spacer(),
                IconButton(
                      onPressed: () {
                        _drawingController.undo();
                        setState(() {});
                      },
                      icon: Icon(Icons.undo)),
                IconButton(
                      onPressed: () {
                        setState(() {
                          _drawingController.redo();
                        });
                      },
                      icon: Icon(Icons.redo)),
                GestureDetector(
                      onTap: () async {
                        final Uint8List? data = (await _drawingController.getImageData())?.buffer.asUint8List();
                        var ImageData = objectBox.store.box<ImageDrawData>();
                        ImageData.put(ImageDrawData(data!));
                        print("image draw data ${ImageData.getAll().last.Image}");
                        Navigator.pop(context,data);
                        // Navigator.pushNamed(context, "/WriteDiary", arguments: WriteDiary(isNavigateWithDrawScreen: true, Image: data,));
                        print("this is type of png bytes${data.runtimeType}");
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Text(
                          "Done",
                          style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      )),
              ],
            ),
          ),
          SizedBox(
                height: MediaQuery.of(context).size.height * 0.90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: SizedBox(
                        width: changeSizeOfContainer
                            ? Device.width - 100
                            : Device.width - 50,
                        height: changeSizeOfContainer
                            ? Device.height / 3
                            : Device.height / 3.8,
                        child: DrawingBoard(
                            controller: _drawingController,
                            background: Container(
                              color: Colors.white,
                              width: changeSizeOfContainer
                                  ? Device.width - 100
                                  : Device.width - 50,
                              height: changeSizeOfContainer
                                  ? Device.height / 3
                                  : Device.height / 3.8,
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: SizedBox(
                        height: Device.height / 10,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          itemExtent: 48,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: FloatingActionButton(
                                    heroTag: "1",
                                    backgroundColor: Colors.black,
                                    onPressed: () {
                                      setState(() {});
                                      _drawingController.setStyle(color: Colors.black);
                                    })),
                            Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: FloatingActionButton(
                                    heroTag: "2",
                                    backgroundColor: Colors.green,
                                    onPressed: () {
                                      setState(() {});
                                      _drawingController.setStyle(color: Colors.green);
                                    })),
                            Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: FloatingActionButton(
                                    heroTag: "3",
                                    backgroundColor: Colors.red,
                                    onPressed: () {
                                      setState(() {});
                                      _drawingController.setStyle(color: Colors.red);
                                    })),
                            Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: FloatingActionButton(
                                    heroTag: "4",
                                    backgroundColor: Colors.blue,
                                    onPressed: () {
                                      setState(() {});
                                      _drawingController.setStyle(color: Colors.blue);
                                    })),
                            Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: FloatingActionButton(
                                    backgroundColor: Colors.brown,
                                    heroTag: "5",
                                    onPressed: () {
                                      setState(() {});
                                      _drawingController.setStyle(color: Colors.brown);
                                    })),
                            Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: FloatingActionButton(
                                    backgroundColor: Colors.purple,
                                    heroTag: "6",
                                    onPressed: () {
                                      setState(() {});
                                      _drawingController.setStyle(color: Colors.purple);
                                    })),
                            Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: FloatingActionButton(
                                    backgroundColor: Colors.yellow,
                                    heroTag: "7",
                                    onPressed: () {
                                      setState(() {});
                                      _drawingController.setStyle(color: Colors.yellow);
                                    })),
                            Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: FloatingActionButton(
                                    backgroundColor: Colors.orange,
                                    heroTag: "8",
                                    onPressed: () {
                                      setState(() {});
                                      _drawingController.setStyle(color: Colors.orange);
                                    })),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: SizedBox(
                        height: Device.height / 8,
                        width: Device.width,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: brushImages.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  if (index == 0) {
                                    _drawingController.setStyle(strokeWidth: 3,strokeCap: StrokeCap.butt,color: Colors.black);
                                  } else if (index == 1) {
                                    _drawingController.setStyle(strokeWidth: 1,strokeCap: StrokeCap.round,color: Colors.black);
                                  } else if (index == 2) {
                                    _drawingController.setStyle(strokeWidth: 10,strokeCap: StrokeCap.square,color: Colors.black);
                                  } else if (index == 3) {
                                    setState(() {});
                                    _drawingController.setStyle(color: Colors.white,);
                                    showDialog(
                                      context: context,
                                      // anchorPoint: Offset.fromDirection(10),
                                      builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, st) {
                                          return AlertDialog(
                                            contentPadding: EdgeInsets.zero,
                                            insetPadding: EdgeInsets.only(left: 250,bottom: 100),
                                            alignment: AlignmentDirectional.bottomEnd,
                                            actionsPadding: EdgeInsets.zero,
                                            actions :[
                                              Slider(
                                              min: 0,
                                              max: 100,
                                              value: sizeOfEraser,
                                              onChanged: (value) {
                                                st(() {
                                                  sizeOfEraser = value;
                                                  _drawingController.setStyle(color: Colors.white,strokeWidth: sizeOfEraser);
                                                });
                                              },
                                            ),
                                          ]
                                          );
                                        });
                                    },);
                                  }
                                  setState(() {});
                                },
                                child: SizedBox(
                                    width: Device.width / 4,
                                    height: Device.height / 6,
                                    child: Image.asset(brushImages[index])));
                          },
                        ),
                      ),
                    ),
                  ],
                )),
        ]),
                )));
  }
}

class Triangle extends PaintContent {
  Triangle();

  Triangle.data({
    required this.startPoint,
    required this.A,
    required this.B,
    required this.C,
    required Paint paint,
  }) : super.paint(paint);

  factory Triangle.fromJson(Map<String, dynamic> data) {
    return Triangle.data(
      startPoint: jsonToOffset(data['startPoint'] as Map<String, dynamic>),
      A: jsonToOffset(data['A'] as Map<String, dynamic>),
      B: jsonToOffset(data['B'] as Map<String, dynamic>),
      C: jsonToOffset(data['C'] as Map<String, dynamic>),
      paint: jsonToPaint(data['paint'] as Map<String, dynamic>),
    );
  }

  Offset startPoint = Offset.zero;

  Offset A = Offset.zero;
  Offset B = Offset.zero;
  Offset C = Offset.zero;

  @override
  void startDraw(Offset startPoint) => this.startPoint = startPoint;

  @override
  void drawing(Offset nowPoint) {
    A = Offset(
        startPoint.dx + (nowPoint.dx - startPoint.dx) / 2, startPoint.dy);
    B = Offset(startPoint.dx, nowPoint.dy);
    C = nowPoint;
  }

  @override
  void draw(Canvas canvas, Size size, bool deeper) {
    final Path path = Path()
      ..moveTo(A.dx, A.dy)
      ..lineTo(B.dx, B.dy)
      ..lineTo(C.dx, C.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  Triangle copy() => Triangle();

  @override
  Map<String, dynamic> toContentJson() {
    return <String, dynamic>{
      'startPoint': startPoint.toJson(),
      'A': A.toJson(),
      'B': B.toJson(),
      'C': C.toJson(),
      'paint': paint.toJson(),
    };
  }
}
    