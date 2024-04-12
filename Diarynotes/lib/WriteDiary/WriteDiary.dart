import 'dart:io';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart' as audio;
import 'package:diarynotes/Data_Manager/CommonWidget.dart';
import 'package:diarynotes/Data_Manager/WriteDiaryFunctions.dart';
import 'package:diarynotes/Data_Manager/AppController.dart';
import 'package:diarynotes/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:diarynotes/Data_Manager/Constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import '../Connectivity/CheckInternetConnctivity.dart';
import '../Data_Manager/ObjectBoxDataModel.dart';
import '../objectbox.g.dart';

class WriteDiary extends StatefulWidget {
  int? mood;
  int? openListOfFileIndex;
  int? templateTextIndex;
  bool? isNavigateWithDrawScreen;
  Uint8List? Image;

  WriteDiary(
      {Key? key,
      this.mood,
      this.openListOfFileIndex,
      this.templateTextIndex,
      this.isNavigateWithDrawScreen,
      this.Image})
      : super(key: key);

  @override
  State<WriteDiary> createState() => _WriteDiaryState();
}

class _WriteDiaryState extends State<WriteDiary> {
  DateTime now = DateTime.now();
  ImagePicker picker = ImagePicker();

  String date = "";
  String newDate = "";
  String fileOpeningDate = "";
  String backgroundImageOfBodySelected = '';
  String fontFamilyIs = "";
  String bulletListSelect = "";

  int selectedindex = 0;
  int fileOpenListIndexArguments = -1;
  int numberOFTextFormField = 0;
  int imageFileCreateCount = 0;
  int audioFileCreateCount = 0;
  int drawImageFileCreateCount = 0;
  int tagFileCreateCount = 0;
  double imageHeight = 50.h;
  double imageWidth = 130.w;
  int emojiSelectionIndex = 0;

  var connectToInternet;

  bool isPinned = false;
  bool isClickOnBackground = false;
  bool isClickOnAudio = false;
  bool isClickOnTextStyle = false;
  bool isClickOnListStyle = false;
  bool isPressOnPlayButton = false;
  bool fontStyleItalic = false;
  bool fontStyleBold = false;
  bool fontStyleUnderline = false;
  bool fontAlignCenter = false;
  bool fontAlignJustify = false;
  bool fontAlignLeft = false;
  bool fontAlignRight = false;
  bool isPlaying = false;
  bool isFirstTimeToAddDetails = true;
  bool isRecorderReady = false;

  DateTime? temporaryDate;

  final _audioRecorder = FlutterSoundRecorder();
  late WriteDiary arguments;
  ScrollController _scrollController = ScrollController();
  FocusNode fn = FocusNode();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final List<GlobalKey> _menuKey = [];
  final List<GlobalKey> paddingKey = [];
  List<GlobalKey> audioGlobalIconKey = [];
  List<GlobalKey> audioGlobalContainerKey = [];
  final ScrollController controller = ScrollController();

  List<Uint8List> _drawImages = [];
  List<String> audioPath = [];
  List<XFile> pickedImages = [];
  List<String> _audioList = [];
  List<String> _imageList = [];
  List<String> _tagList = [];
  List<fileCreate> fileOpeningData = [];
  List<Widget> WidgetList = [];
  List<Map<String, dynamic>> finalTagList = [];
  List<GallerySelectedImageInfo> _imageInfos = [];
  List<FocusNode> focusNode = [];

  List<TextEditingController> _textEditingController = [];
  final List<String> _addTextInController = [];

  Map<String, dynamic> addEntitiesValueSequently = {};
  Map<String, Map<int, dynamic>> getEntitiesValue = {};

  @override
  void initState() {
    checkData().whenComplete(() {
      setState(() {});
    });
    date = DateFormat("dd MMM y").format(now);
    print("this is $date");
    newDate = now.toString();
    // arguments = ModalRoute.of(context)!.settings.arguments as WriteDiary;
    // fileOpenListIndexArguments = arguments.openListOfFileIndex ?? -1;
    // print("fileIndex ${fileOpenListIndexArguments} & ${arguments.openListOfFileIndex}");
    super.initState();
  }

  Future<void> checkData() async {
    await checkIndex();
    await checkDataAvailableOrNot();
    fileOpenListIndexArguments == -1 ? addTextFormField() : null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fn.requestFocus();
    });
  }

  checkDrawImage(BuildContext context) async {
    var imageDrawData = objectBox.store.box<ImageDrawData>().getAll();
    _drawImages.add(imageDrawData.last.Image);
    print("this is _drawImages ${_drawImages.length}");
    if (imageDrawData.isNotEmpty) {
      WidgetList.add(Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: SizedBox(
            height: 14.h,
            width: 80.w,
            child: Image.memory(
              imageDrawData.last.Image,
            ),
          ),
        ),
      ));
    }
  }

  addTag() async {
    setState(() {});
    _tagList.add(_tagController.text);
    finalTagList = List.generate(_tagList.length, (index) {
      return {
        'id': index,
        'text': _tagList[index],
      };
    });
  }

  checkAudio() async {
    List<String> audioList = [];
    try{
      audioList.add(audioPath.last);
    }catch(e){
      audioList = await AppController().readStringList("AudioList");
    }
    _audioList.addAll(audioList);
    audioList.asMap().forEach((index, element) async {
      audio.AudioPlayer audioPlayer = audio.AudioPlayer();
      Duration currentDuration = Duration.zero;
      GlobalKey newContainerKey = GlobalKey();
      GlobalKey newIconKey = GlobalKey();
      Duration audioDuration = Duration.zero;
      WidgetList.add(
          Container(
            key: newContainerKey,
            height: 6.h,
            width: 80.w,
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(3),
            ),
            padding: const EdgeInsets.all(5),
            child: IntrinsicWidth(
              child: StatefulBuilder(builder: (context, stState) {
                audioPlayer.onPlayerStateChanged
                    .listen((audio.PlayerState state) {
                  if (mounted) {
                    stState(() {
                      isPlaying = state == audio.PlayerState.playing;
                    });
                  }
                });
                audioPlayer.onDurationChanged.listen((Duration duration) {
                  if (mounted) {
                    stState(() {
                      audioDuration = duration;
                    });
                  }
                });
                audioPlayer.onPositionChanged.listen((Duration position) {
                  if (mounted) {
                    stState(() {
                      currentDuration = position;
                    });
                  }
                });
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () async {
                          stState(() {});
                          isPlaying = !isPlaying;
                          if (isPlaying) {
                            audioPlayer.play(audio.DeviceFileSource(element));
                          } else {
                            audioPlayer.stop();
                          }
                        },
                        icon: isPlaying
                            ? const Icon(Icons.pause)
                            : const Icon(
                                Icons.play_arrow,
                              )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 25.0, top: 10),
                        child: ProgressBar(
                          progress: currentDuration,
                          total: audioDuration,
                          progressBarColor: Colors.red,
                          baseBarColor: Colors.purpleAccent.withOpacity(0.24),
                          bufferedBarColor: Colors.white.withOpacity(0.24),
                          thumbColor: Colors.white,
                          barHeight: 3.0,
                          thumbRadius: 5.0,
                          onSeek: (duration) {
                            audioPlayer.seek(duration);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }),
            )));
    });
    addTextFormField();
  }

  addTextFormField() {
    TextEditingController newController = TextEditingController();
    _textEditingController.add(newController);
    String initialValue = "";
    FocusNode newFocusNode = FocusNode();
    focusNode.add(newFocusNode);
    _addTextInController.add(initialValue);
    WidgetList.add(TextFormField(
      controller: newController,
      maxLines: null,
      focusNode: newFocusNode,
      style: TextStyle(
        fontSize: 18,
        fontFamily: fontFamilyIs.isEmpty
            ? null
            : fontFamilyIs, // Ensure fontFamilyIs is defined
      ),
      onChanged: (value) async {
        int index = _textEditingController.indexOf(newController);
        if (index != -1 || _textEditingController.isNotEmpty) {
          if (index >= _addTextInController.length) {
            _addTextInController.add(value);
          } else {
            _addTextInController[index] = value;
          }
        }
        if (value.endsWith("\n")) {
          String newText = value.substring(0, value.length - 1);
          _textEditingController[index].text = newText;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            FocusNode nextFocusNode = focusNode[index + 1];
            nextFocusNode.requestFocus();
          });
          await addTextFormField();
        }
        setState(() {});
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        prefix: bulletListSelect.isNotEmpty
            ? SizedBox(
                height: 20,
                width: 20,
                child: Image.asset(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomCenter,
                  scale:
                      bulletListSelect == constant.bulletListIcon[8] ? 4 : 30,
                  bulletListSelect,
                ),
              )
            : null,
        hintText: "Write here...",
      ),
    ));
    isFirstTimeToAddDetails = false;
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      newFocusNode.requestFocus();
    });
  }

  initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    await _audioRecorder.openRecorder();
    isRecorderReady = true;
    _audioRecorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  checkGalleryImageSelected() async {
    try {
      pickedImages.forEach((element) {
        _imageList.add(element.path);
      });
      print("_image list length is ${_imageList.length}");
      for (var j = 0; j < pickedImages.length; j++) {
        GlobalKey newPaddingKey = GlobalKey();
        GlobalKey newIconKey = GlobalKey();
        paddingKey.add(newPaddingKey);
        _menuKey.add(newIconKey);
        _imageInfos.add(GallerySelectedImageInfo(
            height: imageHeight, width: imageWidth, id: pickedImages[j].path));
        int currentIndex = _imageInfos.length - 1;
        WidgetList.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Padding(
                  key: newPaddingKey,
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Image.file(
                      fit: BoxFit.scaleDown,
                      height: imageHeight,
                      alignment: Alignment.centerLeft,
                      File(pickedImages[j].path)),
                ),
                Positioned(
                  child: CircleAvatar(
                    backgroundColor: Colors.black26,
                    child: IconButton(
                      key: newIconKey,
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () async {
                        final RenderBox renderBox = newIconKey.currentContext!
                            .findRenderObject() as RenderBox;
                        final offset = renderBox.localToGlobal(Offset.zero);
                        final position = RelativeRect.fromLTRB(
                            offset.dx, offset.dy, offset.dx, offset.dy);
                        final selectedValue = await showMenu<String>(
                          context: context,
                          position: position,
                          color: brightBackgroundColor,
                          items: [
                            const PopupMenuItem<String>(
                              value: 'Small',
                              child: Text('Small'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Medium',
                              child: Text('Medium'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Large',
                              child: Text('Large'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Delete',
                              child: Text('Delete'),
                            ),
                          ],
                        );
                        if (selectedValue != null) {
                          setState(() {
                            print(
                                "this is the value of image info ${_imageInfos[currentIndex].id} & ${_imageInfos[currentIndex].height}  and this is the value of j $j");
                            if (selectedValue == 'Small') {
                              _imageInfos[currentIndex].height = 20.h;
                              _imageInfos[currentIndex].width = 40.w;
                              updateImage();
                            } else if (selectedValue == 'Medium') {
                              _imageInfos[currentIndex].height = 35.h;
                              _imageInfos[currentIndex].width = 65.w;
                              updateImage();
                            } else if (selectedValue == 'Large') {
                              _imageInfos[currentIndex].height = 50.h;
                              _imageInfos[currentIndex].width = 90.w;
                              updateImage();
                            } else if (selectedValue == 'Delete') {
                              WidgetList.removeWhere((element) {
                                print("element.key is ${element.key}");
                                print("paddingkey is ${paddingKey}");
                                return element.key == paddingKey[currentIndex];
                              });
                              print(
                                  "_imageList remove ${_imageList[currentIndex]}");
                              _imageList.removeAt(currentIndex);
                            }
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      await addTextFormField();
    } catch (e) {
      print("error in gallarySelectedImages is $e");
    }
  }

  updateImage() {
    int j = 0;
    for (int i = 0; i < WidgetList.length; i++) {
      if (WidgetList[i] is Padding) {
        _imageInfos[j] = (GallerySelectedImageInfo(
            height: _imageInfos[j].height,
            width: _imageInfos[j].width,
            id: _imageInfos[j].id!));
        GlobalKey newIconKey = GlobalKey();
        _menuKey[j] = newIconKey;
        j++;
        int currentIndex = j - 1;
        GlobalKey newPaddingKey = GlobalKey();
        paddingKey[currentIndex] = newPaddingKey;
        WidgetList[i] = Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Padding(
                key: paddingKey[currentIndex],
                padding: const EdgeInsets.only(top: 20.0),
                child: Image.file(
                    fit: BoxFit.scaleDown,
                    height: _imageInfos[currentIndex].height,
                    alignment: Alignment.centerLeft,
                    File(_imageInfos[currentIndex].id!)),
              ),
              Positioned(
                child: CircleAvatar(
                  backgroundColor: Colors.black26,
                  child: IconButton(
                    key: newIconKey,
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () async {
                      final RenderBox renderBox = newIconKey.currentContext!
                          .findRenderObject() as RenderBox;
                      final Offset offset =
                          renderBox.localToGlobal(Offset.zero);
                      final RelativeRect position = RelativeRect.fromLTRB(
                          offset.dx, offset.dy, offset.dx, offset.dy);
                      final String? selectedValue = await showMenu<String>(
                        context: context,
                        position: position,
                        color: brightBackgroundColor,
                        items: [
                          const PopupMenuItem<String>(
                            value: 'Small',
                            child: Text('Small'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Medium',
                            child: Text('Medium'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Large',
                            child: Text('Large'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Delete',
                            child: Text('Delete'),
                          ),
                        ],
                      );
                      if (selectedValue != null) {
                        setState(() {});
                        if (selectedValue == 'Small') {
                          _imageInfos[currentIndex].height = 20.h;
                          _imageInfos[currentIndex].width = 40.w;
                          updateImage();
                        } else if (selectedValue == 'Medium') {
                          _imageInfos[currentIndex].height = 35.h;
                          _imageInfos[currentIndex].width = 65.w;
                          updateImage();
                        } else if (selectedValue == 'Large') {
                          _imageInfos[currentIndex].height = 50.h;
                          _imageInfos[currentIndex].width = 90.w;
                          updateImage();
                        } else if (selectedValue == 'Delete') {
                          WidgetList.removeAt(i);
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  updateTextFormFieldStyle() {
    int checkTextEditingControllerLength = 0;
    for (int i = 0; i < WidgetList.length; i++) {
      if (WidgetList[i] is TextFormField) {
        TextFormField textField = WidgetList[i] as TextFormField;
        FocusNode currentFocusNode =
            focusNode[checkTextEditingControllerLength];
        _textEditingController[checkTextEditingControllerLength].text =
            textField.controller?.text ?? "";
        WidgetList[i] = TextFormField(
          textAlign: fontAlignCenter
              ? TextAlign.center
              : fontAlignLeft
                  ? TextAlign.left
                  : fontAlignRight
                      ? TextAlign.right
                      : fontAlignJustify
                          ? TextAlign.justify
                          : TextAlign.left,
          controller: _textEditingController[checkTextEditingControllerLength],
          onChanged: (value) async {
            if (value.endsWith("\n")) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                FocusNode nextFocusNode =
                    focusNode[checkTextEditingControllerLength + 1];
                nextFocusNode.requestFocus();
              });
              await addTextFormField();
            }
            setState(() {});
          },
          focusNode: currentFocusNode,
          style: TextStyle(
            fontFamily: fontFamilyIs.isEmpty ? null : fontFamilyIs,
            fontStyle: fontStyleItalic ? FontStyle.italic : FontStyle.normal,
            fontWeight: fontStyleBold ? FontWeight.bold : FontWeight.normal,
            decoration: fontStyleUnderline
                ? TextDecoration.underline
                : TextDecoration.none,
          ),
          maxLines: null,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefix: bulletListSelect.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Image.asset(
                      fit: BoxFit.scaleDown,
                      scale: bulletListSelect == constant.bulletListIcon[8]
                          ? 4
                          : 30,
                      bulletListSelect,
                    ),
                  )
                : SizedBox(),
            hintText: "Write here...",
          ),
        );
        checkTextEditingControllerLength++;
      }
    }
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
        final offset = focusNode.last.offset.distance;
        _scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
    });
  }

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    if (keyboardHeight > 0) {
      isClickOnBackground = false;
      isClickOnListStyle = false;
      isClickOnTextStyle = false;
      isClickOnAudio = false;
    }
    arguments = ModalRoute.of(context)!.settings.arguments as WriteDiary;
    fileOpenListIndexArguments = arguments.openListOfFileIndex ?? -1;
    print("fileIndex ${fileOpenListIndexArguments} & ${arguments.openListOfFileIndex}");
    fileOpeningData = objectBox.store.box<fileCreate>().getAll();
    WidgetList.toList();
  }

  @override
  void dispose() {
    _audioRecorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Consumer(
      builder: (context, value, child) => WillPopScope(
        onWillPop: () {
          if (_titleController.text.isNotEmpty ||
              _textEditingController.first.text.isNotEmpty ||
              WidgetList.isNotEmpty) {
            _onWillPop();
          } else {
            Navigator.pushNamed(context, "/MultiPageView");
          }
          return Future.value(false);
        },
        child: GestureDetector(
            onTap: () {
              setState(() {});
              _audioRecorder.isRecording ? _audioRecorder.stopRecorder() : null;
              isClickOnAudio = false;
              isClickOnTextStyle = false;
              isClickOnBackground = false;
              isClickOnListStyle = false;
            },
            child: Scaffold(
                backgroundColor: lightBackgroundColor,
                resizeToAvoidBottomInset: false,
                bottomSheet: isClickOnListStyle
                    ? BulletListBottomSheet(
                        isClickOnListStyle: isClickOnListStyle,
                        bulletSelected: bulletListSelect,
                        callBullet: _onBulletSelected,
                        callOff: _onClickOffList,
                      )
                    : isClickOnTextStyle
                        ? TextStyleBottomSheet(
                            isClickOnTextStyle: isClickOnTextStyle,
                            updateStyleCallback: styleCheck,
                            callFontFamily: _callFontFamily,
                            callBool: (bool) {
                              setState(() {});
                              isClickOnTextStyle = bool;
                            },
                          )
                        : isClickOnAudio
                            ? Container(
                                alignment: Alignment.topCenter,
                                height: 35.h,
                                decoration: BoxDecoration(
                                    color: brightBackgroundColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(40),
                                        topRight: Radius.circular(40))),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            isClickOnAudio = false;
                                            setState(() {});
                                            showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (context) {
                                                return Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 30.0),
                                                      child: StatefulBuilder(
                                                        builder:
                                                            (context, stState) {
                                                          return GestureDetector(
                                                            onTap: () async {
                                                              await initRecorder();
                                                              stState(() {
                                                                isPressOnPlayButton =
                                                                    !isPressOnPlayButton;
                                                              });
                                                              if (isPressOnPlayButton) {
                                                                await WriteDiaryFunctions()
                                                                    .startRecording(
                                                                        isRecorderReady,
                                                                        _audioRecorder);
                                                              } else {
                                                                await WriteDiaryFunctions()
                                                                    .stopRecording(
                                                                        isRecorderReady,
                                                                        _audioRecorder);
                                                              }
                                                            },
                                                            child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            12.0),
                                                                child: isPressOnPlayButton
                                                                    ? ListView(
                                                                        shrinkWrap:
                                                                            true,
                                                                        physics:
                                                                            NeverScrollableScrollPhysics(),
                                                                        itemExtent:
                                                                            60,
                                                                        children: [
                                                                          StreamBuilder<
                                                                              RecordingDisposition>(
                                                                            stream:
                                                                                _audioRecorder.onProgress,
                                                                            builder:
                                                                                (context, snapshot) {
                                                                              // print("audio time ${snapshot.data!.duration}");
                                                                              final duration = snapshot.hasData ? snapshot.data?.duration : Duration.zero;
                                                                              String twoDigits(int n) => n.toString();
                                                                              final twoDigitsMinutes = twoDigits(duration!.inMinutes.remainder(60));
                                                                              final twoDigitsSeconds = twoDigits(duration.inSeconds.remainder(60));
                                                                              print("this is real time $twoDigitsSeconds and $twoDigitsMinutes");
                                                                              return Text(
                                                                                '$twoDigitsMinutes : $twoDigitsSeconds',
                                                                                softWrap: true,
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(decoration: TextDecoration.none, fontSize: 30, color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                                                                              );
                                                                            },
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                30,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              GestureDetector(
                                                                                onTap: () async {
                                                                                  Navigator.pop(context);
                                                                                  isPressOnPlayButton = false;
                                                                                },
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(top: 18.0),
                                                                                  child: Image.asset("assets/images/close (1).png", scale: 3.0, color: isDarkMode ? Colors.white : Colors.black,),
                                                                                ),
                                                                              ),
                                                                              Image.asset(
                                                                                "assets/images/stop-button.png",
                                                                                scale: 5.0,
                                                                                color: isDarkMode ? Colors.white : Colors.black,
                                                                              ),
                                                                              GestureDetector(
                                                                                onTap: () async {
                                                                                  audioPath = [];
                                                                                  isPressOnPlayButton = false;
                                                                                  Navigator.pop(context);
                                                                                  audioPath = await WriteDiaryFunctions().stopRecording(isRecorderReady, _audioRecorder);
                                                                                  checkAudio();
                                                                                  Fluttertoast.showToast(toastLength: Toast.LENGTH_LONG, fontSize: Adaptive.px(18), backgroundColor: brightBackgroundColor, gravity: ToastGravity.TOP, msg: "Successfully Recording Added ..");
                                                                                },
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(top: 18.0),
                                                                                  child: Image.asset("assets/images/check-mark.png", scale: 3.0, color: isDarkMode ? Colors.white : Colors.black,),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : ListView(
                                                                        shrinkWrap:
                                                                            true,
                                                                        physics:
                                                                            NeverScrollableScrollPhysics(),
                                                                        itemExtent:
                                                                            80,
                                                                        children: [
                                                                          Center(
                                                                            child:
                                                                                Text(
                                                                              "Tap To Start Recording..",
                                                                              style: TextStyle(
                                                                                fontSize: 20,
                                                                                color: isDarkMode ? Colors.white : Colors.black,
                                                                                // Set the desired text color
                                                                                decoration: TextDecoration.none, // Remove underline
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Image
                                                                              .asset(
                                                                            "assets/images/voice-search.png",
                                                                            // fit: BoxFit.cover,
                                                                            color: isDarkMode
                                                                                ? Colors.white
                                                                                : Colors.black,
                                                                            scale:
                                                                                5.0,
                                                                          ),
                                                                        ],
                                                                      )),
                                                          );
                                                        },
                                                      ),
                                                    ));
                                              },
                                            ).then((value) {
                                              if (_audioRecorder.isRecording) {
                                                _audioRecorder.stopRecorder();
                                                isPressOnPlayButton = false;
                                              }
                                              setState(() {});
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.keyboard_voice_outlined,
                                            size: 50,
                                          )),
                                      IconButton(
                                          onPressed: () async {
                                            isClickOnAudio = false;
                                            audioPath = [];
                                            var data =
                                                await Navigator.pushNamed(
                                                    context, '/AudioFile');
                                            if (data != null) {
                                              setState(() {});
                                              await checkAudio();
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.file_open,
                                            size: 50,
                                          ))
                                    ],
                                  ),
                                ),
                              )
                            : isClickOnBackground
                                ? SingleChildScrollView(
                                    child: Container(
                                      alignment: Alignment.topCenter,
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                          color: brightBackgroundColor,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(40),
                                              topRight: Radius.circular(40))),
                                      child: DefaultTabController(
                                        length: constant()
                                            .tabViewImagesString
                                            .length,
                                        // Number of tabs
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              height: 6.h,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(width: 15.w),
                                                  const Center(
                                                    child: Text('Background',
                                                        style: TextStyle(
                                                            fontSize: 18)),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          isClickOnBackground =
                                                              false;
                                                        });
                                                      },
                                                      icon: Icon(Icons.check))
                                                ],
                                              ),
                                            ),
                                             TabBar(
                                              indicatorPadding: EdgeInsets.zero,
                                              indicatorSize:
                                                  TabBarIndicatorSize.tab,
                                              labelPadding: EdgeInsets.zero,
                                              labelColor: isDarkMode ? Colors.white : Colors.black,
                                              indicatorColor: lightBackgroundColor,
                                              tabs: const [
                                                Tab(text: 'colors'),
                                                Tab(text: 'popular'),
                                                Tab(text: 'artsy'),
                                                Tab(text: 'cute'),
                                                Tab(text: 'lifestyle'),
                                              ],
                                            ),
                                            Flexible(
                                              child: TabBarView(
                                                    children: List<Widget>.generate(
                                                      constant()
                                                          .tabViewImagesString
                                                          .length,
                                                      (index) => BuildGridViewForTabView(
                                                          bgImage:
                                                              backgroundImageOfBodySelected,
                                                          connectToInternet:
                                                              connectToInternet,
                                                          index: index,
                                                          callBack:
                                                              _updateBackgroundImage),
                                                      growable: true,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // ]),
                                    ),
                                  )
                                : null,
                body: SafeArea(
                  maintainBottomViewPadding: false,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        image: backgroundImageOfBodySelected == ""
                            ? null
                            : DecorationImage(
                                image:
                                    NetworkImage(backgroundImageOfBodySelected),
                                fit: BoxFit.fill)),
                    child: Stack(
                      children: [
                        Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                        splashRadius: 0.001,
                                        alignment: Alignment.centerLeft,
                                        iconSize: 30,
                                        padding: EdgeInsets.only(right: 5, left: 10, top: 14),
                                        onPressed: () {
                                          if (_titleController.text.isEmpty &&
                                              _textEditingController
                                                  .first.text.isEmpty &&
                                              WidgetList.isEmpty) {
                                            Navigator.pop(context);
                                          } else {
                                            _onWillPop();
                                            // Navigator.pop(context);
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.arrow_back,
                                        )),
                                  ]),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.8,
                                  child: SingleChildScrollView(
                                    controller: _scrollController,
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: keyboardHeight, left: 5),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    DateTime? upDateTime =
                                                        await showDatePicker(
                                                      locale: const Locale(
                                                          "en", "US"),
                                                      context: context,
                                                      initialDate: now,
                                                      firstDate: DateTime(1969),
                                                      builder:
                                                          (context, child) {
                                                        return Theme(
                                                          data: ThemeData(
                                                            dialogBackgroundColor:
                                                                brightBackgroundColor,
                                                            colorScheme:
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .copyWith(
                                                                      // Title, selected date and day selection background (dark and light mode)
                                                                      surface:
                                                                          lightBackgroundColor,
                                                                      primary:
                                                                          lightBackgroundColor,
                                                                      // Title, selected date and month/year picker color (dark and light mode)
                                                                      // onSurface: lightBackgroundColor,
                                                                      onPrimary: isDarkMode
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black,
                                                                    ),
                                                            textButtonTheme:
                                                                TextButtonThemeData(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                foregroundColor:
                                                                    isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                              ),
                                                            ),
                                                          ),
                                                          child: child!,
                                                        );
                                                      },
                                                      lastDate: DateTime(2050),
                                                    );
                                                    try {
                                                      date = DateFormat(
                                                              "dd MMM y")
                                                          .format(upDateTime!);
                                                      newDate =
                                                          upDateTime.toString();
                                                      // print("update time $upDateTime");
                                                      fileOpeningDate =
                                                          DateFormat('dd MMM y')
                                                              .format(
                                                                  upDateTime);
                                                      print("update time $fileOpeningDate");
                                                    } catch (e) {
                                                      print("this is some issue $fileOpeningDate");
                                                    }
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text: fileOpenListIndexArguments == -1
                                                                  ? date.substring(0, 3)
                                                                  : fileOpeningDate.substring(0, 3),
                                                              style: TextStyle(
                                                                color: !isDarkMode
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 24,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: fileOpenListIndexArguments ==
                                                                      -1
                                                                  ? date
                                                                      .substring(
                                                                          3)
                                                                  : fileOpeningDate
                                                                      .substring(
                                                                          3),
                                                              style: TextStyle(
                                                                color: !isDarkMode
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Icon(Icons
                                                          .arrow_drop_down_outlined),
                                                    ],
                                                  ),
                                                ),
                                                const Spacer(),
                                                GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return SizedBox(
                                                            child: Dialog(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      3.3.px,
                                                                      -0.7.px),
                                                              backgroundColor: brightBackgroundColor,
                                                              child: SizedBox(
                                                                width: 50,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          14.0,
                                                                      vertical:
                                                                          16.0),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const Text(
                                                                            "How is your day going?",
                                                                            style:
                                                                                TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                                                          ),
                                                                          TextButton(
                                                                              onPressed: () async {
                                                                                Navigator.pushNamed(context, "/emojiSelection").whenComplete(() {
                                                                                  Navigator.pop(context);
                                                                                  final emojiIndex = objectBox.store.box<EmojiIndex>();
                                                                                  try {emojiSelectionIndex = (emojiIndex.getAll().last.emojiSelectedIndex)!;
                                                                                  print("here i am---->$emojiSelectionIndex");
                                                                                  } catch (e) {
                                                                                    print("nothing happen bro..");
                                                                                  }
                                                                                });
                                                                                setState(() {});
                                                                              },
                                                                              child: Container(
                                                                                  padding: const EdgeInsets
                                                                                      .all(
                                                                                      10),
                                                                                  child:  Text("More",
                                                                                    style: TextStyle(
                                                                                        fontSize: 13,color: isDarkMode ? Colors.white : Colors.black),
                                                                                  )))
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            70,
                                                                        child: GridView
                                                                            .builder(
                                                                          physics:
                                                                              const NeverScrollableScrollPhysics(),
                                                                          itemCount: constant
                                                                              .tiktokemoji
                                                                              .length,
                                                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                              crossAxisCount: 4,
                                                                              mainAxisExtent: 30,
                                                                              mainAxisSpacing: 10),
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            return GestureDetector(
                                                                              onTap: () {
                                                                                setState(() {});
                                                                                selectedindex = index;
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: CommonWidgets().buildImage(emojiSelectionIndex, index),
                                                                            );
                                                                          },
                                                                        ),
                                                                      )
                                                                      // Add any other content you want in the dialog here
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: CircleAvatar(
                                                        minRadius: 20,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        foregroundColor: null,
                                                        maxRadius: 20,
                                                        child: Image.asset(
                                                          AppController().getEmojiAsset(
                                                              emojiSelectionIndex,
                                                              fileOpenListIndexArguments,
                                                              selectedindex,
                                                              fileOpeningData),
                                                          fit: BoxFit.cover,
                                                        ))),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: SizedBox(
                                                height: 50,
                                                child: TextField(
                                                  controller: _titleController,
                                                  focusNode: fn,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        fontFamilyIs.isEmpty
                                                            ? null
                                                            : fontFamilyIs,
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: "Title",
                                                    border: InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ...WidgetList,
                                            Wrap(
                                              children: finalTagList.map(
                                                (Map<String, dynamic> item) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            2, 2, 2, 0),
                                                    child: Chip(
                                                      label: Text(item['text']),
                                                      backgroundColor:
                                                          Colors.white70,
                                                      onDeleted: () {
                                                        if (_tagList.isEmpty) {
                                                          _tagList.clear();
                                                          finalTagList.clear();
                                                          setState(() {});
                                                          return;
                                                        }
                                                        _tagList.removeAt(
                                                            item['id']);
                                                        if (_tagList.isEmpty) {
                                                          finalTagList.clear();
                                                        }
                                                        setState(() {});
                                                      },
                                                      // labelStyle: const TextStyle(color: Colors.black),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          14),
                                                              side: const BorderSide(
                                                                  color: Colors
                                                                      .black)),
                                                    ),
                                                  );
                                                },
                                              ).toList(),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                        Positioned.fill(
                          top: keyboardHeight == 0.0
                              ? MediaQuery.sizeOf(context).height * 0.89
                              : null,
                          bottom:
                              keyboardHeight == 0.0 ? 8 : keyboardHeight + 10,
                          right: 20,
                          left: 20,
                          child: Container(
                              alignment: Alignment.center,
                              height: 5.h,
                              decoration: BoxDecoration(
                                  color: brightBackgroundColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: ListView.builder(
                                itemCount: constant.editorIcons.length,
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(left: 3),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return IconButton(
                                      onPressed: () async {
                                        if (index == 0) {
                                          setState(() {});
                                          isClickOnBackground = true;
                                          await KeyboardUnFocus()
                                              .keyboardOff(context);
                                        } else if (index == 1) {
                                          await KeyboardUnFocus()
                                              .keyboardOff(context);
                                          try {
                                            AppController()
                                                .pref
                                                .remove("ImageList");
                                          } catch (e) {
                                            print("ignore exception $e");
                                          }
                                          pickedImages = [];
                                          pickedImages =
                                              await picker.pickMultiImage();
                                          print(
                                              "pickedFiles ${pickedImages.last.path}");
                                          await checkGalleryImageSelected();
                                          // }
                                        } else if (index == 2) {
                                          KeyboardUnFocus()
                                              .keyboardOff(context);
                                          setState(() {});
                                          isClickOnTextStyle = true;
                                        } else if (index == 3) {
                                          await KeyboardUnFocus()
                                              .keyboardOff(context);
                                          setState(() {});
                                          isClickOnListStyle = true;
                                        } else if (index == 4) {
                                          setState(() {});
                                          _tagController.text = "";
                                          Alert(
                                              style: AlertStyle(
                                                  backgroundColor:
                                                      lightBackgroundColor),
                                              context: context,
                                              type: AlertType.none,
                                              title: "Enter Tag",
                                              content: TextField(
                                                controller: _tagController,
                                                decoration:
                                                    const InputDecoration(
                                                        icon: Icon(Icons.tag),
                                                        hintText: "Tag"),
                                              ),
                                              buttons: [
                                                DialogButton(
                                                  color: brightBackgroundColor,
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text(
                                                    "Cancel",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                ),
                                                DialogButton(
                                                  color: brightBackgroundColor,
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    var tagDataEntity =
                                                        TagDataEntity();
                                                    tagDataEntity.strings.add(
                                                        TagStringItem(
                                                            key: 0,
                                                            value:
                                                                _tagController
                                                                    .text));
                                                    var tagDataModel = objectBox
                                                        .store
                                                        .box<TagDataEntity>();
                                                    tagDataModel
                                                        .put(tagDataEntity);
                                                    await addTag();
                                                  },
                                                  child: const Text(
                                                    "Save",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                )
                                              ]).show();
                                          await KeyboardUnFocus()
                                              .keyboardOff(context);
                                        } else if (index == 5) {
                                          await KeyboardUnFocus()
                                              .keyboardOff(context);
                                          setState(() {});
                                          isClickOnAudio = true;
                                        } else if (index == 6) {
                                          await KeyboardUnFocus()
                                              .keyboardOff(context);
                                          setState(() {});
                                          var data =
                                              WriteDiaryDetailsSaveTemporary(
                                            backgroundImageOfBodySelected,
                                            _titleController
                                                .text, /*WidgetList*/
                                          );
                                          var saveDetails = objectBox.store.box<
                                              WriteDiaryDetailsSaveTemporary>();
                                          saveDetails.put(data);
                                          var deleteLastImageDraw = objectBox
                                              .store
                                              .box<ImageDrawData>();
                                          try {
                                            deleteLastImageDraw.removeAll();
                                          } catch (e) {
                                            print("delete draw image $e");
                                          }
                                          var checkData =
                                              await Navigator.pushNamed(
                                                  context, "/drawScreen");
                                          if (checkData != null) {
                                            setState(() {
                                              checkDrawImage(context);
                                            });
                                            addTextFormField();
                                          }
                                        }
                                      },
                                      icon: ImageIcon(AssetImage(constant.editorIcons[index]),size: 20,));
                                },
                              )),
                        ),
                      ],
                    ),
                  ),
                  // return Center(child: CircularProgressIndicator(),)
                ))),
      ),
    );
  }

  _onWillPop() async {
    final imageDataEntity = ToMany<ImagePathString>();
    final drawImageDataEntity = ToMany<DrawImagesString>();
    final detailsTextDataEntity = ToMany<DetailsControllerText>();
    final tagDataEntity = ToMany<TagStringItem>();
    final audioDataEntity = ToMany<AudioPathString>();

    int textEditingControllerCount = 0;

    WidgetList.asMap().forEach((key, element) {
      if (element.runtimeType == TextFormField) {
        _addTextInController.forEach((text) {});
        detailsTextDataEntity.add(DetailsControllerText(
            key: key,
            value: _addTextInController[textEditingControllerCount].isEmpty
                ? ""
                : _addTextInController[textEditingControllerCount]));
        textEditingControllerCount++;
      } else if (element.runtimeType == Container) {
        audioDataEntity.add(
            AudioPathString(key: key, value: _audioList[audioFileCreateCount]));
        audioFileCreateCount++;
      } else if (element.runtimeType == Center) {
        print("drawImageFileCreateCount $drawImageFileCreateCount");
        print("new ${_drawImages.length}");
        drawImageDataEntity.add(DrawImagesString(
            key: key, value: _drawImages[drawImageFileCreateCount]));
        drawImageFileCreateCount++;
      } else {
        imageDataEntity.add(
          ImagePathString(
              key: key,
              value: _imageList[imageFileCreateCount],
              height: _imageInfos[imageFileCreateCount].height!,
              width: _imageInfos[imageFileCreateCount].width!),
        );
        imageFileCreateCount++;
      }
    });
    finalTagList.asMap().forEach((key, value) {
      tagDataEntity
          .add(TagStringItem(key: key, value: _tagList[tagFileCreateCount]));
      tagFileCreateCount++;
    });
    print("selected index $selectedindex");
    var data = fileCreate(
        newDate,
        isPinned,
        -1,
        selectedindex,
        _titleController.text,
        false,
        imageDataEntity,
        audioDataEntity,
        tagDataEntity,
        drawImageDataEntity,
        detailsTextDataEntity,
        backgroundImageOfBodySelected,
        bulletListSelect,
        fontFamilyIs);
    if (fileOpenListIndexArguments == -1) {
      userBox.put(data);
    } else {
      print("i am here ..$fileOpenListIndexArguments");
      List<fileCreate> fc = userBox.getAll();
      fc.sort((a, b) => a.sortData.compareTo(b.sortData));
      userBox.remove(fc[fileOpenListIndexArguments].id);
      userBox.put(data);
    }
    Navigator.pushNamed(context, "/MultiPageView");
  }

  checkIndex() async {
    final emojiIndex = objectBox.store.box<EmojiIndex>();
    try {
      emojiSelectionIndex = emojiIndex.getAll().last.emojiSelectedIndex!;
    } catch (e) {
      print("Error reading emojiSelectionIndexCopy: $e");
    }
    connectToInternet = await ConnectivityService.isInternetAvailable();
    print("connect to internet ${connectToInternet} && $fileOpenListIndexArguments");
    if (fileOpenListIndexArguments != -1) {
      fileOpeningData.sort((a, b) => a.sortData.compareTo(b.sortData));
      temporaryDate = DateTime.tryParse(
          fileOpeningData[fileOpenListIndexArguments].dateTime);
      fileOpeningDate =
          DateFormat('dd MMM y')
              .format(
              temporaryDate!);
      print("this is tempory date $fileOpeningDate");
      newDate = temporaryDate.toString();
      print(
          "this is file opening data ${fileOpeningData[fileOpenListIndexArguments].title} and ${fileOpeningData[fileOpenListIndexArguments].sortData} and $fileOpeningDate");
      isPinned = fileOpeningData[fileOpenListIndexArguments].isPinned;
      try {
        selectedindex = fileOpeningData[fileOpenListIndexArguments].emoji;
        _titleController.text =
            fileOpeningData[fileOpenListIndexArguments].title;
      } catch (e) {
        print('error in title details is $e');
      }
    }
  }

  void _updateBackgroundImage(String newImage) {
    setState(() {
      backgroundImageOfBodySelected = newImage;
    });
  }

  void _onBulletSelected(String selectedBullet) {
    setState(() {
      bulletListSelect = selectedBullet;
      updateTextFormFieldStyle();
    });
  }

  void _onClickOffList(bool clickOnListStyle) {
    setState(() {
      isClickOnListStyle = clickOnListStyle;
    });
  }

  void _callFontFamily(String fontFamily) {
    setState(() {
      fontFamilyIs = fontFamily;
    });
    updateTextFormFieldStyle();
  }

  styleCheck(
    bool styleBool,
    String value,
  ) {
    fontAlignLeft = fontAlignCenter = fontAlignRight = fontAlignJustify = false;
    setState(() {
      switch (value) {
        case "left":
          fontAlignLeft = styleBool;
          break;
        case "justify":
          fontAlignJustify = styleBool;
          break;
        case "center":
          fontAlignCenter = styleBool;
          break;
        case "right":
          fontAlignRight = styleBool;
          break;
        case "bold":
          fontStyleBold = styleBool;
          break;
        case "italic":
          fontStyleItalic = styleBool;
          break;
        case "underline":
          fontStyleUnderline = styleBool;
          break;
      }
    });
    updateTextFormFieldStyle();
  }

  checkDataAvailableOrNot() async {
    if (fileOpenListIndexArguments != -1) {
      if(connectToInternet) {
        backgroundImageOfBodySelected =
            fileOpeningData[fileOpenListIndexArguments].backgroundImage;
      }
      fontFamilyIs = fileOpeningData[fileOpenListIndexArguments].fontFamily;
      bulletListSelect =
          fileOpeningData[fileOpenListIndexArguments].bulletListImages;
      var imagePathEntity =
          fileOpeningData[fileOpenListIndexArguments].imagePath;
      var audioPathEntity =
          fileOpeningData[fileOpenListIndexArguments].audioPath;
      var drawImagesEntity =
          fileOpeningData[fileOpenListIndexArguments].drawImages;
      var tagsEntity = fileOpeningData[fileOpenListIndexArguments].tags;
      var detailsTextEntity =
          fileOpeningData[fileOpenListIndexArguments].detailsController;

      tagsEntity.forEach((element) {
        _tagList.add(element.value);
        finalTagList = List.generate(_tagList.length, (index) {
          return {
            'id': index,
            'text': _tagList[index],
          };
        });
      });

      Map<int, dynamic> detailsTextEntries = Map.fromIterable(detailsTextEntity,
          key: (e) => e.key, value: (e) => e.value);

      Map<int, dynamic> audioPathEntries = Map.fromIterable(audioPathEntity,
          key: (e) => e.key, value: (e) => e.value);

      Map<int, dynamic> drawImagesEntries = Map.fromIterable(drawImagesEntity,
          key: (e) => e.key, value: (e) => e.value);

      Map<int, List<dynamic>> imagePathEntries = {};
      imagePathEntity.forEach(
          (e) => imagePathEntries.putIfAbsent(e.key, () => []).add(e.value));

      getEntitiesValue.addAll({
        "detailsText": detailsTextEntries,
        "audioPath": audioPathEntries,
        "imagePath": imagePathEntries,
        "drawImages": drawImagesEntries,
      });

      List<Map<int, dynamic>> valueOfValue = getEntitiesValue.values.toList();
      List<int> keys = valueOfValue.expand((map) => map.keys).toList()..sort();

      keys.forEach((element) {
        getEntitiesValue.forEach((key, value) {
          if (value.containsKey(element)) {
            String combinedKey = "$key$element";
            addEntitiesValueSequently
                .putIfAbsent(combinedKey, () => [])
                .add(value[element]);
          }
        });
      });
      // await gallery();
      int k = 0;
      addEntitiesValueSequently.forEach((key, value) async {
        if (key.startsWith("imagePath")) {
          for (var element in value) {
            if (element is List<dynamic>) {
              for (var newElement in element) {
                if (newElement is String) {
                  k++;
                  GlobalKey newPaddingKey = GlobalKey();
                  GlobalKey newIconKey = GlobalKey();
                  paddingKey.add(newPaddingKey);
                  _menuKey.add(newIconKey);
                  _imageList.add(newElement);
                  try {
                    int currentIndex = _imageInfos.length;
                    _imageInfos.add(GallerySelectedImageInfo(
                        height: imagePathEntity[k - 1].height,
                        width: imagePathEntity[k - 1].width,
                        id: newElement));
                    WidgetList.add(
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Padding(
                              key: newPaddingKey,
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Image.file(
                                  fit: BoxFit.scaleDown,
                                  height: imagePathEntity[k - 1].height,
                                  alignment: Alignment.centerLeft,
                                  File(newElement)),
                            ),
                            Positioned(
                              top: -2,
                              right: -12,
                              child: CircleAvatar(
                                backgroundColor: Colors.black26,
                                child: IconButton(
                                  key: newIconKey,
                                  icon: const Icon(Icons.more_horiz),
                                  onPressed: () async {
                                    final RenderBox renderBox = newIconKey.currentContext!
                                        .findRenderObject() as RenderBox;
                                    final Offset offset =
                                    renderBox.localToGlobal(Offset.zero);
                                    final RelativeRect position = RelativeRect.fromLTRB(
                                        offset.dx, offset.dy, offset.dx, offset.dy);
                                    final selectedValue = await showMenu<String>(
                                      context: context,
                                      position: position,
                                      color: brightBackgroundColor,
                                      items: [
                                        const PopupMenuItem<String>(
                                          value: 'Small',
                                          child: Text('Small'),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'Medium',
                                          child: Text('Medium'),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'Large',
                                          child: Text('Large'),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'Delete',
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    );
                                    if (selectedValue != null) {
                                      setState(() {
                                        if (selectedValue == 'Small') {
                                          _imageInfos[currentIndex].height =
                                              20.h;
                                          _imageInfos[currentIndex].width =
                                              40.w;
                                        } else if (selectedValue == 'Medium') {
                                          _imageInfos[currentIndex].height =
                                              35.h;
                                          _imageInfos[currentIndex].width =
                                              65.w;
                                        } else if (selectedValue == 'Large') {
                                          _imageInfos[currentIndex].height =
                                              50.h;
                                          _imageInfos[currentIndex].width =
                                              100.w;
                                        } else if (selectedValue == 'Delete') {
                                          WidgetList.removeWhere((element) {
                                            print("element key is ${element.key} and padding key $newPaddingKey");
                                            return element.key == newPaddingKey;
                                          });
                                        }
                                      });
                                      updateImage();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } catch (e) {
                    print("error in gallarySelectedImages is $e");
                  }
                }
              }
            }
          }
        } else if (key.startsWith("audioPath") || key.contains("audioPath")) {
          audio.AudioPlayer audioPlayer = audio.AudioPlayer();
          Duration currentDuration = Duration.zero;
          Duration audioDuration = Duration.zero;
          if (value is List<dynamic>) {
            for (String audioPathValue in value) {
              _audioList.add(audioPathValue);
              WidgetList.add(Container(
                height: 6.h,
                width: 80.w,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(3),
                ),
                padding: const EdgeInsets.all(5),
                child: IntrinsicWidth(
                  child: StatefulBuilder(builder: (context, stState) {
                    audioPlayer.onPlayerStateChanged
                        .listen((audio.PlayerState state) {
                      if (mounted) {
                        stState(() {
                          isPlaying = state == audio.PlayerState.playing;
                        });
                      }
                    });
                    audioPlayer.onDurationChanged.listen((Duration duration) {
                      if (mounted) {
                        stState(() {
                          audioDuration = duration;
                        });
                      }
                    });
                    audioPlayer.onPositionChanged.listen((Duration position) {
                      if (mounted) {
                        stState(() {
                          currentDuration = position;
                        });
                      }
                    });
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () async {
                              stState(() {});
                              isPlaying = !isPlaying;
                              if (isPlaying) {
                                audioPlayer.play(
                                    audio.DeviceFileSource(audioPathValue));
                              } else {
                                audioPlayer.stop();
                              }
                            },
                            icon: isPlaying
                                ? const Icon(Icons.pause)
                                : const Icon(
                                    Icons.play_arrow,
                                  )),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 25.0, top: 10),
                            child: ProgressBar(
                              progress: currentDuration,
                              total: audioDuration,
                              progressBarColor: Colors.red,
                              baseBarColor:
                                  Colors.purpleAccent.withOpacity(0.24),
                              bufferedBarColor: Colors.white.withOpacity(0.24),
                              thumbColor: Colors.white,
                              barHeight: 3.0,
                              thumbRadius: 5.0,
                              onSeek: (duration) {
                                audioPlayer.seek(duration);
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ));
            }
          }
        } else if (key.startsWith("detailsText")) {
          if (value is List<dynamic>) {
            for (int i = 0; i < value.length; i++) {
              if (value[i] is String) {
                TextEditingController newController = TextEditingController();
                _textEditingController.add(newController);
                FocusNode newFocusNode = FocusNode();
                focusNode.add(newFocusNode);
                newController.text = value[i];
                _addTextInController.add(value[i]);
                WidgetList.add(TextFormField(
                  controller: newController,
                  focusNode: newFocusNode,
                  maxLines: null,
                  style: TextStyle(
                    fontFamily: fontFamilyIs.isEmpty ? null : fontFamilyIs,
                  ),
                  onChanged: (value) async {
                    int index = _textEditingController.indexOf(newController);
                    _addTextInController[index] = value;
                    if (value.endsWith("\n")) {
                      String newText = value.substring(0, value.length - 1);
                      _textEditingController[index].text = newText;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        FocusNode nextFocusNode = focusNode[index + 1];
                        nextFocusNode.requestFocus();
                      });
                      await addTextFormField();
                    }
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    prefix: bulletListSelect.isNotEmpty
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.asset(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.bottomCenter,
                              scale:
                                  bulletListSelect == constant.bulletListIcon[8]
                                      ? 4
                                      : 30,
                              bulletListSelect,
                            ),
                          )
                        : null,
                  ),
                ));
                // _textEditingController.last.text = value;
              }
            }
          } else {
            print("Unexpected element type: ${value.runtimeType}");
          }
          // }
        } else if (key.startsWith("drawImages")) {
          if (value is List<dynamic>) {
            for (var unit8ListValue in value) {
              _drawImages.add(unit8ListValue);
              WidgetList.add(Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SizedBox(
                    height: 14.h,
                    width: 80.w,
                    child: Image.memory(
                      unit8ListValue,
                    ),
                  ),
                ),
              ));
            }
          } else {
            print("Unexpected element type: ${value.runtimeType}");
          }
        }
      });
    }
  }
}
