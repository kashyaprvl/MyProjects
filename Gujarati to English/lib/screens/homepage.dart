import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:englishtogujarati/Widgets/TLIconButton.dart';
import 'package:englishtogujarati/controllers/AppController.dart';
import 'package:englishtogujarati/controllers/constants.dart';
import 'package:englishtogujarati/screens/myappdrawer.dart';
import 'package:englishtogujarati/services/AdManager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:translator/translator.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as sst;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';
import '../controllers/styles.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({Key? key}) : super(key: key);

  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> with WidgetsBindingObserver{

  final FocusNode _titleFocus = FocusNode();

  String translation = "";
  String originalWord = "";
  String? copiedData;
  bool _isListening = false;
  bool isEnglish = true;
  bool isReverse = false;
  bool isAdLoaded = false;
  late sst.SpeechToText _speech;
  FlutterTts _flutterTts = FlutterTts();

  var wordController = TextEditingController();
  var translationController = TextEditingController();

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  StreamSubscription? internetconnection;
  bool isoffline = false;
  bool isTypingPause =false;
  bool isTransleterPause =false;
  late AppLifecycleState _notification;


  DateTime pre_backpress = DateTime.now();

  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;

  Future<void> _loadAd() async {

    final AnchoredAdaptiveBannerAdSize? size =
    await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    _anchoredAdaptiveAd = BannerAd(
      // TODO: replace these test ad units with your own ad unit.
      adUnitId: AdHelper.bannerAdUnitId,
      size: size,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$ad loaded: ${ad.responseInfo}');
          setState(() {
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;


  @override
  void initState() {
    super.initState();
    _speech = sst.SpeechToText();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      AppController.hideKeyboard(context);
    });
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    appOpenAdManager.loadAd();
    WidgetsBinding.instance!.addObserver(this);

  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Couldn\'t check connectivity status ${e.toString()}');
      }
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });

    if(result == ConnectivityResult.none){
      Fluttertoast.showToast( msg: 'Please Check Your Internet Connection!',timeInSecForIosWeb: 1);
    }
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.inactive || state==AppLifecycleState.detached){
      return ;
    }
    final isBackground= state==AppLifecycleState.paused;
    if(isBackground ){
      _flutterTts.stop();
    }
    if (state == AppLifecycleState.paused) {
      isPaused = true;
    }

    if (state == AppLifecycleState.resumed && isPaused) {
      print("Resumed==========================");
      appOpenAdManager.showAdIfAvailable();
      isPaused = false;
    }

  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    internetconnection?.cancel();
    _key.currentState?.dispose();
    isoffline;
    _connectivitySubscription.cancel();
    WidgetsBinding.instance!.removeObserver(this);


  }
  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();

  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async{
        final timegap = DateTime.now().difference(pre_backpress);
        final cantExit = timegap >= const Duration(seconds: 2);
        pre_backpress = DateTime.now();
        if(cantExit){
          const snack = SnackBar(content: Text('Press Back button again to Exit'),duration: Duration(seconds: 2),);
          ScaffoldMessenger.of(context).showSnackBar(snack);
          return false; // false will do nothing when back press
        }else{

          return true;   // true will exit the app
        }
      },

      child: SafeArea(child: Scaffold(
        onDrawerChanged: (value){
          if(value){
            _titleFocus.unfocus();
            _flutterTts.stop();
            print('Drawer : true');

          } else{
            Timer(Duration(seconds: 1), () {
              print("Yeah, this line is printed after 3 seconds");
            });
            print('Drawer: false');
          }

        },
        resizeToAvoidBottomInset: false,
        key: _key,
        drawer:  TranslationAppDrawer(titleFocus: _titleFocus,),
        body:
        Container(
          color: Styles.appWhite,
          height: AppController.getScreenHeight(context),
          child: Column(
            children: [
              SizedBox(
                height: AppController.getScreenHeight(context) * 0.0765,
                child: Stack(
                  children: [
                    const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Let's Translate",
                          style: Styles.headerStyle,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: GFIconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onPressed: () {
                              _key.currentState?.openDrawer();
                            },
                            color: Colors.white,
                            icon: const Icon(
                              Icons.menu_rounded,
                              size: 30,
                              color: Styles.appBlack,
                            ),
                            shape: GFIconButtonShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              _buildLanguageCard(),
              _buildTypingCard(),

              _buildTranslationCard(),
              Spacer(),
              if (_anchoredAdaptiveAd != null && _isLoaded)
                Container(
                  width: _anchoredAdaptiveAd!.size.width.toDouble(),
                  height: _anchoredAdaptiveAd!.size.height.toDouble(),
                  child: AdWidget(ad: _anchoredAdaptiveAd!),
                )
            ],
          ),

        ),

      )
      ),
    );

  }

  _buildLanguageCard() {
    return Container(
      height: AppController.getScreenHeight(context) * 0.16,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0,right: 10,left: 10),
        child: Card(
          color: Styles.bgColor,
          shape: Styles.roundShape,
          elevation: 3,
          shadowColor: Styles.appThemeColor,
          child: Row(

            children: [
              getLangIcon(1),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Align(
                    alignment: Alignment.center,
                    child: GFIconButton(
                      onPressed: () {
                        setState(() {
                          isEnglish = !isEnglish;
                          isReverse = !isReverse;
                          // isAdLoaded = !isAdLoaded;
                        });
                      },
                      shape: GFIconButtonShape.circle,
                      size: GFSize.LARGE,
                      color: Styles.appThemeColor,
                      icon: Image.asset(Constants.img_exchange),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0,left: 15.0,top: 1,),
                    child: Text(
                      "",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      textAlign: TextAlign.center,

                    ),
                  ),

                ],
              ),
              getLangIcon(2)
            ],
          ),
        ),
      ),
    );
  }

  getLangIcon(int index) {
    int listIndex = (isReverse)
        ? (index == 1)
        ? 1
        : 0
        : (index == 1)
        ? 0
        : 1;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: (index==1)?Alignment.center:Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0,left: 15.0,bottom: 10,top: 10.0),
              child: SizedBox(
                  height: AppController.getScreenHeight(context) * 0.07,
                  child: Image.asset(Constants.langIcons[listIndex])),
            ),
          ),
          Align(
            alignment: (index==1)?Alignment.center:Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0,left: 15.0,top: 1,),
              child: Text(
                Constants.languageNames[listIndex],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                textAlign: TextAlign.center,

              ),
            ),
          ),

        ],
      ),
    );
  }

  _buildTypingCard() {
    return SizedBox(
      height: AppController.getScreenHeight(context) * 0.32 - ((_isLoaded) != null ?1: 0),
      child: Padding(
        padding:EdgeInsets.only(left: 10,right: 10),
        child: Card(
          color: Styles.tileColor1,
          shape: Styles.roundShape,
          elevation: 3,
          shadowColor: Styles.appThemeColor,
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left:15.0,top: 10.0),
                child:TextFormField(
                  focusNode: _titleFocus,
                  style: const TextStyle(
                    color: Styles.appWhite, fontSize: 21,overflow: TextOverflow.fade,),
                  controller: wordController,
                  maxLines: getMaxLines(),
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                    hintText: "Type Here...",
                  ),
                ),
              ),
              // const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 6.0),
                        child: TLIconButton(
                            image: Constants.img_paste,
                            onTap: () async {
                              final data = await Clipboard.getData(
                                  Clipboard.kTextPlain);
                              wordController.text = data!.text!;
                              Fluttertoast.showToast(
                                  msg: "Paste",  // message
                                  toastLength: Toast.LENGTH_SHORT, // length
                                  gravity: ToastGravity.BOTTOM,    // location
                                  timeInSecForIosWeb: 1               // duration
                              );
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 6.0),
                        child: TLIconButton(
                            image: Constants.img_cancel,
                            onTap: () {
                              if (wordController.text.isNotEmpty) {
                                setState(() {
                                  wordController.text = "";
                                  translation = "";
                                  Fluttertoast.showToast(
                                      msg: "Clear",  // message
                                      toastLength: Toast.LENGTH_SHORT, // length
                                      gravity: ToastGravity.BOTTOM,    // location
                                      timeInSecForIosWeb: 1               // duration
                                  );
                                });
                              }
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 6.0),
                        child: TLIconButton(
                            image: Constants.img_mic,
                            onTap: () async {
                              Fluttertoast.showToast(
                                  msg: "Mic Is On",  // message
                                  toastLength: Toast.LENGTH_SHORT, // length
                                  gravity: ToastGravity.BOTTOM,    // location
                                  timeInSecForIosWeb: 1               // duration
                              );
                              _listen();
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 6.0),
                        child: TLIconButton(
                            image: (isTypingPause)?Constants.img_play:Constants.img_play,
                            onTap: () {

                              (isTypingPause)?pause():speak(wordController.text);
                            }),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: GFButton(
                            hoverElevation: 0,
                            highlightColor: Colors.transparent,
                            onPressed: () {
                              initConnectivity();
                              if(_connectionStatus == ConnectivityResult.none){
                                Fluttertoast.showToast(msg: "Please Check Your Internet Connection!",timeInSecForIosWeb: 1);

                              }
                              if (wordController.text.isNotEmpty &&
                                  wordController.text != "") {
                                languageConveter(wordController.text);

                              }
                              final FocusScopeNode currentScope = FocusScope.of(context);
                              if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                                FocusManager.instance.primaryFocus!.unfocus();
                              }

                            },
                            child: const Text(
                              "Translate",
                              style: Styles.buttonTextStyle,
                            ),
                            shape: GFButtonShape.pills,
                            size: GFSize.LARGE,
                            color: Colors.white),

                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getMaxLines(){
    // make by sir double heignt = AppController.getScreenHeight(context) * 0.36 - ((isAdLoaded) ? 110 : 65);
    double heignt = AppController.getScreenHeight(context) * 0.36 - ((isAdLoaded) ? 80 :50);
    print("$heignt ---> ${heignt~/33}");
    return heignt~/33;
  }

  _buildTranslationCard()    {
    return SizedBox(
      height: AppController.getScreenHeight(context) * 0.32 - ((_isLoaded) != null ? 1 : 0),
      child: Padding(
        padding: EdgeInsets.only(left: 10,right: 10),
        child: Card(
          color: Styles.tileColor2,
          shape: Styles.roundShape,
          elevation: 3,
          shadowColor: Styles.appThemeColor,
          child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,top:10.0,),
                  child: TextFormField(
                    maxLines: getMaxLines(),
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(fontSize:21,fontWeight: FontWeight.bold,color: Colors.black),
                    readOnly: true,
                    onChanged:  changeText(),
                    controller: translationController,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
                //Spacer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
                          child: TLIconButtonBlack(
                              image: Constants.img_copy,
                              onTap: () {
                                Fluttertoast.showToast(
                                    msg: "Copy",  // message
                                    toastLength: Toast.LENGTH_SHORT, // length
                                    gravity: ToastGravity.BOTTOM,    // location
                                    timeInSecForIosWeb: 1               // duration
                                );
                                final data = ClipboardData(text: translation);
                                Clipboard.setData(data);
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 6.0),
                          child: TLIconButtonBlack(
                              image: Constants.img_share,
                              onTap: () {
                                Fluttertoast.showToast(
                                    msg: "Share",  // message
                                    toastLength: Toast.LENGTH_SHORT, // length
                                    gravity: ToastGravity.BOTTOM,    // location
                                    timeInSecForIosWeb: 1               // duration
                                );
                                if (translation.isNotEmpty) {
                                  Share.share(translation);
                                }
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 6.0),
                          child: TLIconButtonBlack(
                              image: Constants.img_whatsapp,
                              onTap: () {
                                if(translation.isNotEmpty){
                                  share();
                                }
                                Fluttertoast.showToast(
                                    msg: "Send What's App",  // message
                                    toastLength: Toast.LENGTH_SHORT, // length
                                    gravity: ToastGravity.BOTTOM,    // location
                                    timeInSecForIosWeb: 1               // duration
                                );
                                // if (translation != null && translation.isNotEmpty) {
                                //   // tts.setLanguage('Gujarati');
                                //   speak(translation);
                                // }
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 6.0),
                          child: TLIconButtonBlack(
                              image: Constants.img_favourite,
                              onTap: () {
                                Fluttertoast.showToast(
                                    msg: "Add in Favourite",  // message
                                    toastLength: Toast.LENGTH_SHORT, // length
                                    gravity: ToastGravity.BOTTOM,    // location
                                    timeInSecForIosWeb: 1               // duration
                                );
                                SaveFData();
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 6.0),
                          child: TLIconButtonBlack(
                              image:(isTransleterPause)?Constants.img_play_white: Constants.img_play_white,
                              onTap: () {

                                if (translation != null && translation.isNotEmpty) {
                                  // tts.setLanguage('Gujarati');
                                  (isTransleterPause)?pauseTranslateCard(): speakTranslateCard(translation);
                                }
                              }),
                        ),

                      ],
                    ),
                  ),
                )
              ]
          ),
        ),
      ),
    );
  }

  void languageConveter(String text) async {
    final translator = GoogleTranslator();
    Translation trans = await translator.translate(text,
        from: (isEnglish) ? 'en' : 'gu', to: (isEnglish) ? 'gu' : 'en');
    setState(() {
      translation = trans.text;
      SaveHistoryData();
    });
  }

  Future<void> showDialogBox() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Center(
                child: AvatarGlow(
                  child: Icon(Icons.mic),
                  endRadius: 100,
                  glowColor: Colors.greenAccent,
                )),
          );
        });
  }

  Future<void> SaveHistoryData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> l = prefs.getStringList('totalword') ?? [];
    if (translation != "") {

      prefs.setString(translation, '${wordController.text}');
      l.add(translation);
      prefs.setStringList('totalword', l);
    }
    print(prefs.getStringList('totalword'));
    // prefs.setString('${wordController.text}', translation);
  }

  Future<void> SaveFData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favouritewords = prefs.getStringList('favouriteWord') ?? [];
    if (translation != "") {
      //TODO remove this line after verifying the details
      // prefs.setString(translation,'${wordController.text}');
      favouritewords.add('${translation}');
      prefs.setStringList('favouriteWord', favouritewords);
      // print(translation);
    }
    print('${prefs.getStringList('favouriteWord')}');
  }


  void speak(String text) {
    _flutterTts.speak(text);
    _flutterTts.setVolume(1.0);
    _flutterTts.setLanguage("my");
    _flutterTts.setCompletionHandler(() {
      print("Speak Completed");
      isTypingPause=false;
    });



    // tts.setVolume(1.0);
    // tts.speak(text);
    setState(() {
      isTypingPause=true;
      // isTransleterPause=true;


    });


  }
  void pause() {
    // tts.setVolume(1.0);
    _flutterTts.stop();
    // tts.stop();
    setState(() {
      isTypingPause=false;
      //isTransleterPause=false;
    });


  }


  void speakTranslateCard(String text) {
    _flutterTts.speak(text);
    _flutterTts.setVolume(1.0);
    _flutterTts.setLanguage("my");
    _flutterTts.setCompletionHandler(() {
      print("Speak Completed");
      isTransleterPause=false;
    });



    // tts.setVolume(1.0);
    // tts.speak(text);
    setState(() {
      isTransleterPause=true;
      // isTransleterPause=true;


    });

  }
  void pauseTranslateCard() {
    // tts.setVolume(1.0);
    // tts.setVolume(1.0);
    _flutterTts.stop();
    // tts.stop();
    setState(() {

      isTransleterPause=false;
    });


  }


  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          print('onStatus1: $val');
          if (val == sst.SpeechToText.doneStatus) {
            /// Test
            _isListening = false;
            _speech.stop();
            Navigator.of(context).maybePop();
            // Navigator.pushNamed(context, "/homepage");

          } else {
            print('canclled');
          }
        },
        onError: (val) {
          print('onStatus2: $val');

          /// Test
          _isListening = false;
          _speech.stop();
          Navigator.of(context).pop();
          // Navigator.pushNamed(context, "/homepage");
        },
      );
      if (available) {
        setState(() => _isListening = true);
        showDialogBox();

        _speech.listen(
          onResult: (val) {
            setState(() {
              wordController.text = val.recognizedWords;

              /// Test
              _isListening = false;
            });
          },
        );
      }
    }
  }

  changeText(){
    Text(translationController.text = translation,);
  }

  Future<void> share() async {
    await WhatsappShare.share(
      text: '',
      linkUrl: translation,
      phone: '91xxxxxxxxxx',
    );
  }
}




