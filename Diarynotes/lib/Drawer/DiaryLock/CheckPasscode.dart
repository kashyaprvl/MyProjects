import 'package:diarynotes/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pin_code_widget/flutter_pin_code_widget.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pattern_lock/pattern_lock.dart';

import '../../Data_Manager/AppController.dart';
import '../../Data_Manager/ObjectBoxDataModel.dart';

class CheckPasscode extends StatefulWidget {
  const CheckPasscode({super.key});

  @override
  State<CheckPasscode> createState() => _CheckPasscodeState();
}

class _CheckPasscodeState extends State<CheckPasscode> {
  String _getPin = "";
  List<int> _getPattern = [];
  bool? diaryLockEnable;
  bool fingerPrintLockEnable = false;
  String? initialRoute;
  bool wrongPassword = false;

  Duration duration = const Duration(seconds: 1);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeData();
  }

  _initializeData() async{
   await _checkPasscode();
   await _checkPatternAndPin();
   setState(() {});
  }

  _checkPasscode() async{
    final passwordManager = objectBox.store.box<PasswordManger>();
    try{
      diaryLockEnable = passwordManager.getAll().last.diaryLockSwitchOn!;
      print("diaryLockSwitch $diaryLockEnable");
    }catch(e){}
    try{
      fingerPrintLockEnable =  passwordManager.getAll().last.fingerPrintSwitchOn!;
    }catch(e){print(e);}
  }
  _checkPatternAndPin() async{
    try {
      _getPin = await AppController().readString("pinPassword");
      print("_getPin is $_getPin");
    } catch (e) {print(e);}
    try {
      _getPattern = await AppController().readIntList("patternPassword");
      print("_getPattern is $_getPattern");
    } catch (e) {print(e);}
  }

  Future<void> authenticateWithBiometrics() async {
    final localAuth = LocalAuthentication();
    try {
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;
      List<BiometricType> availableBiometrics = await localAuth.getAvailableBiometrics();

      if (canCheckBiometrics) {
        if (availableBiometrics.contains(BiometricType.strong)) {
          print("-----");
          bool isAuthenticated = await localAuth.authenticate(
              localizedReason: 'Authenticate using your fingerprint',
              options: AuthenticationOptions(useErrorDialogs: true,biometricOnly: true)
          );
          if (isAuthenticated) {
            print("it authenticated");
            Navigator.pushNamed(context, "/patternLock");
          } else {
            print('Fingerprint authentication failed');
          }
        } else {
          print('Fingerprint authentication not available on this device.');
        }
      } else {
        print('Biometric authentication not available on this device.');
      }
    } catch (e) {
      print('Error during biometric authentication: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    print("i am here ");
    return Scaffold(
      backgroundColor: brightBackgroundColor,
      body: SafeArea(
        child: Padding(padding: EdgeInsets.all(18.0),
                  child: _getPattern.isNotEmpty ?
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          "Confirm Pattern",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 10),
                        child: wrongPassword ? const Text(
                          "Wrong Pattern",
                          style: TextStyle(color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ) : SizedBox(),
                      ),
                      Flexible(
                        child: PatternLock(
                            showInput: true,
                            selectedColor: lightBackgroundColor,
                            fillPoints: true,
                            pointRadius: 13,
                            notSelectedColor: isDarkMode ? Colors.white : Colors.black,
                            onInputComplete: (input) async {
                              if (listEquals<int>(input, _getPattern)) {
                                print("this is ${input} and this is _getpatter $_getPattern");
                                Navigator.pushNamed(context, "/patternLock");
                              }
                              else {
                                setState(() {
                                  wrongPassword = true;
                                });
                              }
                            }),
                      ),
                      fingerPrintLockEnable == true ? Center(
                        child: IconButton(
                          onPressed: authenticateWithBiometrics,
                          icon: Icon(Icons.fingerprint),
                        ),
                      ):SizedBox(),
                    ],
                  ) :
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0,bottom: 70),
                        child: Text(
                          "Confirm passcode",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(padding: const EdgeInsets.only(top: 10,bottom: 65),
                        child: wrongPassword ? Text(
                          "Wrong Password",
                          style: TextStyle(color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ) : SizedBox(),
                      ),
                      Container(
                        height: 500,
                        child: PinCodeWidget(
                          centerBottomWidget: fingerPrintLockEnable== true ? IconButton(
                            onPressed: authenticateWithBiometrics,
                            icon: Icon(Icons.fingerprint,),
                          ):SizedBox(),
                          buttonColor: brightBackgroundColor,
                          minPinLength: 4,
                          maxPinLength: 4,
                          onChangedPin: (pin) {

                          },
                          onEnter: (pin, _) async {
                            if (pin == _getPin) {
                              Navigator.pushNamed(context, "/patternLock");
                            }
                            else {
                              print("-->$_getPin");
                              setState(() {
                                wrongPassword = true;
                              });
                            }
                          },),
                      ),
                    ],
                  ),
                ),
        ),
    );
  }
}
