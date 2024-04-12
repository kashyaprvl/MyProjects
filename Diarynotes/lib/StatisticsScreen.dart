import 'dart:math';

import 'package:diarynotes/Data_Manager/Constant.dart';
import 'package:diarynotes/Data_Manager/ObjectBoxDataModel.dart';
import 'package:diarynotes/main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../Data_Manager/AppController.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'Data_Manager/CommonWidget.dart';

class StatisticsScreen extends StatefulWidget {

   const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _InsightsMoodScreenState();
}

class _InsightsMoodScreenState extends State<StatisticsScreen> {

  late DateTime startDate;
  late DateTime endDate;
  late DateTime _currentlyDate;
  DateTime _selectedDate = DateTime.now();

  final ScrollController _scrollController = ScrollController();

  String emojiOfHighestMoodPercentage = "";
  String FormatedStartDate = "";
  String FormatedEndDate = "";

  int checkEmojiOfHighestMoodPercentage = 0;
  int selectedIndex = 0;

  List<String> _emojiTypeSelect = constant.loosetiktokemoji;
  List<fileCreate> createdFileData = [];
  List<String> percentageOfEmojiUse = [];

  List<EmojiLinearChartData> data = [];
   Map<int,double> checkDateTimeWisePercentage = {};

  List<EmojiCircularChartData> emojiMoodChartData = [];


  @override
  void initState() {
    checkPercentageForBar();
    checkSelectedIndex().whenComplete(() {
      // setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToToday());
    super.initState();
  }


  void updateDates(int daysToAdd) {
    setState(() {
      startDate = startDate.add(Duration(days: daysToAdd));
      FormatedStartDate = DateFormat("MMM-dd").format(startDate);
      endDate = endDate.add(Duration(days: daysToAdd));
      FormatedEndDate = DateFormat("MMM-dd").format(endDate);
    });
  }

   checkSelectedIndex() async {
    Map<String, int> emojiCounts = {};
    int totalCount = 0;

    for (var element in createdFileData) {
      String emoji = _emojiTypeSelect[element.emoji];
      if (emojiCounts.containsKey(emoji)) {
        emojiCounts[emoji] = emojiCounts[emoji]! + 1;
      } else {
        emojiCounts[emoji] = 1;
      }
      totalCount++;
    }

    percentageOfEmojiUse = List.generate(_emojiTypeSelect.length, (index) => "0%");
    if (totalCount > 0) {
      for (int i = 0; i < _emojiTypeSelect.length; i++) {
        String emoji = _emojiTypeSelect[i];
        int count = emojiCounts.containsKey(emoji) ? emojiCounts[emoji]! : 0;
        double percentage = (count / totalCount) * 100;
        percentageOfEmojiUse[i] = "${percentage.toStringAsFixed(2)}%";
      }
    }
    final emojiIndex = objectBox.store.box<EmojiIndex>();
    try {selectedIndex = emojiIndex.getAll().last.emojiSelectedIndex!;} catch (e) {/*print("nothing happen bro..");*/}
    if (selectedIndex == 0) {
      _emojiTypeSelect = constant.StickerEmoji;
    } else if (selectedIndex == 1) {
      _emojiTypeSelect = constant.tiktokemoji;
    } else if (selectedIndex == 2) {
      _emojiTypeSelect = constant.UnicornEmoji;
    } else if (selectedIndex == 3) {
      _emojiTypeSelect = constant.PikachuEmoji;
    } else if (selectedIndex == 4) {
      _emojiTypeSelect = constant.CatEmoji;
    }
    return percentageOfEmojiUse;
  }

  checkEmojiSelection() {
    for (int k = 0; k < percentageOfEmojiUse.length; k++) {
      String temporaryPercentageRemove = percentageOfEmojiUse[k].replaceAll('%', '');
      if (temporaryPercentageRemove.contains('.')) {
        List<String> temporary = temporaryPercentageRemove.split('.');
        temporaryPercentageRemove = temporary[0];
      }
      int temporaryPercentageInt = int.parse(temporaryPercentageRemove);
      if (temporaryPercentageInt > checkEmojiOfHighestMoodPercentage) {
        emojiOfHighestMoodPercentage = _emojiTypeSelect[k];
        checkEmojiOfHighestMoodPercentage = temporaryPercentageInt;
      }
    }
    if(emojiOfHighestMoodPercentage.contains("")){
      emojiOfHighestMoodPercentage = _emojiTypeSelect[0];
    }
  }

  @override
  void didChangeDependencies() {
    emojiMoodChartData = [
      EmojiCircularChartData(
          _emojiTypeSelect[0],AppController().parsePercentage(percentageOfEmojiUse[0]),
          Colors.pinkAccent.shade400),
      EmojiCircularChartData(
          _emojiTypeSelect[1], AppController().parsePercentage(percentageOfEmojiUse[1]),
          Colors.yellowAccent.shade400),
      EmojiCircularChartData(
          _emojiTypeSelect[2], AppController().parsePercentage(percentageOfEmojiUse[2]),
          Colors.greenAccent.shade400),
      EmojiCircularChartData(
          _emojiTypeSelect[3], AppController().parsePercentage(percentageOfEmojiUse[3]),
          Colors.blueAccent.shade400),
      EmojiCircularChartData(
          _emojiTypeSelect[4], AppController().parsePercentage(percentageOfEmojiUse[4]),
          Colors.purpleAccent.shade400),
      EmojiCircularChartData(
          _emojiTypeSelect[5], AppController().parsePercentage(percentageOfEmojiUse[5]),
          Colors.redAccent.shade400),
      EmojiCircularChartData(
          _emojiTypeSelect[6], AppController().parsePercentage(percentageOfEmojiUse[6]),
          Colors.deepOrangeAccent.shade400),
      EmojiCircularChartData(
          _emojiTypeSelect[7], AppController().parsePercentage(percentageOfEmojiUse[7]),
          Colors.brown.shade400),
    ];
    data = [
      EmojiLinearChartData(
          1, _emojiTypeSelect[2], AppController().parsePercentage(percentageOfEmojiUse[0])),
      EmojiLinearChartData(
          2, _emojiTypeSelect[0], AppController().parsePercentage(percentageOfEmojiUse[1])),
      EmojiLinearChartData(
          3, _emojiTypeSelect[6], AppController().parsePercentage(percentageOfEmojiUse[2])),
      EmojiLinearChartData(
          4, _emojiTypeSelect[5], AppController().parsePercentage(percentageOfEmojiUse[3])),
      EmojiLinearChartData(
          5, _emojiTypeSelect[4], AppController().parsePercentage(percentageOfEmojiUse[4])),
    ];
    super.didChangeDependencies();
  }


  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    checkEmojiSelection();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: brightBackgroundColor,
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          // bottomNavigationBar: BottomAppBarCreate().bottomNavigationBar(context),
          // floatingActionButton: BottomAppBarCreate().floatingActionButton(context),
          body: SafeArea(
            child: SingleChildScrollView(
              child:  Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 9),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10.px,top: 5.px),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.px, vertical: 10.px),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: lightBackgroundColor
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text("Daily statistics",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        const Spacer(),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                updateDates(-7);
                                              });
                                            },
                                            icon: Icon(
                                              Icons.arrow_left_outlined,
                                              size: 32.px,
                                              fill: 0.1,
                                            )),
                                        Text("$FormatedStartDate -",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700)),
                                        Text(FormatedEndDate,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700)),
                                        _currentlyDate == endDate
                                            ? const Icon(null)
                                            : IconButton(
                                            onPressed: () {
                                              updateDates(7);
                                              _currentlyDate =
                                                  AppController().getEndOfWeek(_selectedDate);
                                              // print(_currentlyDate);
                                            },
                                            icon: Icon(
                                              Icons.arrow_right_outlined,
                                              size: 32.px,
                                            )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 70,
                                    width: double.maxFinite,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: constant.weekDayName.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        List<String> formattedDate = [];
                                        List<String> formattedObjectBoxDate = [];
                                        int count = 0;
                                        DateTime currentDate = startDate;
                                        while (currentDate.isBefore(endDate) ||
                                            currentDate.isAtSameMomentAs(
                                                endDate)) {
                                          var formatDate = DateFormat("dd/MM")
                                              .format(currentDate);
                                          formattedDate.add(formatDate);
                                          currentDate = currentDate
                                              .add(const Duration(days: 1));
                                        }
                                        for (int i = 0;
                                        i < createdFileData.length;
                                        i++) {
                                          var add = DateFormat("dd/MM")
                                              .format(
                                              DateTime.parse(createdFileData[i].dateTime));
                                          formattedObjectBoxDate.add(add);
                                        }
                                        for (int i = 0;
                                        i < createdFileData.length;
                                        i++) {
                                          if (formattedObjectBoxDate[i] ==
                                              formattedDate[index]) {
                                            count++;
                                          }
                                        }
                                        constant.listOfFileCount[index] = count;
                                        var today = DateFormat("dd/MM").format(DateTime.now());
                                        // print("this is current Date ${formattedDate[index]} and this $today and $currentDate and ${DateTime.now()}");
                                        return Container(
                                          height: 5.h,
                                          width: 11.w,
                                          margin: const EdgeInsets.only(right: 5),
                                          decoration: BoxDecoration(
                                            color: today == formattedDate[index] ? brightBackgroundColor : null,
                                              border: Border.all(
                                                  width: 1,color: isDarkMode ? Colors.white : Colors.black),
                                              borderRadius:
                                              BorderRadius.circular(10)),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: Text(constant.weekDayName[index],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                        FontWeight.w700)),
                                              ),
                                              Text(
                                                  constant.listOfFileCount[index]
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight
                                                          .w700)),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, bottom: 10),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: lightBackgroundColor
                                ),
                                child: IntrinsicWidth(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height: 200,
                                        width: 200,
                                        child: SfCircularChart(
                                            margin: EdgeInsets.zero,
                                            annotations: <CircularChartAnnotation>[
                                              CircularChartAnnotation(
                                                  radius: "00%",
                                                  height: "20",
                                                  width: "20",
                                                  widget: Container(
                                                      child: PhysicalModel(
                                                          child: Container(),
                                                          shape: BoxShape.circle,
                                                          elevation: 4,
                                                          shadowColor: Colors.black,
                                                          color: const Color.fromRGBO(
                                                              230, 230, 230, 1)))),
                                              CircularChartAnnotation(
                                                  widget: SizedBox(
                                                      height: 8.h,
                                                      child: Image.asset(emojiOfHighestMoodPercentage))),
                                            ],
                                            series: <CircularSeries>[
                                              DoughnutSeries<
                                                  EmojiCircularChartData,
                                                  String>(
                                                  dataSource: emojiMoodChartData,
                                                  innerRadius: "85%",
                                                  pointColorMapper: (EmojiCircularChartData data, _) => data.color,
                                                  xValueMapper: (EmojiCircularChartData data, _) =>
                                                  data.x,
                                                  yValueMapper: (
                                                      EmojiCircularChartData data,
                                                      _) =>
                                                  data.y,
                                                  animationDuration: 1500, // Animation duration in milliseconds
                                                  radius: '80%')
                                            ]),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 30.px,top: 10.px),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            // crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Flexible(
                                                child: ListView.builder(
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemCount: constant.emojiMoodColors.length,
                                                  shrinkWrap: true,
                                                  itemBuilder: (context, index) {
                                                    return Padding(
                                                      padding: const EdgeInsets.only(
                                                          bottom: 10.0),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize
                                                            .min,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets.only(
                                                                right: 6.0),
                                                            child: CircleAvatar(
                                                                radius: 5,
                                                                backgroundColor:
                                                                constant.emojiMoodColors[
                                                                index]),
                                                          ),
                                                          SizedBox(
                                                            width: 65,
                                                              child: Text(
                                                                constant.emojiMoodTexts[index],
                                                                style: TextStyle(fontSize: 10),
                                                              )),
                                                          Text(percentageOfEmojiUse[
                                                          index],style: TextStyle(fontSize: 10)),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.symmetric(vertical: 15,horizontal: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: lightBackgroundColor
                              ),
                              child: Stack(
                                children: [
                                  _buildEmojiOverlay(data, MediaQuery.sizeOf(context).height),
                                  Stack(
                                    fit: StackFit.loose,
                                    children: [
                                        SizedBox(
                                          height: 32.h,
                                          width: MediaQuery.sizeOf(context).width * 0.9,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 38.0),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              controller: _scrollController,
                                              child: SizedBox(
                                                width: 800,
                                                child: BarChart(
                                                  BarChartData(
                                                    barGroups: _buildBarGroups(),
                                                    groupsSpace: 50,
                                                    extraLinesData: const ExtraLinesData(extraLinesOnTop: true),
                                                    maxY: 50,
                                                    minY: 10,
                                                    borderData: FlBorderData(
                                                        border: const Border(bottom: BorderSide(), left: BorderSide())),
                                                    gridData: const FlGridData(show: false),
                                                    titlesData:  const FlTitlesData(
                                                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ),
            ),
          )),
    );
  }
  Future<bool> _onWillPop() {
   Navigator.pushNamed(context, "//MultiPageView");
    return Future.value(false);
  }


  void scrollToToday() {
    int todayIndex = DateTime.now().day - 1; // Assuming days start at 1
    double barWidth = 25; // Width of each bar, adjust as needed
    double offset = barWidth * todayIndex;
    _scrollController.animateTo(offset,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void checkPercentageForBar() {
      startDate = AppController().getStartOfWeek(_selectedDate);
      endDate = AppController().getEndOfWeek(_selectedDate);
      FormatedStartDate = DateFormat("dd/MM").format(startDate);
      FormatedEndDate = DateFormat("dd/MM").format(endDate);
      _currentlyDate = AppController().getEndOfWeek(_selectedDate);
    createdFileData = userBox.getAll();
    String currentMonth = DateFormat("MMM").format(DateTime.now());

    Map<int, List<int>> tempData = {};
    for (var element in createdFileData) {
      String checkDate = DateFormat("MMM").format(DateTime.parse(element.dateTime));
      if (currentMonth == checkDate) {
        int dt = int.parse(DateFormat("dd").format(DateTime.parse(element.dateTime)));
        tempData.putIfAbsent(dt, () => []).add(element.emoji);
      }
    }

    tempData.forEach((key, emojis) {
      Map<int, int> emojiWeights = {0: 50, 2: 50, 1: 40, 3: 40, 4: 10, 7: 10, 6: 30, 5: 20};
      double totalWeight = emojis.fold(0, (sum, emoji) => sum + (emojiWeights[emoji] ?? 0));
      double averageWeight = emojis.isEmpty ? 12 : max(totalWeight / emojis.length, 12);
      checkDateTimeWisePercentage[key] = averageWeight;
    });
  }


  List<BarChartGroupData> _buildBarGroups() {
    int monthDays = AppController().checkDaysOfThisMonth();
    int plus = -1;
   List<double> checkDateTimeData = [];
    return List.generate(monthDays, (index) {
      bool date = checkDateTimeWisePercentage.keys.contains(index + 1);
      var iterator = checkDateTimeWisePercentage.values;
      if(date){
        plus++;
       iterator.forEach((element) {
         checkDateTimeData.add(element);
       });

      }
      double barHeight = date ? checkDateTimeData[plus] : 50;
      Color barColor = Colors.transparent;
      switch(barHeight){
        case >= 45 :
          barColor =  Colors.greenAccent.shade200;
          break;
        case (>= 35 && <=44) :
          barColor =  Colors.pinkAccent.shade200;
          break;
        case (>= 25 && <= 34) :
          barColor =  Colors.orangeAccent.shade200;
          break;
        case (>= 15 && <= 24) :
          barColor =  Colors.redAccent.shade200;
          break;
        case (>= 10 && <= 14) :
          barColor =  Colors.deepPurpleAccent.shade200;
          break;

      }
      return BarChartGroupData(
        x: index + 1,
        barRods: [
          BarChartRodData(
            toY: 50,
            // borderRadius: BorderRadius.circular(4),
            color: Colors.grey,
            rodStackItems: [BarChartRodStackItem(0, barHeight, date ? /*(isDarkMode ? Colors.white : Colors.black)*/barColor : Colors.grey)],
            width: 10,
          ),
        ],
      );
    });
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget _buildEmojiOverlay(List<EmojiLinearChartData> data, double chartHeight) {
    return Positioned.fill(
      left: -20,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: data
                .asMap()
                .entries
                .map((entry) {
              int index = entry.key;
              EmojiLinearChartData chartData = entry.value;
              double xPosFactor = (chartHeight / data.length) - 65;
              double xPos = xPosFactor * index +
                  (xPosFactor / 8.0) -
                  (242); // Adjust "- 10" for the emoji's half-width
              return Positioned(
                top: xPos,
                left: 20,
                bottom: -2, // Adjust this value based on your layout
                child: Image.asset(chartData.emojiType, width: 8.w, height: 2.h),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
  class EmojiLinearChartData {
  final int day;
  final String emojiType;
  final double percentage;

  EmojiLinearChartData(this.day, this.emojiType, this.percentage);
}



class EmojiCircularChartData {
  EmojiCircularChartData(this.x, this.y, this.color);

  final String x;
  final double y;
  final Color color;
}
