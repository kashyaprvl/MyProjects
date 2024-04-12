import 'package:diarynotes/Data_Manager/AppController.dart';
import 'package:diarynotes/main.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../Data_Manager/ObjectBoxDataModel.dart';

class DiaryLockScreen extends StatefulWidget {
  const DiaryLockScreen({super.key});

  @override
  State<DiaryLockScreen> createState() => _DiaryLockScreenState();
}

class _DiaryLockScreenState extends State<DiaryLockScreen> {

  bool diaryLockSwitchOn = false;
  bool fingerPrintLockSwitchOn = false;
  String _getPin = "";
  List<int> _getPattern = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPasswordAvailable();
    print("hello");
  }

  _checkPasswordAvailable() async{

    final passwordManager = objectBox.store.box<PasswordManger>();
    try{
      diaryLockSwitchOn = passwordManager.getAll().last.diaryLockSwitchOn!;
      print("diaryLockSwitch $diaryLockSwitchOn");
    }catch(e){}
    try{
      fingerPrintLockSwitchOn =  passwordManager.getAll().last.fingerPrintSwitchOn!;
    }catch(e){print(e);}
    try{
       _getPin = await AppController().readString("pinPassword");
       print(_getPin);
    }catch(e){
      print(e);
    }
    try{
       _getPattern = await AppController().readIntList("patternPassword");
       print(_getPattern);
    }
    catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final passwordManager = objectBox.store.box<PasswordManger>();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: brightBackgroundColor,
        body : SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child:
                Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              splashRadius: 0.001,
                              alignment: Alignment.centerLeft,
                              iconSize: 30,
                              padding: EdgeInsets.only(right: 5),
                              onPressed: () {
                                Navigator.pushNamed(context, "/SettingScreen");
                              },
                              icon:  const Icon(Icons.arrow_back,),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 3.0,),
                              child: Text(
                                "Diary Lock",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Diary Lock", style: TextStyle(
                                      fontWeight: FontWeight.w600)),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2.0),
                                    child: Text(
                                        "Set a password to protect your diary"),
                                  ),
                                ]
                            ),
                            Switch(
                              value: diaryLockSwitchOn,
                              onChanged: (value) async {
                              setState(() {
                                diaryLockSwitchOn = value;
                                if (diaryLockSwitchOn == false) {
                                  fingerPrintLockSwitchOn = false;
                                }
                                else {
                                  if(_getPin.isEmpty && _getPattern.isEmpty){
                                    print(_getPin);
                                    print(_getPattern);
                                    Navigator.pushNamed(context, "/patternLock");
                                  }
                                }
                                if(_getPattern.isNotEmpty || _getPin.isNotEmpty) {
                                  passwordManager.put(PasswordManger(
                                      id: 0, diaryLockSwitchOn: value));
                                }
                              });
                            },
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            if(diaryLockSwitchOn == true) {
                              Navigator.pushNamed(context, "/CheckPasscode");
                            }
                          },
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("set a passcode",
                                    style: TextStyle(fontWeight: FontWeight.w600)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 2.0),
                                child: Text("set a change your passcode"),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("FingerPrint use",
                                  style: TextStyle(fontWeight: FontWeight.w600)),
                              Switch(
                                value: fingerPrintLockSwitchOn,
                                onChanged: (value) async{
                                  final localAuth = LocalAuthentication();
                                  List<BiometricType> availableBiometrics = await localAuth.getAvailableBiometrics();
                                  if(availableBiometrics.contains(BiometricType.strong)) {
                                    setState(() {
                                      diaryLockSwitchOn == false
                                          ? null
                                          : fingerPrintLockSwitchOn = value;
                                      passwordManager.put(PasswordManger(id: 0,
                                          diaryLockSwitchOn: diaryLockSwitchOn,
                                          fingerPrintSwitchOn: fingerPrintLockSwitchOn)
                                      );
                                    });
                                  }else{
                                    Fluttertoast.showToast(
                                        toastLength: Toast.LENGTH_LONG,
                                        fontSize: Adaptive.px(18),
                                        backgroundColor: lightBackgroundColor,
                                        gravity: ToastGravity.BOTTOM,
                                        msg: "Fingerprint authentication not available on this device.");
                                  }
                                },),
                            ],
                          ),
                        ),
                      ],
                    ),
              ),
                 ),
            ),
          ),
    );
  }
  Future<bool> _onWillPop() {
    Navigator.pushNamed(context,"/SettingScreen");
    return Future.value(false);
  }
}
