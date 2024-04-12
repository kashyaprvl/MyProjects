import 'package:diarynotes/Data_Manager/AppController.dart';
import 'package:diarynotes/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:pattern_lock/pattern_lock.dart';

class SetPattern extends StatefulWidget {
  @override
  _SetPatternState createState() => _SetPatternState();
}

class _SetPatternState extends State<SetPattern> {
  bool isConfirm = false;
  List<int> pattern = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Duration duration = const Duration(seconds: 1);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: brightBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    height: 70,
                    child: Column(
                      children: [
                        Flexible(
                          child: Text(
                            isConfirm ? "Confirm pattern" : "Draw a new unlock pattern",
                            style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),
                          ),
                        ),
                         const Flexible(
                           child: Padding(
                             padding: EdgeInsets.only(top: 15.0),
                             child: Text(
                               "please keep in mind the drawing",
                               style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                             ),
                           ),
                         ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: PatternLock(
                   showInput: true,
                    selectedColor: lightBackgroundColor,
                    fillPoints: true,
                    pointRadius: 13,
                    notSelectedColor: isDarkMode ? Colors.white : Colors.black,
                    onInputComplete: (List<int> input) async{
                     // print(input.runtimeType);
                      if (input.length < 3) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: duration ,
                          content: Text("At least 3 points required", textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                        ));
                        return;
                      }
                      if (isConfirm) {
                        if (listEquals<int>(input, pattern)) {
                          AppController().setIntList("patternPassword", pattern);
                          String empty = "";
                          AppController().setValueString("pinPassword", empty);
                          Navigator.pushNamed(context,"/DiaryLockScreen");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: duration ,
                            content: Text("Patterns do not match", textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                          ));
                          setState(() {
                            pattern = [];
                            isConfirm = false;
                          });
                        }
                      } else {
                        setState(() {
                          pattern = input;
                          isConfirm = true;
                        });
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/pinCodeScreen");
                      },
                      child: Text("Change to pin code")),
                ),
              ],
            ),
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