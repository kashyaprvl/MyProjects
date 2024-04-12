import 'package:diarynotes/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pin_code_widget/flutter_pin_code_widget.dart';

import '../../Data_Manager/AppController.dart';

class PinCodeScreen extends StatefulWidget {
  const PinCodeScreen({super.key});

  @override
  State<PinCodeScreen> createState() => _pinCodeScreenState();
}

class _pinCodeScreenState extends State<PinCodeScreen> {

  String currentPin = "";
  Duration duration = const Duration(seconds: 1);
  bool isConfirm = false;


  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: brightBackgroundColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(
                isConfirm ?   "Confirm PIN" : "Set up PIN",
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 20),
              const Text('You can use this PIN to unlock the app..'),
              const Text('Pin length is 4 digits'),
              const SizedBox(height: 60),
              Expanded(
                child: Container(
                  // color: Colors.deepOrange,
                  child: PinCodeWidget(
                    backgroundColor: brightBackgroundColor,
                    filledIndicatorColor: isDarkMode ? Colors.white : Colors.black,
                    buttonColor: lightBackgroundColor,
                    minPinLength: 4,
                    maxPinLength: 4,
                    onChangedPin: (pin) {
                    },
                    onEnter: (pin, _) async{
                      if (pin.length < 4) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: duration ,
                          content: Text("At least 4 digit required", textAlign: TextAlign.center,
                            style: TextStyle(color: brightBackgroundColor,fontSize: 12),
                          ),
                        ));
                        currentPin = pin;
                        return;
                      }
                      if (isConfirm) {
                        print("this is current pin $currentPin and this is pin $pin");
                        if (pin.toString() == currentPin.toString()) {
                           AppController().setValueString("pinPassword", currentPin);
                           List<int> empty = [];
                           AppController().setIntList("patternPassword", empty);
                           Navigator.pushNamed(context,"/DiaryLockScreen");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: duration ,
                            content: Text("Pin do not match", textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white,fontSize: 12),
                            ),
                          ));
                          setState(() {
                            currentPin = "";
                            isConfirm = false;
                          });
                        }
                      } else {
                        setState(() {
                          currentPin = pin;
                          isConfirm = true;
                        });
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/patternLock");
                    },
                    child: const Text("Change to Pattern")),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<bool> _onWillPop() {
    Navigator.pushNamed(context,"/DiaryLockScreen");
    return Future.value(false);
  }
}
