import 'package:englishtogujarati/Widgets/TLIconButton.dart';
import 'package:englishtogujarati/controllers/AppController.dart';
import 'package:englishtogujarati/controllers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../Model/DataModel.dart';
import '../controllers/styles.dart';
import '../services/AdManager.dart';

class FavouriteAndHistoryView extends StatefulWidget {
  DataModel selectedOriginalTranslatedWord;

  FavouriteAndHistoryView({Key? key, required this.selectedOriginalTranslatedWord}) : super(key: key);

  @override
  State<FavouriteAndHistoryView> createState() => _FavouriteAndHistoryViewState();
}

class _FavouriteAndHistoryViewState extends State<FavouriteAndHistoryView>  with WidgetsBindingObserver{
  FlutterTts _flutterTts = FlutterTts();
  bool isAdLoaded = false;
  bool isTypingPause =false;
  bool isTransleterPause =false;
  InterstitialAd?  _interstitialAd;
  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;

  Future<void> _loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize? size =
    await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    _anchoredAdaptiveAd = BannerAd(
      // TODO: replace these test ad units with your own ad unit.
      adUnitId:AdHelper.bannerAdUnitId,
      size: size,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$ad loaded: ${ad.responseInfo}');
          setState(() {
            // When the ad is loaded, get the ad size and use it to set
            // the height of the ad container.
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

  void _loadInterstitialAd() {

    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              _loadInterstitialAd();
            },
          );

          setState(() {
            _interstitialAd = ad;
            _loadInterstitialAd();
          });
        },

        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      AppController.hideKeyboard(context);

    });
    _loadInterstitialAd();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.inactive || state==AppLifecycleState.detached ){
      return ;
    }
    final isBackground= state==AppLifecycleState.paused;
    if(isBackground ){
      _flutterTts.stop();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }
  DateTime pre_backpress = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: ()async{
          final timegap = DateTime.now().difference(pre_backpress);
          final cantExit = timegap >= const Duration(seconds: 2);
          pre_backpress = DateTime.now();
          Navigator.pop(context);
          if (_interstitialAd != null) {
          }
          _loadInterstitialAd();
          if(cantExit){
            _flutterTts.stop();
            return false; // false will do nothing when back press
          }else{

            return true;   // true will exit the app
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              SizedBox(
                height: AppController.getScreenHeight(context)*0.1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GFIconButton(
                          onPressed: (){
                            Navigator.pop(context);
                            _flutterTts.stop();
                            if (_interstitialAd != null) {
                              // _interstitialAd?.show();
                            }
                            //AdManager.showAd(AdManager.INTERSTITIAL);
                          },
                          icon: Icon(Icons.arrow_back),
                          shape: GFIconButtonShape.circle,
                          color: Colors.black,),
                      ),
                      Align(alignment: Alignment.center,
                          child: Text("Translate",style: Styles.headerStyle,))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height:  AppController.getScreenHeight(context) * 0.38 - ((_isLoaded) ? 3 : 0),
                width:  double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    // color: Color(0xFF2346de),
                    color: Styles.tileColor1,
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:15.0,top: 8.0),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: widget.selectedOriginalTranslatedWord.translation,
                            maxLines: getMaxLines(),
                            decoration: InputDecoration(border: InputBorder.none),
                            style: TextStyle(color: Colors.white,fontSize: 22),
                          ),
                        ),

                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child:  TLIconButtonBlack(
                                image:(isTypingPause)?Constants.img_play_white: Constants.img_play_white,
                                onTap: () {

                                  if (widget.selectedOriginalTranslatedWord.translation != null && widget.selectedOriginalTranslatedWord.translation.isNotEmpty) {
                                    // tts.setLanguage('Gujarati');
                                    (isTypingPause)?pause(): speak(widget.selectedOriginalTranslatedWord.translation);
                                  }
                                }),

                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height:  AppController.getScreenHeight(context) * 0.38 - ((_isLoaded) ? 3 : 0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 3.0,
                    color: Styles.tileColor2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:15.0,top: 10.0),
                          child: TextFormField(
                            initialValue: widget.selectedOriginalTranslatedWord.original,
                            maxLines: getMaxLines(),
                            readOnly: true,
                            decoration: InputDecoration(border: InputBorder.none),
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child:  TLIconButtonBlack(
                                      image:(isTransleterPause)?Constants.img_play_white: Constants.img_play_white,
                                      onTap: () {

                                        if (widget.selectedOriginalTranslatedWord.original != null && widget.selectedOriginalTranslatedWord.original.isNotEmpty) {
                                          // tts.setLanguage('Gujarati');
                                          (isTransleterPause)?pauseTranslateCard(): speakTranslateCard(widget.selectedOriginalTranslatedWord.original);
                                        }
                                      }),

                                ),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              if (_anchoredAdaptiveAd != null && _isLoaded)
                Container(
                  margin: EdgeInsets.only(top: 15.6),
                  width: _anchoredAdaptiveAd!.size.width.toDouble(),
                  height: _anchoredAdaptiveAd!.size.height.toDouble(),
                  child: AdWidget(ad: _anchoredAdaptiveAd!),
                ),

            ],
          ),
        ),
      ),
    );
  }


  getMaxLines(){
    // make by sir double heignt = AppController.getScreenHeight(context) * 0.36 - ((isAdLoaded) ? 110 : 65);
    double heignt = AppController.getScreenHeight(context) * 0.39 - ((isAdLoaded) ? 120 :35);
    print("$heignt ---> ${heignt~/33}");
    return heignt~/33;
  }


  void speak(String text) {
    _flutterTts.speak(text);
    _flutterTts.setVolume(1.0);
    _flutterTts.setCompletionHandler(() {
      print("Speak Completed");
      isTypingPause=false;
    });

    setState(() {
      isTypingPause=true;

    });


  }
  void pause() {
    _flutterTts.stop();
    setState(() {
      isTypingPause=false;
    });
  }

  void speakTranslateCard(String text) {
    _flutterTts.speak(text);
    _flutterTts.setVolume(1.0);
    _flutterTts.setLanguage("ar");
    _flutterTts.setCompletionHandler(() {
      print("Speak Completed");
      isTransleterPause=false;
    });
    setState(() {
      isTransleterPause=true;
    });

  }
  void pauseTranslateCard() {
    _flutterTts.stop();
    setState(() {
      isTransleterPause=false;
    });
  }

}

