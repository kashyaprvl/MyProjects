import 'package:englishtogujarati/screens/favouriteandhistoryview.dart';
import 'package:englishtogujarati/services/AdManager.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/shape/gf_icon_button_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/DataModel.dart';
import '../controllers/AppController.dart';
import '../controllers/styles.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List favourite = [];
  List originalword = [];
  List<DataModel> _favouriteList= [];
  bool isLoading = true;
  bool selectAll = false;
  DateTime pre_backpress = DateTime.now();
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();

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
    GetSavedFData().whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });_loadInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          body: (isLoading)?const Center(child: CircularProgressIndicator()):
          WillPopScope(
            onWillPop: ()async {
              final timegap = DateTime.now().difference(pre_backpress);
              final cantExit = timegap >= const Duration(seconds: 2);
              pre_backpress = DateTime.now();
              //AdManager.showAd(AdManager.INTERSTITIAL);
              Navigator.pop(context);
              if (_interstitialAd != null) {
                _interstitialAd?.show();
              } _loadInterstitialAd();

              if(cantExit){
                return false; // false will do nothing when back press
              }else{
                return true;   // true will exit the app
              }

            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: AppController.getScreenHeight(context) * 0.09,
                  child: Container(color: Colors.grey.shade200,
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
                        const Padding(
                          padding:  EdgeInsets.only(left: 10.0),
                          child: Text("Favourite",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                        ),
                        Spacer(),
                        Align(alignment: Alignment.centerRight,
                          child: Checkbox(
                            activeColor: Colors.black,
                            checkColor: Colors.white,
                            value: selectAll,
                            onChanged: (bool? value) {
                              selectAll =!selectAll;

                              for(int i=0;i<_favouriteList.length;i++) {
                                setState(() {
                                  _favouriteList[i].isSelected = value!; //!_favouriteList[i].isSelected;
                                });
                              }

                            },
                          ),
                        ),
                        Align(alignment: Alignment.centerRight,
                          child: GFIconButton(size: GFSize.MEDIUM,
                              type: GFButtonType.transparent,
                              color: Colors.black,icon: const Icon(Icons.delete), onPressed: () {
                                _favouriteList.removeWhere((DataModel element) => element.isSelected==true);
                                if(selectAll==true){
                                  setRemoveFData();}
                                else{
                                  // remove element one by one
                                  setUpdatedData();
                                }
                                setState(()  {
                                  selectAll=false;});
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Container(
                    height: AppController.getScreenHeight(context) * 0.78,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView.builder(
                          itemCount: _favouriteList.length,
                          itemBuilder: (BuildContext context, int index) {
                            int i=_favouriteList.length -(index+1);
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 7.0),
                              child: ListTile(
                                tileColor: (i%2==0)?(Styles.tileColor1):(Styles.tileColor2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

                                subtitle: Text(_favouriteList[i].original,
                                  style: (i%2==0)?Styles.listTitleStyle: Styles.listSubTitleStyle1,  overflow: TextOverflow.ellipsis, softWrap: false,),
                                title: Text(_favouriteList[i].translation,
                                  style: (i%2==0)?Styles.listSubTitleStyle: Styles.listSubTitleStyle1,  overflow: TextOverflow.ellipsis, softWrap: false,),
                                trailing:Checkbox(
                                  activeColor: (i%2==0)?Colors.white:Colors.black,
                                  checkColor:  (i%2==0)?Colors.black:Colors.white,
                                  value: _favouriteList[i].isSelected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _favouriteList[i].isSelected = value!;//!_favouriteList[index].isSelected;
                                    });
                                  },
                                ),
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
                                      FavouriteAndHistoryView(selectedOriginalTranslatedWord: _favouriteList[i])));
                                },
                              ),
                            );
                          }),
                    ),
                  ),
                ),
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
        ));
  }

  Future<void> GetSavedFData() async {
    SharedPreferences prefs = await _prefs;
    // favourite = prefs.getStringList('favouriteWord') ?? [];
    List<String> favourite = prefs.getStringList('favouriteWord') ??[];
    if(_favouriteList.isNotEmpty){
      print("no data");
    }
    else{
      _favouriteList = favourite.map((e) {
        String original = prefs.getString(e)??"";
        return DataModel(original: e, translation: original);
      }).toList();
      _favouriteList==null;
    }

  }

  Future<void> setRemoveFData() async {
    SharedPreferences prefs = await _prefs;
    List<String> l= [];
    prefs.setStringList("favouriteWord",l);
  }

  Future<void> setUpdatedData() async {
    var pref = await SharedPreferences.getInstance();
    List<String> l = [];
    _favouriteList.forEach((element) {
      pref.setString(element.translation, element.original);
      l.add(element.original);
    });
    pref.setStringList('favouriteWord', l);
    print('${pref.getStringList('favouriteWord')}');
  }

}
