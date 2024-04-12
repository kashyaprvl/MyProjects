import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pin_code_widget/flutter_pin_code_widget.dart';
import 'package:pattern_lock/pattern_lock.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'Data_Manager/AppController.dart';
import 'Data_Manager/ObjectBoxDataModel.dart';
import 'Data_Manager/ThemeMode.dart';
import 'main.dart';

class PasswordCheckScreen extends StatefulWidget {
  const PasswordCheckScreen({super.key});

  @override
  State<PasswordCheckScreen> createState() => _PasswordCheckScreenState();
}

class _PasswordCheckScreenState extends State<PasswordCheckScreen> {
  String _getPin = "";
  List<int> _getPattern = [];
  bool? diaryLockEnable;
  bool? fingerPrintLockEnable;
  String? initialRoute;
  int selectedIndex = 0;
  bool wrongPassword = false;

  Duration duration = const Duration(seconds: 1);

  @override
  void initState() {
    // TODO: implement initState
    selectTheme();
    super.initState();
  }

  selectTheme() async{
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    selectedIndex = themeManager.getAll().last.selectedTheme!;
    print("this is index $selectedIndex");
    backgroundImage = AppController().loadBackgroundImageTheme(selectedIndex);
   lightBackgroundColor =  await AppController().loadBackgroundLightColorScreenTheme(selectedIndex);
    floatingActionButtonColor = await AppController().navigatorFloatingActionButtonColor(selectedIndex);
    brightBackgroundColor =  await AppController().loadBackgroundBrightColorScreenTheme(selectedIndex);
    if (!(selectedIndex == 1 || selectedIndex == 2 || selectedIndex == 6)) {
      await themeNotifier.darkTheme();
      isDarkMode = true;
    }   else {
      await themeNotifier.lightTheme();
      isDarkMode = false;
    }
    await _checkPasscode();
  }

  Future<void> authenticateWithBiometrics() async {
    final localAuth = LocalAuthentication();
    try {
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;
      List<BiometricType> availableBiometrics =
          await localAuth.getAvailableBiometrics();
      if (canCheckBiometrics) {
        if (availableBiometrics.contains(BiometricType.strong)) {
          print("-----");
          bool isAuthenticated = await localAuth.authenticate(
              localizedReason: 'Authenticate using your fingerprint',
              options: const AuthenticationOptions(
                  useErrorDialogs: true, biometricOnly: true));
          if (isAuthenticated) {
            try{
              Navigator.pushNamed(context, "/MultiPageView");
            }catch(e){
              Navigator.pushNamed(context, "/chooseTheme");
            }
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

  _checkPasscode() async {
    final passwordManager = objectBox.store.box<PasswordManger>();
    try {
      _getPin = await AppController().readString("pinPassword");
      print("this is get pin check passcode screen $_getPin");
    } catch (e) {
      print(e);
    }
    try {
      _getPattern = await AppController().readIntList("patternPassword");
      print("this is get pin check passcode screen $_getPattern");

    } catch (e) {
      print(e);
    }
    try {
      diaryLockEnable =  passwordManager.getAll().last.diaryLockSwitchOn!;
    } catch (e) {
      print(e);
    }
    try {
      fingerPrintLockEnable =  passwordManager.getAll().last.fingerPrintSwitchOn!;
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title:  Text('Are you sure?'),
            content:  Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                //<-- SEE HERE
                child:  Text('No'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: brightBackgroundColor,
        body: SafeArea(
          child:
         Padding(
              padding: EdgeInsets.all(18.0),
              child: _getPattern.isNotEmpty
                  ? Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(
                            "Draw a pattern to unlock app",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: wrongPassword
                              ? const Text(
                                  "Wrong Pattern",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                )
                              : SizedBox(),
                        ),
                        Flexible(
                          child: PatternLock(
                              showInput: true,
                              selectedColor: lightBackgroundColor,
                              fillPoints: true,
                              notSelectedColor: isDarkMode ? Colors.white : Colors.black,
                              pointRadius: 13,
                              onInputComplete: (List<int> input) async {
                                if (listEquals(input, _getPattern)) {
                                  Navigator.pushNamed(context, "/MultiPageView");
                                } else {
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
                        ): const SizedBox(),
                      ],
                    )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 20.0,bottom: 70),
                          child: Text(
                            "Enter pin to open app",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10,bottom: 65),
                          child: wrongPassword
                              ? const Text(
                                  "Wrong Password",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                )
                              : SizedBox(),
                        ),
                        SizedBox(
                          height: 500,
                          child: PinCodeWidget(
                            centerBottomWidget: fingerPrintLockEnable == true
                                ? IconButton(
                                    onPressed: authenticateWithBiometrics,
                                    icon: const Icon(Icons.fingerprint),
                                  )
                                : const SizedBox(),
                            minPinLength: 4,
                            backgroundColor: brightBackgroundColor,
                            filledIndicatorColor: isDarkMode ? Colors.white : Colors.black,
                            maxPinLength: 4,
                            buttonColor: brightBackgroundColor,
                            onChangedPin: (pin) {},
                            onEnter: (pin, _) async {
                              if (pin == _getPin) {
                                Navigator.pushNamed(context, "/MultiPageView");
                              } else {
                                setState(() {
                                  wrongPassword = true;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
    );
  }
}
