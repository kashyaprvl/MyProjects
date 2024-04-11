import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/DataModel.dart';
import '../controllers/AppController.dart';
import '../controllers/styles.dart';
import '../services/AdManager.dart';
import 'favouriteandhistoryview.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  List<DataModel> _historyList = [];
  bool isLoading = true;
  bool selectAll = false;
  DateTime pre_backpress = DateTime.now();
  bool isAdLoaded = false;
  InterstitialAd? _interstitialAd;
  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;
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
    super.initState();
    getData().whenComplete((){
      setState(() {
        isLoading = false;
      });
    });_loadInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: ()async {
          final timegap = DateTime.now().difference(pre_backpress);
          final cantExit = timegap >= const Duration(seconds: 2);
          pre_backpress = DateTime.now();

          Navigator.pop(context);
          if (_interstitialAd != null) {
            _interstitialAd?.show();
          }
          _loadInterstitialAd();
          if(cantExit){
            return false; // false will do nothing when back press
          }else{
            return true;   // true will exit the app
          }

        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,

          body: (isLoading) ?
          const Center(child: CircularProgressIndicator(),) :
          Column(
            children: [
              SizedBox(
                height: AppController.getScreenHeight(context) * 0.09,
                child: Container(
                  color: Colors.grey.shade200,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GFIconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: () {
                            Navigator.pop(context);
                            if (_interstitialAd != null) {
                              _interstitialAd?.show();
                            }
                            _loadInterstitialAd();
                          },
                          color: Colors.white,
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 30,
                            color: Styles.appBlack,
                          ),
                          shape: GFIconButtonShape.circle,
                        ),
                      ),

                      const Padding  (
                        padding:  EdgeInsets.only(left: 10.0),
                        child: Text("History",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Checkbox(
                          activeColor: Colors.black,
                          checkColor: Colors.white,
                          value: selectAll,
                          onChanged: (bool? value) {
                            selectAll =!selectAll;
                            for(int i=0;i<_historyList.length;i++) {
                              setState(() {
                                _historyList[i].isSelected = value!;
                              });
                            }
                          },
                        ),
                      ),
                      Align(alignment: Alignment.centerRight,
                        child: GFIconButton(size: GFSize.MEDIUM,
                          type: GFButtonType.transparent, color: Colors.black,
                          icon:  Icon(Icons.delete), onPressed: () {
                            _historyList.removeWhere((DataModel element) => element.isSelected==true);
                            setUpdatedData();
                            setState(()  {selectAll=false;});
                          },),
                      ),

                    ],
                  ),
                ),
              ),
              Container(
                height: AppController.getScreenHeight(context) * 0.79,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    //reverse: true,
                      itemCount: _historyList.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        int i=_historyList.length -(index+1);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: ListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> FavouriteAndHistoryView(selectedOriginalTranslatedWord: _historyList[i],)));
                            },
                            tileColor:(i%2==0)?Styles.tileColor1:Styles.tileColor2,

                            title: Text(_historyList[i].translation,
                              style: (i%2==0)?Styles.listSubTitleStyle:Styles.listSubTitleStyle1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            subtitle: Text(_historyList[i].original,
                              style: (i%2==0)?Styles.listSubTitleStyle:Styles.listSubTitleStyle1,
                              overflow: TextOverflow.ellipsis,),

                            trailing:Checkbox(
                              activeColor: (i%2==0)?Colors.white:Colors.black,
                              checkColor:  (i%2==0)?Colors.black:Colors.white,
                              value: _historyList[i].isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  _historyList[i].isSelected = value!;//!_favouriteList[index].isSelected;
                                });
                              },
                            )
                            ,
                          ),
                        );
                      }
                  ),
                ),
              ),
              Spacer(),
              if (_anchoredAdaptiveAd != null && _isLoaded)
                Container(
                  // margin: EdgeInsets.only(top: 10.6),
                  width: _anchoredAdaptiveAd!.size.width.toDouble(),
                  height: _anchoredAdaptiveAd!.size.height.toDouble(),
                  child: AdWidget(ad: _anchoredAdaptiveAd!,),
                )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getData() async {
    var pref = await SharedPreferences.getInstance();
    List<String> history = pref.getStringList('totalword') ?? [];
    _historyList = history.map((e) {
      String translation = pref.getString(e)??"";
      return DataModel(original: e, translation: translation);
    }).toList();
  }

  Future<void> setUpdatedData() async {
    var pref = await SharedPreferences.getInstance();
    List<String> l = [];
    _historyList.forEach((element) {
      pref.setString(element.translation, element.original);
      l.add(element.original);
    });
    pref.setStringList('totalword', l);
    print('${pref.getStringList('totalword')}');
  }
}
