import 'dart:convert';
import 'dart:io';
import 'package:chatstylewhatsapp/jsonconverter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:url_launcher/url_launcher.dart';

class SendMsgScreen extends StatefulWidget {
  const SendMsgScreen({super.key});

  @override
  State<SendMsgScreen> createState() => _SendMsgScreenState();
}

class _SendMsgScreenState extends State<SendMsgScreen> {

  bool _validate = false;
  bool _validates = false;
  JsonData? data;
  int k = 0;
  var CompletePhoneNumber = "";
  List JsonDetail = [];
  TextEditingController _numcontroller = TextEditingController();
  TextEditingController _msjcontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadJson();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(onPressed: (){
              Navigator.of(context).pop();
            }, icon: Image.asset("asset/images/left-chevron.png",height: 25),),
            centerTitle: true,
            title: const Text("What's App Direct Chat",
                style: TextStyle(
                    fontFamily: "Baloo",
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(
                      255,
                      251,
                      246,
                      250,
                    ))),
            elevation: 10,
            backgroundColor: Color.fromARGB(255, 40, 159, 72),
          ),
          body: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                       top : 10.0,left: 12.00,bottom: 5.00, right: 12.00),
                    child: Text("Enter Number",
                        style: TextStyle(
                            fontFamily: "poppins",
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 40, 159, 72))),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.00),
                    child: SizedBox(
                        height: 80,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 200,
                        child:
                        IntlPhoneField(
                          initialCountryCode: 'IN',
                          onChanged: (phone) {
                              CompletePhoneNumber = phone.completeNumber;
                            print(phone.completeNumber);
                          },
                          dropdownIcon: Icon(Icons.arrow_drop_down,size: 30,color: Color.fromARGB(255,52, 1, 63)),
                          textAlignVertical: TextAlignVertical.top,
                          textAlign: TextAlign.justify,
                           dropdownTextStyle: TextStyle(leadingDistribution: TextLeadingDistribution.proportional),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.singleLineFormatter,
                          ],
                          style: TextStyle(fontSize: 15,height: 1.4),
                          textInputAction: TextInputAction.send,
                          keyboardType: TextInputType.phone,
                          dropdownDecoration: BoxDecoration(),
                          controller: _numcontroller,
                          dropdownIconPosition: IconPosition.leading,
                          decoration: InputDecoration(
                            errorText: _validate ? 'Value Can\'t Be Empty' : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                BorderSide(width: 2, style: BorderStyle.solid),
                              )),
                        )),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.00),
                    child: Text("Enter Message",
                        style: TextStyle(
                            fontFamily: "poppins",
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255,40, 159, 72))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _msjcontroller,
                      maxLines: 10,
                      maxLength: 1000,
                      decoration: InputDecoration(
                        errorText: _validates ? 'Value Can\'t Be Empty' : null,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              style: BorderStyle.solid, width: 2),
                          borderRadius: BorderRadius.circular(4),
                          gapPadding: 3,
                        ),
                        hintText: "Enter a Message",
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(8),
                      child: Center(
                        child: SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255,201, 249, 213,),
                              elevation: 5,
                            ),
                            child: const Text("Send", style: TextStyle(
                                fontFamily: "poppins",
                                color: Color.fromARGB(255,40, 159, 72),
                                fontSize: 20, fontWeight: FontWeight.w600)),
                            onPressed: () {
                              setState(() {
                                _numcontroller.text.isEmpty ? _validate = true : _validate = false;
                                _msjcontroller.text.isEmpty ? _validates = true : _validates = false;
                                if(_numcontroller.text.isNotEmpty) {
                                  openWhatsapp(number: CompletePhoneNumber,
                                      text: _msjcontroller.text,
                                      context: context);
                                }
                                print("this is the value ${_numcontroller.text}");
                              });
                            },
                          ),
                        ),
                      ))
                ]),
          )),
    );
  }

  loadJson() async {
    var jsonString = await rootBundle.loadString('asset/json/country.json');
    data = JsonData.fromJson(json.decode(jsonString));
    JsonDetail = data!.data;
    setState(() {});
  }

  void openWhatsapp(
      {required BuildContext context,
        required String text,
        required String number}) async {
    var whatsapp = number;
    var whatsappURlAndroid =
        "whatsapp://send?phone=${whatsapp}&text=$text";
    var whatsappURLIos = "https://wa.me/$whatsapp?text=${Uri.tryParse(text)}";
    if (Platform.isIOS) {
      if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
        await launchUrl(Uri.parse(
          whatsappURLIos,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Whatsapp not installed")));
      }
    } else {
      if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
        await launchUrl(Uri.parse(whatsappURlAndroid));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Whatsapp not installed")));
      }
    }
  }
}
