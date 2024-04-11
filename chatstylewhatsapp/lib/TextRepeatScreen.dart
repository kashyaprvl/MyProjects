import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:share_whatsapp/share_whatsapp.dart';

class RepeatMsjScreen extends StatefulWidget {
  const RepeatMsjScreen({super.key});

  @override
  State<RepeatMsjScreen> createState() => _RepeatMsjScreenState();
}

class _RepeatMsjScreenState extends State<RepeatMsjScreen> {

  List<String> SaveText = [];
  String SingleText = "";
  int RepeatNum = 0;
  bool _validate = false;
  bool _validates = false;
  bool MsjPrint = false;
  bool CheckValue = true;
  TextEditingController _MsjController = TextEditingController();
  TextEditingController _RptController = TextEditingController();
  TextEditingController _NumController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    return GestureDetector(
      onTap: () {
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
            title: const Text("Text Repeater",
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
                        top: 10.0, right: 12.00,left: 12.00,bottom: 6),
                    child: Text("Enter Message",
                        style: TextStyle(
                            fontFamily: "poppins",
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255,40, 159, 72))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 14.0,bottom: 6, right : 12.00,left: 12.00),
                    child: SizedBox(
                        height: 70,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 200,
                        child: TextFormField(
                          maxLines: 1,
                          maxLength: 30,
                          controller: _MsjController,
                          decoration: InputDecoration(
                            errorText: _validate ? 'Value Can\'t Be Empty' : null,
                            hintText: "Enter a Message",
                            border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(style: BorderStyle.solid,width: 4),
                            )
                          ),
                        )),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                        top : 10,bottom: 6,right: 12.00,left: 12.00),
                    child: Text("Enter Repetition Limit",
                        style: TextStyle(
                            fontFamily: "poppins",
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255,40, 159, 72))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0,bottom: 6,right: 12.00,left: 12.00),
                    child: SizedBox(
                      height: 70,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 200,
                      child: TextFormField(
                        controller: _NumController,
                        onChanged: (v) async{
                           RepeatNum = int.parse(_NumController.text);
                        },
                        maxLines: 1,
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          errorText: _validates ? 'Value Can\'t Be Empty' : null,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                style: BorderStyle.solid, width: 4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          hintText: "Enter Repetition Limit",
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: Color.fromARGB(255,40, 159, 72),
                        value: CheckValue,
                        onChanged: (bool? value) {
                          setState(() {
                             CheckValue = value!;
                          });
                      },),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Text("New Line",style: TextStyle(fontSize: 16),),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                    child : SingleChildScrollView(
                      child:
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2,style: BorderStyle.solid)
                        ),
                        width: MediaQuery.of(context).size.width * 200,
                        height: 300,
                        child: ListView.builder(
                          itemCount: RepeatNum,
                          itemBuilder: (context, index) {
                            if(CheckValue == true) {
                              return MsjPrint
                                  ? Text(SaveText[index]) : null;
                            }
                            else {
                              final joinedText = SaveText.join(' ');
                              return MsjPrint && index == 0
                                  ?  Text(joinedText) : null;
                            }
                        },),
                      )
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top : 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 4,
                              backgroundColor: Color.fromARGB(255, 201, 249, 213)
                            ),
                              onPressed: () {
                                int i =0;
                                SaveText.clear(); // Clear previous messages
                               for(int i=0;i<RepeatNum;i++){
                                  SaveText.add(_MsjController.text);
                               }
                                 setState(() {
                                   _MsjController.text.isEmpty ? _validate = true : _validate = false;
                                   _NumController.text.isEmpty ? _validates = true : _validates = false;
                                   if(MsjPrint == false){
                                     MsjPrint = !MsjPrint;
                                   }
                                   else {
                                    MsjPrint = MsjPrint;
                                   }
                                 });
                          }, child: const Text("Generate",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,fontFamily: "poppins",color: Color.fromARGB(255, 40, 159, 72,)
                          ),)),
                        ),
                        SizedBox(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 201, 249, 213),
                              elevation: 4,
                            ),
                              onPressed: () {
                                SaveText.forEach((element) {
                                SingleText = element;
                                });
                                print("Single text is $SingleText");
                                // openWhatsapp(context: context,text: _RptController.text);
                               ShareWhatsapp().shareText(type: WhatsApp.standard,
                                   CheckValue ? SaveText.join("\n") : SaveText.join(),);
                                ShareWhatsappUrl().share(text: _RptController.text);
                              }, child: const Text("Whatsapp",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600,fontFamily: "poppins",color: Color.fromARGB(255, 40, 159, 72,)),)),
                        ),
                        SizedBox(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 201, 249, 213),
                                elevation: 4,
                              ),
                              onPressed: () {
                                setState(() {
                                 Share.share(
                                     CheckValue ? SaveText.join("\n") : SaveText.join()
                                 );
                                });
                              }, child: const Text("Share",style: TextStyle(fontSize: 14,fontWeight : FontWeight.w600,fontFamily: "poppins",color: Color.fromARGB(255, 40, 159, 72,)),)),
                        ),
                      ],
                    ),
                  )
                ]),
          )),
    );
  }
  }
